#!/usr/bin/zsh

wall_path="/home/rharish/Pictures/Wallpapers/Normal"
blur_path="/home/rharish/Pictures/Wallpapers/Blurred"

make_blurred ()
{
    img=$1
    wallp=`echo $img | rev | cut -d / -f 1 | rev`
    if [ ! -f "${wall_path}/${wallp}" ]
    then
        cp $img $wall_path
    fi
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
status_file="/home/rharish/.wall_blur"
while true
do
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
