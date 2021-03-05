#!/usr/bin/python3
"""Script for smooth wallpaper transitions for a single monitor with Feh."""
import atexit
import random
import re
import subprocess
from argparse import ArgumentDefaultsHelpFormatter, ArgumentParser, Namespace
from pathlib import Path
from signal import SIGTERM, signal
from tempfile import TemporaryDirectory
from time import sleep
from typing import NoReturn, Optional, Tuple

from PIL import Image
from typing_extensions import Final
from Xlib.display import Display


class WallpaperTransition:
    """Class for performing wallpaper transition using Feh."""

    TMP_FMT: Final = "wall_{}.jpg"  # format for temp transition files
    THR_LIMIT: Final = 8  # thread limit for per-monitor transitions
    FEH_LOC: Final = Path("~/.fehbg").expanduser()  # location of feh info
    DELETE_DELAY: Final = 0.5  # delay before deleting temp files

    def __init__(self, img_dir: Path, timeout: int, duration: float, fps: int):
        """Initialize the instance.

        Args:
            img_dir: Path to the directory containing the wallpapers
            timeout: The wait between two transitions
            duration: The duration of a transition
            fps: The FPS for a transition
        """
        self.img_dir = img_dir
        self.timeout = timeout
        self.duration = duration
        self.fps = fps

        # Restore the previous wallpaper on exit
        atexit.register(self.restore_wallpaper)
        # Gracefully exit after restoring the previous wallpaper on SIGTERM
        signal(SIGTERM, lambda s, f: exit())

    @staticmethod
    def get_resolution() -> Tuple[int, int]:
        """Get the primary monitor's resolution.

        Returns:
            The resolution width
            The resolution height
        """
        display = Display()
        root = display.screen().root
        root.create_gc()
        resources = root.xrandr_get_screen_resources()._data
        crtc = resources["crtcs"][0]
        monitor = display.xrandr_get_crtc_info(
            crtc, resources["config_timestamp"]
        )._data
        return monitor["width"], monitor["height"]

    @classmethod
    def get_wallpaper(cls) -> Optional[Path]:
        """Get the paths to the current wallpaper."""
        try:
            with open(cls.FEH_LOC, "r") as feh_file:
                contents = feh_file.read()
        except FileNotFoundError:
            return None  # no feh background is set

        feh_line = contents.strip().split("\n")[-1]
        match = re.search(r"'([^']+)'", feh_line)
        if match is None:
            return None
        wallpaper = match.groups()[0]
        return Path(wallpaper)

    @staticmethod
    def set_wallpaper(img_path: Path, no_fehbg: bool = False) -> None:
        """Set the current wallpaper."""
        cmd = ["feh"]
        if no_fehbg:
            cmd.append("--no-fehbg")
        cmd += ["--bg-fill", str(img_path)]
        subprocess.Popen(cmd)

    @staticmethod
    def adjust_img(
        img: Image.Image, target_size: Tuple[int, int]
    ) -> Image.Image:
        """Adjust the image for the target size.

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

        # Remove alpha channel, as JPEG doesn't have it, and we don't need it
        img = img.convert("RGB")

        return img

    def _choose_transition(
        self, exclude: Optional[Path] = None
    ) -> Optional[Path]:
        """Choose the wallpaper for a transition."""
        available = [
            item
            for item in self.img_dir.glob("*")
            if item.is_file() and item != exclude
        ]
        if not available:
            return None
        return random.choice(available)

    def bg_transition(self):
        """Perform a transition into a randomly chosen wallpaper."""
        current = self.get_wallpaper()

        # Avoid transitioning into the same wallpaper
        new = self._choose_transition(exclude=current)
        if new is None:  # failed to get a new wallpaper
            new = current

        if current is None:
            # Failed to get current wallpaper. So directly set a random
            # wallpaper and skip transition for now.
            if new is not None:
                self.set_wallpaper(new)
            return

        resolution = self.get_resolution()
        bg = self.adjust_img(Image.open(current), resolution)
        fg = self.adjust_img(Image.open(new), resolution)

        total_imgs = int(self.duration * self.fps)
        wait = self.duration / self.fps

        with TemporaryDirectory() as tmp_dir:
            for i in range(1, total_imgs):
                tmp_file = Path(tmp_dir) / self.TMP_FMT.format(i)
                Image.blend(bg, fg, i / total_imgs).save(tmp_file)

            # FPS and duration is used for this
            for i in range(1, total_imgs):
                tmp_file = Path(tmp_dir) / self.TMP_FMT.format(i)
                sleep(wait)
                # Creating the fehbg file would slow down the transition
                self.set_wallpaper(tmp_file, no_fehbg=True)

            self.set_wallpaper(new)

            sleep(self.DELETE_DELAY)
            for i in range(1, total_imgs):
                tmp_file = Path(tmp_dir) / self.TMP_FMT.format(i)
                tmp_file.unlink()

    @classmethod
    def restore_wallpaper(cls) -> None:
        """Restore the previous wallpaper through ~/.fehbg."""
        subprocess.run([cls.FEH_LOC])

    def loop(self) -> NoReturn:
        """Loop and perform transitions."""
        while True:
            self.bg_transition()
            sleep(self.timeout)


def main(args: Namespace) -> None:
    """Run the main program.

    Arguments:
        args: The object containing the commandline arguments
    """
    wt = WallpaperTransition(
        args.img_dir,
        args.timeout,
        args.duration,
        args.fps,
    )
    wt.loop()


if __name__ == "__main__":
    parser = ArgumentParser(
        description="Wallpaper Transition using Feh",
        formatter_class=ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument(
        "img_dir",
        metavar="DIR",
        type=Path,
        help="the directory of wallpapers you want to loop through",
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
        "--fps", type=int, default=15, help="FPS for the transition"
    )
    main(parser.parse_args())
