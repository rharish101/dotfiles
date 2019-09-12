#!/usr/bin/python3
"""Script to do smooth wallpaper transitions in Xfce4."""
from PIL import Image
from Xlib.display import Display
from Xlib.ext import randr
from random import choice
import os
import subprocess
from time import sleep
from atexit import register
from signal import signal, SIGTERM, SIGCONT, SIGSTOP
from multiprocessing.dummy import Pool  # use threads instead of processes
from argparse import ArgumentParser, ArgumentDefaultsHelpFormatter


class WallpaperTransition:
    """Class for performing wallpaper transition using Xfce."""

    def __init__(
        self,
        image_folder,
        blur_folder,
        timeout,
        duration,
        fps,
        backup_pic=None,
    ):
        """Initialize the instance.

        Args:
            image_folder (str): Path to the folder containing the wallpapers
            blur_folder (str): Path to the folder containing the blurred
                wallpapers
            timeout (int): The wait between two transitions
            duration (int): The duration of a transition
            fps (int): The FPS for a transition
            backup_pic (str): Path to a picture that will be applied when this
                script crashes

        """
        self.image_folder = image_folder
        self.blur_folder = blur_folder
        self.timeout = timeout
        self.duration = duration
        self.fps = fps

        if backup_pic is not None:
            self.backup_pic = backup_pic
            self.backup = register(self.backup)
            # `self.backup` will automatically be called when `exit` is called
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
                info = randr.get_output_info(
                    root, output, resources["config_timestamp"]
                )._data
                monitors[info["name"]] = (monitor["width"], monitor["height"])

        return monitors

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

    def set_wallpaper(self, monitor_id, image_path):
        """Set the current wallpaper for the given monitor."""
        subprocess.call(
            [
                "xfconf-query",
                "--channel",
                "xfce4-desktop",
                "--property",
                f"/backdrop/screen0/monitor{monitor_id}/workspace0/last-image",
                "--set",
                image_path,
            ]
        )

    def get_wall_style(self, monitor_id):
        """Get the style of the current wallpaper of the given monitor.

        The style is one of:
            Centered: Image un-resized, placed at the center
            Tiled: Image un-resized, tiled from top-left to bottom-right
            Stretched: Image resized with change of aspect ratio to the screen
            Scaled: Image downsized (keeping aspect ratio constant) to fit
                within the screen, with a black background
            Zoomed: Image resized (keeping aspect ratio constant) to fit over
                the screen, and the extra cropped out

        """
        cmd = [
            "xfconf-query",
            "--channel",
            "xfce4-desktop",
            "--property",
            f"/backdrop/screen0/monitor{monitor_id}/workspace0/image-style",
        ]
        return int(subprocess.check_output(cmd).decode("utf-8").strip())

    def process_image(self, img, target_size, wall_style=None):
        """Modify the given image to the given size according to the wallpaper style.

        The style is one of:
            Centered: Image un-resized, placed at the center
            Tiled: Image un-resized, tiled from top-left to bottom-right
            Stretched: Image resized with change of aspect ratio to the screen
            Scaled: Image downsized (keeping aspect ratio constant) to fit
                within the screen, with a black background
            Zoomed: Image resized (keeping aspect ratio constant) to fit over
                the screen, and the extra cropped out

        """
        if wall_style == 5:  # Zoomed
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

        elif wall_style == 3:  # Stretched
            # Aspect ratio is not preserved
            img = img.resize(target_size, Image.ANTIALIAS)

        elif wall_style == 2:  # Tiled
            bg = Image.new(mode="RGBA", size=target_size, color=(0, 0, 0, 0))
            for offset_x in range(0, target_size[0], img.size[0]):
                for offset_y in range(0, target_size[1], img.size[1]):
                    bg.paste(img, (offset_x, offset_y))
            img = bg

        else:  # Centered or Scaled
            if wall_style == 4:  # Scaled
                # `thumbnail` preserves the aspect ratio, by downsizing the
                # largest dimension to fit within the given size
                img.thumbnail(target_size, Image.ANTIALIAS)

            bg = Image.new(mode="RGBA", size=target_size, color=(0, 0, 0, 255))
            offset_x = int((target_size[0] - img.size[0]) / 2)
            offset_y = int((target_size[1] - img.size[1]) / 2)
            bg.paste(img, (offset_x, offset_y))
            img = bg

        # Alpha channel is required as this image might be merged with another
        # RGBA image
        img.convert("RGB")
        return img

    def bg_transition(self, monitor_id, image_folder):
        """Perform a transition into a randomly chosen wallpaper."""
        current = self.get_wallpaper(monitor_id)
        available = os.listdir(image_folder)
        # Avoid changing into itself
        available.remove(os.path.basename(current))
        new = os.path.join(image_folder, choice(available))

        wall_style = self.get_wall_style(monitor_id)
        bg = self.process_image(
            Image.open(current), self.monitors[monitor_id], wall_style
        )
        fg = self.process_image(
            Image.open(new), self.monitors[monitor_id], wall_style
        )

        total_imgs = int(self.duration * self.fps)
        wait = self.duration / self.fps
        TMP_FMT = "/tmp/{}_{}.jpg"

        for i in range(1, total_imgs + 1):
            Image.blend(bg, fg, i / total_imgs).save(
                TMP_FMT.format(monitor_id, i)
            )

        # FPS and duration is used for this
        for i in range(1, total_imgs + 1):
            sleep(wait)
            self.set_wallpaper(monitor_id, TMP_FMT.format(monitor_id, i))
        self.set_wallpaper(monitor_id, new)

        for i in range(1, total_imgs + 1):
            os.remove(TMP_FMT.format(monitor_id, i))

    def backup(self):
        """Set the backup image on all connected monitors."""
        # Connected monitors may have changed
        for monitor_id in self.get_monitors():
            self.set_wallpaper(monitor_id, self.backup_pic)

    def loop(self):
        """Loop and perform transitions."""
        while True:
            pgrep = subprocess.check_output(["pgrep", "blur-desktop"])
            pid_list = map(int, pgrep.strip().split())

            for pid in pid_list:
                os.kill(pid, SIGSTOP.value)

            array = []
            self.monitors = self.get_monitors()
            for monitor_id in self.monitors:
                curr = self.get_wallpaper(monitor_id)
                if self.blur_folder is not None and curr in os.listdir(
                    self.blur_folder
                ):
                    array.append((monitor_id, self.blur_folder))
                else:
                    array.append((monitor_id, self.image_folder))

            with Pool(len(self.monitors)) as pool:
                pool.starmap(self.bg_transition, array)

            for pid in pid_list:
                os.kill(pid, SIGCONT.value)  # send SIGCONT

            sleep(self.timeout)


def main(args):
    """Run the main program.

    Arguments:
        args (`argparse.Namespace`): The object containing the commandline
            arguments

    """
    wt = WallpaperTransition(
        args.img_dir,
        args.blur_dir,
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
        "--blur-dir", type=str, help="the directory of the blurred backgrounds"
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
        "--fps", type=int, default=60, help="FPS for the transition"
    )
    parser.add_argument(
        "--backup",
        type=str,
        help="the backup picture to revert to, if the program crashes",
    )
    main(parser.parse_args())
