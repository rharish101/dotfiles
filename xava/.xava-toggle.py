#!/usr/bin/env python
"""Toggle the state of XAVA."""
import os
from subprocess import Popen, PIPE
from time import sleep
import argparse

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
args = parser.parse_args()

home_dir = os.path.expanduser("~")

pgrep = Popen(["pgrep", "xava"], stdout=PIPE)
pid_list = list(map(int, pgrep.stdout.read().strip().split()))
if len(pid_list) > 0 and args.force != "start":
    for pid in pid_list:
        os.kill(pid, 15)
    pgrep = Popen(["pgrep", "devilspie2"], stdout=PIPE)
    devilspie_list = list(map(int, pgrep.stdout.read().strip().split()))
    for pid in devilspie_list:
        os.kill(pid, 15)
    Popen(
        [
            "notify-send",
            "--app-name='XAVA visualizer'",
            "XAVA",
            "XAVA stopped",
            "--icon=" + home_dir + "/.local/share/icons/xava.png",
        ]
    )
elif len(pid_list) == 0 and args.force != "stop":
    xava = Popen(["xava"])

    # For two monitor setup (NOT side-by-side setup)
    proc = Popen(["xrandr", "--query"], stdout=PIPE)
    out, err = proc.communicate()
    monitors = len(
        [0 for line in out.decode("ASCII").split("\n") if " connected" in line]
    )
    if monitors == 2:
        xava2 = Popen(["xava"])
        pids = Popen(["xwininfo", "-root", "-tree"], stdout=PIPE)
        out, err = pids.communicate()
        wids = [
            line.split()[0]
            for line in out.decode("ASCII").split("\n")
            if "XAVA" in line
        ]
        print(wids)
        Popen(["xdotool", "set_window", "--name", "XAVA1", wids[-1]])

    devilspie = Popen("devilspie2")
    sleep(0.4)

    # Send desktop notification
    if (
        (xava.poll() is None)
        and (monitors != 2 or xava2.poll() is None)
        and (devilspie.poll() is None)
    ):
        Popen(
            [
                "notify-send",
                "--app-name='XAVA visualizer'",
                "XAVA",
                "XAVA started",
                "--icon=" + home_dir + "/.local/share/icons/xava.png",
            ]
        )
    else:
        Popen(
            [
                "notify-send",
                "--app-name='XAVA visualizer'",
                "XAVA",
                "Error encountered",
                "--icon=" + home_dir + "/.local/share/icons/xava.png",
            ]
        )
        pgrep = Popen(["pgrep", "devilspie2"], stdout=PIPE)
        devilspie_list = list(map(int, pgrep.stdout.read().strip().split()))
        for pid in devilspie_list:
            os.kill(pid, 15)
