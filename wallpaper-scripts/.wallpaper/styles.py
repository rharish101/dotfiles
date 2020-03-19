"""Helper functions to apply Xfce4 wallpaper styles."""
from PIL import Image


def center_img(img, target_size):
    """Center the image for the target size.

    Here, the image isn't resized; it is placed at the center.
    """
    bg = Image.new(mode="RGB", size=target_size)
    offset_x = int((target_size[0] - img.size[0]) / 2)
    offset_y = int((target_size[1] - img.size[1]) / 2)
    bg.paste(img, box=(offset_x, offset_y))
    return bg


def tile_img(img, target_size):
    """Tile the image for the target size.

    Here, the image is not resized; it is tiled from the top-left to the
    bottom-right.
    """
    bg = Image.new(mode="RGB", size=target_size)
    for offset_x in range(0, target_size[0], img.size[0]):
        for offset_y in range(0, target_size[1], img.size[1]):
            bg.paste(img, (offset_x, offset_y))
    return bg


def stretch_img(img, target_size):
    """Stretch the image for the target size.

    Here, the image is resized with change of aspect ratio to the screen
    """
    # Aspect ratio is not preserved
    return img.resize(target_size, resample=Image.BICUBIC)


def scale_img(img, target_size):
    """Scale the image for the target size.

    Here, the image is downsized (keeping aspect ratio constant) to fit
    within the screen, with a black background.
    """
    # `thumbnail` modifies the original image
    copy = img.copy()

    # `thumbnail` preserves the aspect ratio, by downsizing the largest
    # dimension to fit within the given size.
    copy.thumbnail(target_size, resample=Image.BICUBIC)

    return copy


def zoom_img(img, target_size):
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
        tuple(int(upscale_ratio * dim) for dim in img.size), Image.ANTIALIAS,
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


def apply_style(img, target_size, style=1):
    """Modify the given image according to the wallpaper style.

    The style is one of:
        1: Centered
        2: Tiled
        3: Stretched
        4: Scaled
        5: Zoomed

    """
    img = STYLE_FUNC_MAP[style](img, target_size)
    # Remove alpha channel, as JPEG doesn't have it, and we don't need it
    img = img.convert("RGB")
    return img


# Mapping wallpaper style as represented by integers to appropriate functions
STYLE_FUNC_MAP = {
    1: center_img,  # Centered
    2: tile_img,  # Tiled
    3: stretch_img,  # Stretched
    4: scale_img,  # Scaled
    5: zoom_img,  # Zoomed
}
