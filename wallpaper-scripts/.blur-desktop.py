#!/usr/bin/python3
"""Script to blur wallpaper on focus loss in Xfce4."""
import os
import subprocess
from argparse import ArgumentDefaultsHelpFormatter, ArgumentParser
from atexit import register
from multiprocessing.dummy import Pool  # use threads instead of processes
from signal import SIGTERM, signal
from time import sleep

from PIL import Image, ImageFilter
from Xlib.display import Display


class WallpaperBlur:
    """Class for performing wallpaper blur using Xfce."""

    TMP_FMT = "/tmp/{}_blur_{}.jpg"  # format for temp files for the blur
    TIMEOUT = 0.5  # waiting period b/w checking whether to blur
    MAX_BLUR = 5  # radius for max gaussian blur

    def __init__(self, img_dir, blur_dir, duration, fps):
        """Initialize the instance.

        Args:
            img_dir (str): Path to the folder containing the wallpapers
            blur_dir (str): Path to the folder containing the blurred
                wallpapers
            duration (int): The duration of a transition
            fps (int): The FPS for a transition

        """
        self.img_dir = img_dir
        self.blur_dir = blur_dir
        self.duration = duration
        self.fps = fps

        if not os.path.exists(self.blur_dir):
            os.makedirs(self.blur_dir)

        self.unblur_all = register(self.unblur_all)
        # `self.unblur_all` will automatically be called when `exit` is called
        signal(SIGTERM, lambda s, f: exit())

    def get_monitors(self):
        """Get information on the connected monitors.

        Returns:
            dict: The keys are the monitor names (eg. "eDP1") and the values
                are tuples of the monitor's resolution

        """
        display = Display()
        root = display.screen().root
        root.create_gc()
        resources = root.xrandr_get_screen_resources()._data

        monitors = {}

        for crtc in resources["crtcs"]:
            monitor = display.xrandr_get_crtc_info(
                crtc, resources["config_timestamp"]
            )._data
            for output in monitor["outputs"]:  # is connected
                info = display.xrandr_get_output_info(
                    output, resources["config_timestamp"]
                )._data
                # Storing coordinates of limits of monitor
                monitors[info["name"]] = (
                    monitor["x"],
                    monitor["x"] + monitor["width"],
                    monitor["y"],
                    monitor["y"] + monitor["height"],
                )

        return monitors

    def get_active_monitor(self):
        """Get the ID of the monitor where the active window is.

        If the focus is on the desktop, then None is returned.
        """
        win_id = (
            subprocess.check_output(["xdotool", "getactivewindow"])
            .decode("utf-8")
            .strip()
        )
        win_info = (
            subprocess.check_output(["xwininfo", "-id", win_id])
            .decode("utf-8")
            .strip()
        )

        lines = win_info.split("\n")
        # Splitting and joining is done as the window name may contain
        # spaces. Also, double quotes around the name need to be remove
        win_name = " ".join(lines[0].split()[4:])[1:-1]
        x_offset = int(lines[2].split()[-1])
        y_offset = int(lines[3].split()[-1])

        if win_name == "Desktop":
            return None

        for monitor_id in self.monitors:
            if (
                x_offset >= self.monitors[monitor_id][0]
                and x_offset < self.monitors[monitor_id][1]
                and y_offset >= self.monitors[monitor_id][2]
                and y_offset < self.monitors[monitor_id][3]
            ):
                # Window's top-left corner lies inside this monitor
                return monitor_id

    def get_wallpaper(self, monitor_id):
        """Get the path to the current wallpaper of the given monitor."""
        cmd = [
            "xfconf-query",
            "--channel",
            "xfce4-desktop",
            "--property",
            f"/backdrop/screen0/monitor{monitor_id}/workspace0/last-image",
        ]
        return subprocess.check_output(cmd).decode("utf-8").strip()

    def set_wallpaper(self, monitor_id, img_path):
        """Set the current wallpaper for the given monitor."""
        subprocess.call(
            [
                "xfconf-query",
                "--channel",
                "xfce4-desktop",
                "--property",
                f"/backdrop/screen0/monitor{monitor_id}/workspace0/last-image",
                "--set",
                img_path,
            ]
        )

    def bg_blur(self, monitor_id, blur):
        """Blur the wallpaper for the given monitor only and unblur the rest.

        Args:
            monitor_id (str): The ID of the monitor. If the monitor ID is None,
                then it unblurs all monitors.
            blur (bool): Whether to blur or unblur the monitor

        """
        current = self.get_wallpaper(monitor_id)
        bg = Image.open(current)

        if blur:
            new = os.path.join(self.blur_dir, os.path.basename(current))
        else:
            new = os.path.join(self.img_dir, os.path.basename(current))
        if os.path.exists(new):
            fg = Image.open(new)
        elif blur:
            fg = bg.filter(ImageFilter.GaussianBlur(radius=self.MAX_BLUR))
            fg.save(os.path.join(self.blur_dir, os.path.basename(current)))
        else:
            # Can't unblur an image, so exit
            return

        total_imgs = int(self.duration * self.fps)
        wait = self.duration / self.fps

        for i in range(1, total_imgs + 1):
            Image.blend(bg, fg, i / total_imgs).save(
                self.TMP_FMT.format(monitor_id, i)
            )

        # FPS and duration is used for this
        for i in range(1, total_imgs + 1):
            sleep(wait)
            self.set_wallpaper(monitor_id, self.TMP_FMT.format(monitor_id, i))
        self.set_wallpaper(monitor_id, new)

        for i in range(1, total_imgs + 1):
            os.remove(self.TMP_FMT.format(monitor_id, i))

    def unblur_all(self):
        """Unblur all connected monitors."""
        # Connected monitors may have changed
        self.monitors = self.get_monitors()
        with Pool(len(self.monitors)) as pool:
            pool.starmap(
                self.bg_blur,
                [(monitor_id, False) for monitor_id in self.monitors],
            )

    def loop(self):
        """Loop and perform blurs when required."""
        blurred_monitor = None
        while True:
            self.monitors = self.get_monitors()
            active_monitor = self.get_active_monitor()

            if active_monitor != blurred_monitor:
                args = []
                for monitor_id in self.monitors:
                    args.append((monitor_id, monitor_id == active_monitor))

                with Pool(len(self.monitors)) as pool:
                    pool.starmap(self.bg_blur, args)

                blurred_monitor = active_monitor

            sleep(self.TIMEOUT)


def main(args):
    """Run the main program.

    Arguments:
        args (`argparse.Namespace`): The object containing the commandline
            arguments

    """
    wt = WallpaperBlur(args.img_dir, args.blur_dir, args.duration, args.fps)
    wt.loop()


if __name__ == "__main__":
    parser = ArgumentParser(
        description="XFCE Wallpaper Blur",
        formatter_class=ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument(
        "img_dir",
        metavar="ImgDir",
        type=str,
        help="the directory of the backgrounds you want to loop through",
    )
    parser.add_argument(
        "--blur-dir",
        type=str,
        default=os.path.expanduser("~/.blurred_wallpapers"),
        help="the directory of the blurred backgrounds",
    )
    parser.add_argument(
        "--duration",
        type=float,
        default=0.5,
        help="duration of one blur transition (in seconds)",
    )
    parser.add_argument(
        "--fps", type=int, default=10, help="FPS for the blur transition"
    )
    main(parser.parse_args())
