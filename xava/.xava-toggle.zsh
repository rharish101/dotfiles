#!/usr/bin/zsh
read -r -d '' usage <<EOF
Usage: $(basename $0) [OPTION]... [PATH]...
Toggle audio spectrum visualizer

    -h, --help                  Display help and exit
    -f, --force {start,stop}    Force XAVA to start or stop
EOF

export POLL_DELAY=0.5  # delay for polling a background process
setopt LOCAL_OPTIONS NO_NOTIFY NO_MONITOR  # hide zsh output for background processes

notify () { notify-send --app-name=XAVA --icon=xava XAVA "$*" }

fork_and_poll ()
{
    eval "$*" &
    local pid=$!
    sleep $POLL_DELAY
    ps -p $pid &>/dev/null || return 1
}

start_xava ()
{
    fork_and_poll xava || (notify "Error encountered" && return 1)

    local num_monitors=$(xrandr --query | grep -c " connected")
    if (( num_monitors == 2 )); then
        start_second_xava || echo "WARNING: Could not open XAVA for the second monitor"
    fi

    fork_and_poll devilspie2 || (notify "Error encountered" && return 1)
    notify "XAVA started"
}

# For two monitor setup (NOT side-by-side setup)
start_second_xava ()
{
    fork_and_poll xava || return 1
    local second_xava=$(xdotool search --class XAVA | tail -n1)
    xdotool set_window --name XAVA1 $second_xava
}

stop_xava ()
{
    local quiet="$1"
    pkill -x -KILL xava # sometimes SIGKILL is required
    pkill -x devilspie2
    if [[ "$quiet" != "--quiet" ]]; then
        notify "XAVA stopped"
    fi
}

force_arg=
while [[ -n "$1" ]]; do
    case "$1" in
        -h|--help)
            echo "$usage"
            exit 0
            ;;
        -f|--force)
            force_arg="$2"
            shift

            if [[ "$force_arg" != "start" ]] && [[ "$force_arg" != "stop" ]]; then
                echo "$usage"
                exit 1
            fi
            ;;
        *)
            echo "$usage"
            exit 1
    esac
    shift
done

if [[ -z "$(pgrep -x xava)" ]]; then
    if [[ $force_arg != "stop" ]]; then
        start_xava || (stop_xava --quiet && return 1)  # ensure that XAVA is definitely not running
    fi
elif [[ $force_arg != "start" ]]; then
    stop_xava
fi
