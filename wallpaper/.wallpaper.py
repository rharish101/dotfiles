#!/usr/bin/python3
import argparse
import atexit
import os
import random
import signal
import subprocess
import time
from multiprocessing.dummy import Pool as ThreadPool
import PIL
from PIL import Image
from Xlib.display import Display


class WallpaperTransition:
    def __init__(
        self,
        imageFolder,
        blurFolder,
        timeout,
        duration,
        fps,
        backupPic,
        statusFile,
    ):
        self.monitors = self.getMonitorList()
        self.imageFolder = imageFolder
        self.blurFolder = blurFolder
        self.timeout = timeout
        self.duration = duration
        self.fps = fps
        self.statusFile = statusFile

        if backupPic:
            self.backupPic = backupPic
            atexit.register(self.backup)
            signal.signal(signal.SIGTERM, self.signal_handler)

    def getMonitorList(self):
        display = Display()
        root = display.screen().root
        root.create_gc()
        resources = root.xrandr_get_screen_resources()._data

        monitors = {}
        count = 0

        for crtc in resources["crtcs"]:
            monitor = display.xrandr_get_crtc_info(
                crtc, resources["config_timestamp"]
            )._data
            if len(monitor["outputs"]) > 0:  # is connected
                monitors[count] = (monitor["width"], monitor["height"])
                count += 1

        return monitors

    def getWallpaper(self, monitorNumber):
        return (
            subprocess.check_output(
                "xfconf-query --channel xfce4-desktop "
                "--property /backdrop/screen0/monitor"
                + str(monitorNumber)
                + "/workspace0/last-image",
                shell=True,
            )
            .decode("utf-8")
            .replace("\n", "")
        )

    def setWallpaper(self, monitorNumber, imagePath):
        subprocess.call(
            "xfconf-query --channel xfce4-desktop --property "
            "/backdrop/screen0/monitor"
            + str(monitorNumber)
            + "/workspace0/last-image --set "
            + imagePath,
            shell=True,
        )

    def getWallStyle(self, monitorNumber):
        return int(
            subprocess.check_output(
                "xfconf-query --channel xfce4-desktop "
                "--property /backdrop/screen0/monitor"
                + str(monitorNumber)
                + "/workspace0/image"
                "-style",
                shell=True,
            )
            .decode("utf-8")
            .replace("\n", "")
        )

    def processImage(self, img, size, wall_style=None):
        if wall_style == 5:
            img_size = img.size
            if (float(img_size[0]) / img_size[1]) > (float(size[0]) / size[1]):
                img = img.resize(
                    tuple(
                        int((float(size[1]) / img_size[1]) * i)
                        for i in img.size
                    ),
                    PIL.Image.ANTIALIAS,
                )
                img = img.crop(
                    (
                        (img.size[0] - size[0]) / 2,
                        0,
                        (img.size[0] + size[0]) / 2,
                        img.size[1],
                    )
                )
            elif (float(img_size[0]) / img_size[1]) < (
                float(size[0]) / size[1]
            ):
                img = img.resize(
                    tuple(
                        int((float(size[0]) / img_size[0]) * i)
                        for i in img.size
                    ),
                    PIL.Image.ANTIALIAS,
                )
                img = img.crop(
                    (
                        0,
                        (img.size[1] - size[1]) / 2,
                        img.size[0],
                        (img.size[1] + size[1]) / 2,
                    )
                )
            else:
                img = img.resize(size, PIL.Image.ANTIALIAS)
        else:
            img.thumbnail(size, PIL.Image.ANTIALIAS)
        img.convert("RGBA")

        offset_x = int(max((size[0] - img.size[0]) / 2, 0))
        offset_y = int(max((size[1] - img.size[1]) / 2, 0))
        offset_tuple = (offset_x, offset_y)

        result = Image.new(mode="RGB", size=size, color=(0, 0, 0, 0))
        result.paste(img, offset_tuple)
        return result

    def bgTransition(self, monitorID, imageFolder):
        current = self.getWallpaper(monitorID)
        new = imageFolder + "/" + random.choice(os.listdir(imageFolder))

        bg = self.processImage(
            Image.open(current),
            self.monitors[monitorID],
            self.getWallStyle(monitorID),
        )
        fg = self.processImage(
            Image.open(new),
            self.monitors[monitorID],
            self.getWallStyle(monitorID),
        )

        count = (self.duration * self.fps) + 1
        sleep = self.duration / self.fps

        for i in range(1, count):
            Image.blend(bg, fg, i / count).save(
                "/tmp/" + str(monitorID) + "_" + str(i) + ".jpg"
            )
        for i in range(1, count):
            time.sleep(sleep)
            self.setWallpaper(
                monitorID, "/tmp/" + str(monitorID) + "_" + str(i) + ".jpg"
            )
        self.setWallpaper(monitorID, new)
        subprocess.call(
            "rm /tmp/" + str(monitorID) + "_*.jpg", shell=True
        )  # can't use wildcards in pythons os.remove()

    def signal_handler(self, signal, frame):
        self.backup()

    def backup(self):
        for id in self.monitors:
            self.setWallpaper(id, self.backupPic)

    def loop(self):
        while 1:
            status_file = open(self.statusFile, "r+")
            status = status_file.read().split("\n")[1:-1]
            status_file.seek(0)
            status_file.write("transition\n" + "\n".join(status) + "\n")
            status_file.truncate()
            status_file.close()

            if len(status) < 2:
                status.append("clear")

            array = []
            self.monitors = self.getMonitorList()
            for id in self.monitors:
                if status[id] == "blur":
                    array.append((id, self.blurFolder))
                else:
                    array.append((id, self.imageFolder))

            pool = ThreadPool(len(self.monitors))
            pool.starmap(self.bgTransition, array)

            status_file = open(self.statusFile, "r+")
            status_file.seek(0)
            status_file.write("static\n" + "\n".join(status) + "\n")
            status_file.truncate()
            status_file.close()

            time.sleep(self.timeout)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="XFCE Wallpaper Transition")
    parser.add_argument(
        "-d",
        "--dir",
        # default=os.getcwd(),
        default="/home/rharish/Pictures/Wallpapers/Normal",
        metavar=("ImageDir"),
        help="The directory of the backgrounds you want to loop through",
        type=str,
    )
    parser.add_argument(
        "-D",
        "--blur-dir",
        # default=os.getcwd(),
        default="/home/rharish/Pictures/Wallpapers/Blurred/Level_3",
        metavar=("BlurDir"),
        help="The directory of the blurred backgrounds you want to loop through",
        type=str,
    )
    parser.add_argument(
        "-t",
        "--timeout",
        default=600,
        metavar=("SECONDS"),
        help="How many seconds to wait before the next transition",
        type=int,
    )
    parser.add_argument(
        "-s",
        "--transition",
        nargs=2,
        default=[1, 60],
        metavar=("DURATION FPS"),
        help="Defines how long a transition is and with how much FPS it shall be done",
        type=int,
    )
    parser.add_argument(
        "-b",
        "--backup",
        default="/home/rharish/Pictures/Wallpapers/Normal/photo-1433785124354.jpg",
        metavar=("BackupPicture"),
        help="The backup picture to revert to, if the program crashes",
        type=str,
    )
    parser.add_argument(
        "-S",
        "--status-file",
        default="/home/rharish/.wall_blur",
        metavar=("StatusFile"),
        help="Path to the status file for wallpaper blurring",
        type=str,
    )

    args = vars(parser.parse_args())

    if "dir" in args:
        dir = args["dir"]
    if "blur_dir" in args:
        blur_dir = args["blur_dir"]
    if "timeout" in args:
        timeout = args["timeout"]
    if "transition" in args:
        duration = args["transition"][0]
        fps = args["transition"][1]
    if "backup" in args:
        backupPic = args["backup"]
    if "status_file" in args:
        status_file = args["status_file"]

    if dir and blur_dir and timeout and duration and fps and status_file:
        wt = WallpaperTransition(
            dir, blur_dir, timeout, duration, fps, backupPic, status_file
        )
        wt.loop()
    else:
        parser.print_help()
