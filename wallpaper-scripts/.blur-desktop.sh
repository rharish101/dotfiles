#!/usr/bin/zsh

# Do getopts stuff
# https://stackoverflow.com/a/29754866/7905483

! getopt --test > /dev/null
if [[ ${pipestatus[1]} -ne 4 ]]; then
    echo "I’m sorry, `getopt --test` failed in this environment."
    exit 1
fi

OPTIONS=w:b:
LONGOPTS=wall-dir:,blur-dir:

# -use ! and pipestatus to get exit code with errexit set
# -temporarily store output to be able to check for errors
# -activate quoting/enhanced mode (e.g. by writing out “--options”)
# -pass arguments only via   -- "$@"   to separate them correctly
! PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")
if [[ ${pipestatus[1]} -ne 0 ]]; then
    # e.g. return value is 1
    #  then getopt has complained about wrong arguments to stdout
    exit 2
fi
# read getopt’s output this way to handle the quoting right:
eval set -- "$PARSED"

wall_path="/home/rharish/Pictures/Wallpapers"
blur_path="$HOME/.blurred_wallpapers/"
# now enjoy the options in order and nicely split until we see --
while true; do
    case "$1" in
        -w|--wall-dir)
            wall_path="$2"
            shift 2
            ;;
        -b|--blur-dir)
            blur_path="$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Programming error"
            exit 3
            ;;
    esac
done

# Script starts!!!

make_blurred ()
{
    img=$1
    wallp=`echo $img | rev | cut -d / -f 1 | rev`
    if [ ! -f "${wall_path}/${wallp}" ]
    then
        cp $img $wall_path
    fi
    if [ ! -d $blur_path ]
    then
        mkdir -p $blur_path
    fi
    for i in `seq 1 3`
    do
        if [ ! -d "${blur_path}/Level_$i" ]
        then
            mkdir -p "${blur_path}/Level_$i"
        fi
    done
    convert $img -channel RGBA -blur 0x3 -quality 100 "${blur_path}/Level_1/${wallp}"
    convert $img -channel RGBA -blur 0x6 -quality 100 "${blur_path}/Level_2/${wallp}"
    convert $img -channel RGBA -blur 0x9 -quality 100 "${blur_path}/Level_3/${wallp}"
}

# Blur a single monitor
blur_monitor ()
{
    monitor=$1
    img=`xfconf-query --channel xfce4-desktop --property "/backdrop/screen0/monitor${monitor}/workspace0/last-image"`
    wallp=`echo $img | rev | cut -d / -f 1 | rev`
    if [ ! -f "${blur_path}/Level_1/${wallp}" ]
    then
        make_blurred $img
    fi
    xfconf-query --channel xfce4-desktop --property "/backdrop/screen0/monitor${monitor}/workspace0/last-image" --set "${blur_path}/Level_1/${wallp}"
    sleep 0.1
    xfconf-query --channel xfce4-desktop --property "/backdrop/screen0/monitor${monitor}/workspace0/last-image" --set "${blur_path}/Level_2/${wallp}"
    sleep 0.1
    xfconf-query --channel xfce4-desktop --property "/backdrop/screen0/monitor${monitor}/workspace0/last-image" --set "${blur_path}/Level_3/${wallp}"
}

# Unblur a single monitor
unblur_monitor ()
{
    monitor=$1
    img=`xfconf-query --channel xfce4-desktop --property "/backdrop/screen0/monitor${monitor}/workspace0/last-image"`
    wallp=`echo $img | rev | cut -d / -f 1 | rev`
    folder=`echo $img | rev | cut -d / -f 2 | rev`
    if [ ! -f "${blur_path}/Level_1/${wallp}" ]
    then
        make_blurred $img
    elif [[ $folder == "Level"* ]]
    then
        xfconf-query --channel xfce4-desktop --property "/backdrop/screen0/monitor${monitor}/workspace0/last-image" --set "${blur_path}/Level_2/${wallp}"
        sleep 0.1
        xfconf-query --channel xfce4-desktop --property "/backdrop/screen0/monitor${monitor}/workspace0/last-image" --set "${blur_path}/Level_1/${wallp}"
        sleep 0.1
        xfconf-query --channel xfce4-desktop --property "/backdrop/screen0/monitor${monitor}/workspace0/last-image" --set "${wall_path}/${wallp}"
    fi
}

# Blur/Unblur the desktop
blur_desktop ()
{
    blur=$1
    if [ $blur = true ]
    then
        win_monitor=$2
    fi

    for monitor in 0 1
    do
        if [ $blur = true ] && [[ $monitor == $win_monitor ]]
        then
            blur_monitor $monitor &
        else
            unblur_monitor $monitor &
        fi
    done
    wait
}

IFS=$'\n'
blur=false
status_file="/tmp/.wall_blur"
while true
do
    if [ ! -f $status_file ]
    then
        touch $status_file
    fi

    blur_process()
    {
        while [[ `cat $status_file | head -1` == 'transition' ]]
        do
            sleep 0.5
        done
        blur_desktop false
        blur=false
        echo -e "static\nclear\nclear" > $status_file

        while true
        do
            trap break CONT
            sleep 1
        done
    }
    trap blur_process TSTP

    windows=false
    focus_info=`xwininfo -id $(xprop -root | awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print $NF}')`
    focus_loc=`echo $focus_info | awk '/Absolute upper-left X/{print $4}'`
    focus_name=`echo $focus_info | awk '/xwininfo/{print $5}'`

    prev_monitor=$curr_monitor
    if (( $focus_loc < 1920 ))
    then
        curr_monitor=0
    else
        curr_monitor=1
    fi

    if [[ `cat $status_file | head -1` == 'transition' ]]
    then
        continue
    elif [[ $focus_name == '"Desktop"' ]] && [ $blur = true ]
    then
        blur_desktop false
        blur=false
        echo -e "static\nclear\nclear" > $status_file
    elif [[ $focus_name != '"Desktop"' ]] && ([ $blur = false ] || [[ $prev_monitor != $curr_monitor ]])
    then
        blur_desktop true $curr_monitor
        blur=true
        if (( $curr_monitor == 0 ))
        then
            echo -e "static\nblur\nclear" > $status_file
        else
            echo -e "static\nclear\nblur" > $status_file
        fi
    fi

    sleep 0.5
done
