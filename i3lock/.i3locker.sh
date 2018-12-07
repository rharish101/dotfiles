#!/usr/bin/zsh
# Do getopt stuff
# https://stackoverflow.com/a/29754866/7905483

! getopt --test > /dev/null
if [[ ${pipestatus[1]} -ne 4 ]]; then
    echo "I’m sorry, `getopt --test` failed in this environment."
    exit 1
fi

OPTIONS=d:i:h
LONGOPTS=dpms:,image:,help

# -use ! and pipestatus to get exit code with errexit set
# -temporarily store output to be able to check for errors
# -activate quoting/enhanced mode (e.g. by writing out “--options”)
# -pass arguments only via   -- "$@"   to separate them correctly
! PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")
if [[ ${pipestatus[1]} -ne 0 ]]; then
    # e.g. return value is 1
    #  then getopt has complained about wrong arguments to stdout
    echo $usage
    exit 2
fi
# read getopt’s output this way to handle the quoting right:
eval set -- "$PARSED"

do_help=false
disable_help=false
dpms_locked="10 10 10"
image="$HOME/.local/share/backgrounds/i3locker-background.png"

usage="Usage: `basename $0` [-h] [-d LockedDpms] [-i Image]
    \rUse i3lock-color to lock the screen with multi-monitor support

    \r    -h, --help        Display help and exit
    \r    -d LockedDpms, --dpms LockedDpms
    \r                      DPMS settings when locked (default: $dpms_locked)
    \r    -i Image, --image Image
    \r                      Background image (default: $image)"

# now enjoy the options in order and nicely split until we see --
while true; do
    case "$1" in
        -h|--help)
            do_help=true
            shift
            ;;
        -d|--dpms)
            dpms_locked="$2"
            disable_help=true
            shift 2
            ;;
        -i|--image)
            image="$2"
            disable_help=true
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

# handle non-option arguments
if [[ $# -ne 0 ]]; then
    echo $usage
    exit -1
fi

if [ $do_help = true ]; then
    echo $usage
    if [ $disable_help = true ]; then
        exit -1
    else
        exit 0
    fi
fi

# Script starts!!!

dpms_revert()
{
    sh -c "xset dpms $dpms_unlocked"
    pkill -P $$
}
trap dpms_revert HUP INT TERM

dpms_set()
{
    while true; do
        dpms_stat=$(xset q | grep "Standby" | awk '{print $2, $4, $6}')
        if [[ $dpms_stat != $dpms_locked ]]; then
            sh -c "xset dpms $dpms_locked"
        fi
        sleep 5
    done
}
# xautolock -enable

dpms_unlocked=$(xset q | grep "Standby" | awk '{print $2, $4, $6}')
num_monitors=`xrandr --query | grep " connected" | wc -l`
eog -f -g $image --class="i3lock" &
if [[ $num_monitors == 2 ]]
then
    eog -n -f -g $image --class="i3lock-1" &
fi

sleep 0.5
dpms_set &
# /home/rharish/.multi-lock -i $image -a "-n -e -p default --composite --indicator -k --radius 25 --insidecolor=383C4A00 --insidevercolor=383C4A00 --insidewrongcolor=BE384100 --line-uses-inside --ring-width=6 --ringcolor=D3DAE3AA --ringvercolor=D3DAE355  --verifcolor=D3DAE300 --veriftext=\"\" --ringwrongcolor=BE3841AA --wrongcolor=D3DAE300 --wrongtext=\"\" --keyhlcolor=1A1628FF --bshlcolor=BE3841AA --separatorcolor=1A162800 --indpos=\"350:1010\" --force-clock --timecolor=D3DAE3AA --timestr=\"%H:%M\" --timesize=32 --time-align=1 --timepos=\"40:1005\" --time-font=roboto-light --datecolor=D3DAE3AA --datestr=\"Type password to unlock\" --datesize=20 --date-align=1 --datepos=\"40:1037\" --date-font=roboto-light"
$HOME/.multi-lock -i $image -a "-n -e -p default --composite --indicator -k --radius 25 --insidecolor=383C4A00 --insidevercolor=383C4A00 --insidewrongcolor=ED071700 --line-uses-inside --ring-width=6 --ringcolor=D3DAE388 --ringvercolor=D3DAE333  --verifcolor=D3DAE300 --veriftext=\"\" --ringwrongcolor=ED0717AA --wrongcolor=D3DAE300 --wrongtext=\"\" --keyhlcolor=D3DAE3FF --bshlcolor=ED0717AA --separatorcolor=1A162800 --indpos=\"350:1010\" --force-clock --timecolor=D3DAE3FF --timestr=\"%H:%M\" --timesize=32 --time-align=1 --timepos=\"40:1005\" --time-font=roboto-light --datecolor=D3DAE3FF --datestr=\"Type password to unlock\" --datesize=20 --date-align=1 --datepos=\"40:1037\" --date-font=roboto-light"
killall eog
dpms_revert
