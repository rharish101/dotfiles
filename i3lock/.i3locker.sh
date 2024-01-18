#!/bin/sh

# SPDX-FileCopyrightText: 2018 Harish Rajagopal <harish.rajagopals@gmail.com>
#
# SPDX-License-Identifier: MIT

dpms_locked="10 300 0"
image="$HOME/.local/share/backgrounds/i3locker-background.png"

usage="Usage: $(basename $0) [-h] [-d LockedDpms] [-i Image]

Use i3lock-color to lock the screen, with DPMS support

    -h, --help        Display help and exit
    -d LockedDpms, --dpms LockedDpms
                      DPMS settings when locked (default: $dpms_locked)
    -i Image, --image Image
                      Background image (default: $image)"

dpms_set ()
{
    xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/presentation-mode -s false

    while true; do
        local dpms_curr="$(xset q | awk '/Standby/{print $2, $4, $6}')"
        if [[ "$dpms_curr" != "$dpms_locked" ]]; then
            xset dpms $dpms_locked
        fi
        sleep 5
    done
}

dpms_revert ()
{
    xset dpms $dpms_unlocked
}

ARGS=(
    --ignore-empty-password
    --pointer=default
    --indicator
    --radius=25
    --inside-color=383C4A00
    --insidever-color=383C4A00
    --insidewrong-color=ED071700
    --line-uses-inside
    --ring-width=6
    --ring-color=D3DAE388
    --ringver-color=D3DAE333
    --verif-color=D3DAE300
    --verif-text=''
    --ringwrong-color=ED0717AA
    --wrong-color=D3DAE300
    --wrong-text=''
    --modif-color=D3DAE300
    --keyhl-color=D3DAE3FF
    --bshl-color=ED0717AA
    --separator-color=1A162800
    --ind-pos='350:1010'
    --force-clock
    --time-color=D3DAE3FF
    --time-str='%H:%M'
    --time-size=32
    --time-align=1
    --time-pos='40:1005'
    --time-font='roboto'
    --date-color=D3DAE3FF
    --date-str='Type password to unlock'
    --date-size=20
    --date-align=1
    --date-pos='40:1037'
    --date-font='roboto'
)

# dpms_unlocked="$(xset q | awk '/Standby/{print $2, $4, $6}')"
dpms_unlocked="300 0 0"

while [[ -n "$1" ]]; do
    case "$1" in
        -h|--help)
            echo "$usage"
            exit 0
            ;;
        -d|--dpms)
            dpms_locked="$2"
            shift
            ;;
        -i|--image)
            image="$2"
            shift
            ;;
        *)
            echo "$usage"
            exit 1
    esac
    shift
done

trap dpms_revert HUP INT TERM
dpms_set &
dpms_pid=$!

i3lock --nofork -i "$image" "${ARGS[@]}"

kill -9 $dpms_pid
dpms_revert
