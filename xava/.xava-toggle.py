#!/usr/bin/env python
"""Toggle the state of XAVA."""
import argparse
import os
from subprocess import CalledProcessError, Popen, check_call, check_output
from time import sleep

ICON = os.path.expanduser("~/.local/share/icons/xava.png")  # XAVA icon path
DELAY = 0.5  # delay after calling process for polling status


def notify(msg):
    """Send a XAVA notification with the given message."""
    Popen(
        [
            "notify-send",
            "--app-name",
            "XAVA Visualizer",
            "--icon",
            ICON,
            "XAVA",
            msg,
        ]
    )


def main(args):
    """Run the main program.

    Arguments:
        args (`argparse.Namespace`): The object containing the commandline
            arguments

    """
    try:
        check_call(["pgrep", "xava"])

    except CalledProcessError:  # no XAVA process running, so start
        if args.force != "stop":
            xava = Popen(["xava"])

            # For two monitor setup (NOT side-by-side setup)
            xrandr = check_output(["xrandr", "--query"]).decode("utf8")
            monitors = 0
            for line in xrandr.split("\n"):
                # Whitespace is used to prevent matching "disconnected"
                if " connected" in line:
                    monitors += 1

            if monitors == 2:
                xava2 = Popen(["xava"])
                wids = (
                    check_output(["xdotool", "search", "--class", "XAVA"])
                    .decode("utf8")
                    .split("\n")
                )
                Popen(["xdotool", "set_window", "--name", "XAVA1", wids[-1]])

            dvlsp = Popen(["devilspie2"])

            sleep(DELAY)  # wait to avoid prematurly determining process state
            if (
                (xava.poll() is None)
                and (monitors != 2 or xava2.poll() is None)
                and (dvlsp.poll() is None)
            ):
                notify("XAVA started")
            else:
                notify("Error encountered")
                # Clear all devilspie processes, as they are unnecessary
                Popen(["pkill", "devilspie2"])

    else:  # XAVA running, so stop
        if args.force != "start":
            Popen(["pkill", "xava"])
            Popen(["pkill", "devilspie2"])
            notify("XAVA stopped")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Toggle audio spectrum visualizer"
    )
    parser.add_argument(
        "-f",
        "--force",
        metavar="",
        type=str,
        choices=["start", "stop"],
        help="force xava to start or stop",
    )
    main(parser.parse_args())
