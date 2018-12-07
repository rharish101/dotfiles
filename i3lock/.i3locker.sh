#!/usr/bin/env sh
dpms_locked="10 10 10"
image="$HOME/.local/share/backgrounds/i3locker-background.png"

dpms_revert()
{
    sh -c "xset dpms $dpms_unlocked"
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
kill $(jobs -p)
dpms_revert
