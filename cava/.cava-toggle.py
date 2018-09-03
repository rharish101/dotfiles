#!/usr/bin/env python
import os
from subprocess import Popen, PIPE
from time import sleep
import argparse

parser = argparse.ArgumentParser(
    description="Toggle audio spectrum " "visualizer"
)
parser.add_argument(
    "-f",
    "--force",
    metavar="",
    type=str,
    choices=["start", "stop"],
    help="force cava to start or stop",
)
args = parser.parse_args()

pgrep = Popen(["pgrep", "cava"], stdout=PIPE)
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
            "--app-name='CAVA visualizer'",
            "CAVA",
            "CAVA stopped",
            "--icon=/home/rharish/.local/share/icons/cava.png",
        ]
    )
elif len(pid_list) == 0 and args.force != "stop":
    cava = Popen(["cava"])

    # For two monitor setup (NOT side-by-side setup)
    proc = Popen(["xrandr", "--query"], stdout=PIPE)
    out, err = proc.communicate()
    monitors = len(
        [0 for line in out.decode("ASCII").split("\n") if " connected" in line]
    )
    if monitors == 2:
        cava2 = Popen(["cava"])
        pids = Popen(["xwininfo", "-root", "-tree"], stdout=PIPE)
        out, err = pids.communicate()
        wids = [
            line.split()[0]
            for line in out.decode("ASCII").split("\n")
            if "CAVA" in line
        ]
        print(wids)
        Popen(["xdotool", "set_window", "--name", "CAVA1", wids[-1]])

    devilspie = Popen("devilspie2")
    sleep(0.4)

    # Send desktop notification
    if (
        (cava.poll() is None)
        and (monitors != 2 or cava2.poll() is None)
        and (devilspie.poll() is None)
    ):
        Popen(
            [
                "notify-send",
                "--app-name='CAVA visualizer'",
                "CAVA",
                "CAVA started",
                "--icon=/home/rharish/.local/share/icons/cava.png",
            ]
        )
    else:
        Popen(
            [
                "notify-send",
                "--app-name='CAVA visualizer'",
                "CAVA",
                "Error encountered",
                "--icon=/home/rharish/.local/share/icons/cava.png",
            ]
        )
        pgrep = Popen(["pgrep", "devilspie2"], stdout=PIPE)
        devilspie_list = list(map(int, pgrep.stdout.read().strip().split()))
        for pid in devilspie_list:
            os.kill(pid, 15)
