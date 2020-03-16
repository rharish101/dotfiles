#!/usr/bin/python3
"""Script to do smooth wallpaper transitions in Xfce4."""
import os
import subprocess
from argparse import ArgumentDefaultsHelpFormatter, ArgumentParser
from atexit import register
from multiprocessing.dummy import Pool  # use threads instead of processes
from random import choice
from signal import SIGTERM, signal
from time import sleep

from PIL import Image
from Xlib.display import Display


class WallpaperTransition:
    """Class for performing wallpaper transition using Xfce."""

    TMP_FMT = "/tmp/{}_wall_{}.jpg"  # format for temp files for the transition
    THR_LIMIT = 8  # thread limit for per-monitor transitions

    def __init__(self, img_dir, timeout, duration, fps, backup_pic=None):
        """Initialize the instance.

        Args:
            img_dir (str): Path to the directory containing the wallpapers
            timeout (int): The wait between two transitions
            duration (int): The duration of a transition
            fps (int): The FPS for a transition
            backup_pic (str): Path to a picture that will be applied when this
                script crashes

        """
        self.img_dir = img_dir
        self.timeout = timeout
        self.duration = duration
        self.fps = fps

        if backup_pic is not None:
            self.backup_pic = backup_pic
            self.backup = register(self.backup)
            # `self.backup` will automatically be called when `exit` is called
            signal(SIGTERM, lambda s, f: exit())

    @staticmethod
    def get_monitors():
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
                monitors[info["name"]] = (monitor["width"], monitor["height"])

        return monitors

    @staticmethod
    def get_wallpaper(monitor_id):
        """Get the path to the current wallpaper of the given monitor."""
        cmd = [
            "xfconf-query",
            "--channel",
            "xfce4-desktop",
            "--property",
            f"/backdrop/screen0/monitor{monitor_id}/workspace0/last-image",
        ]
        return subprocess.check_output(cmd).decode("utf-8").strip()

    @staticmethod
    def set_wallpaper(monitor_id, img_path):
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

    @staticmethod
    def get_wall_style(monitor_id):
        """Get the style of the current wallpaper of the given monitor."""
        cmd = [
            "xfconf-query",
            "--channel",
            "xfce4-desktop",
            "--property",
            f"/backdrop/screen0/monitor{monitor_id}/workspace0/image-style",
        ]
        return int(subprocess.check_output(cmd).decode("utf-8").strip())

    @staticmethod
    def _zoom_img(img, target_size):
        """Zoom the image for the target size.

        Here, the image is resized (keeping aspect ratio constant) to fit over
        the screen, and the extra is cropped out.
        """
        # Preserve aspect ratio by resizing and then center-cropping
        if (img.size[0] / img.size[1]) > (target_size[0] / target_size[1]):
            upscale_ratio = target_size[1] / img.size[1]
        else:
            upscale_ratio = target_size[0] / img.size[0]

        img = img.resize(
            tuple(int(upscale_ratio * dim) for dim in img.size),
            Image.ANTIALIAS,
        )
        img = img.crop(
            (
                (img.size[0] - target_size[0]) // 2,
                (img.size[1] - target_size[1]) // 2,
                (img.size[0] + target_size[0]) // 2,
                (img.size[1] + target_size[1]) // 2,
            )
        )

        return img

    @staticmethod
    def _stretch_img(img, target_size):
        """Stretch the image for the target size.

        Here, the image is resized with change of aspect ratio to the screen
        """
        # Aspect ratio is not preserved
        return img.resize(target_size, Image.ANTIALIAS)

    @staticmethod
    def _tile_img(img, target_size):
        """Tile the image for the target size.

        Here, the image is not resized; it is tiled from the top-left to the
        bottom-right.
        """
        bg = Image.new(mode="RGBA", size=target_size, color=(0, 0, 0, 0))

        for offset_x in range(0, target_size[0], img.size[0]):
            for offset_y in range(0, target_size[1], img.size[1]):
                bg.paste(img, (offset_x, offset_y))

        return bg

    @staticmethod
    def _center_img(img, target_size):
        """Center the image for the target size.

        Here, the image isn't resized; it is placed at the center.
        """
        bg = Image.new(mode="RGBA", size=target_size, color=(0, 0, 0, 255))
        offset_x = int((target_size[0] - img.size[0]) / 2)
        offset_y = int((target_size[1] - img.size[1]) / 2)
        bg.paste(img, (offset_x, offset_y))
        return bg

    @staticmethod
    def _scale_img(img, target_size):
        """Scale the image for the target size.

        Here, the image is downsized (keeping aspect ratio constant) to fit
        within the screen, with a black background.
        """
        # `thumbnail` modifies the original image
        copy = img.copy()

        # `thumbnail` preserves the aspect ratio, by downsizing the
        # largest dimension to fit within the given size.
        copy.thumbnail(target_size, Image.ANTIALIAS)

        return copy

    @classmethod
    def process_image(cls, img, target_size, wall_style=None):
        """Modify the given image according to the wallpaper style.

        The style is one of:

        """
        if wall_style == 5:  # Zoomed
            img = cls._zoom_img(img, target_size)
        elif wall_style == 3:  # Stretched
            img = cls._stretch_img(img, target_size)
        elif wall_style == 2:  # Tiled
            img = cls._tile_img(img, target_size)
        elif wall_style == 4:  # Scaled
            img = cls._scale_img(img, target_size)
        else:  # Centered
            img = cls._center_img(img, target_size)

        # Remove alpha channel, as JPEG doesn't have it, and we don't need it
        img = img.convert("RGB")
        return img

    def _choose_transition(self, current_wallp, monitor_id):
        """Choose the wallpaper for a transition."""
        available = [
            item
            for item in os.listdir(self.img_dir)
            if os.path.isfile(os.path.join(self.img_dir, item))
        ]

        # Avoid changing into itself
        available.remove(os.path.basename(current_wallp))

        new_wallp = os.path.join(self.img_dir, choice(available))
        return new_wallp

    def bg_transition(self, monitor_id):
        """Perform a transition into a randomly chosen wallpaper."""
        current = self.get_wallpaper(monitor_id)
        new = self._choose_transition(current, monitor_id)

        wall_style = self.get_wall_style(monitor_id)
        bg = self.process_image(
            Image.open(current), self.monitors[monitor_id], wall_style
        )
        fg = self.process_image(
            Image.open(new), self.monitors[monitor_id], wall_style
        )

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

    def backup(self):
        """Set the backup image on all connected monitors."""
        # Connected monitors may have changed
        self.monitors = self.get_monitors()
        args = [(monitor_id, self.backup_pic) for monitor_id in self.monitors]
        with Pool(min(self.THR_LIMIT, len(self.monitors))) as pool:
            pool.starmap(self.set_wallpaper, args)

    def loop(self):
        """Loop and perform transitions."""
        while True:
            self.monitors = self.get_monitors()
            with Pool(min(self.THR_LIMIT, len(self.monitors))) as pool:
                pool.map(self.bg_transition, self.monitors)
            sleep(self.timeout)


def main(args):
    """Run the main program.

    Arguments:
        args (`argparse.Namespace`): The object containing the commandline
            arguments

    """
    wt = WallpaperTransition(
        args.img_dir,
        args.timeout,
        args.duration,
        args.fps,
        backup_pic=args.backup,
    )
    wt.loop()


if __name__ == "__main__":
    parser = ArgumentParser(
        description="XFCE Wallpaper Transition",
        formatter_class=ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument(
        "img_dir",
        metavar="ImgDir",
        type=str,
        help="the directory of the backgrounds you want to loop through",
    )
    parser.add_argument(
        "--timeout",
        type=int,
        default=600,
        help="idle period (in seconds) between transitions",
    )
    parser.add_argument(
        "--duration",
        type=float,
        default=1.0,
        help="duration of one transition (in seconds)",
    )
    parser.add_argument(
        "--fps", type=int, default=30, help="FPS for the transition"
    )
    parser.add_argument(
        "--backup",
        type=str,
        help="the backup picture to revert to, if the program crashes",
    )
    main(parser.parse_args())
