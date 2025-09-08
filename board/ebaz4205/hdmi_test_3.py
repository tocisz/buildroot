#!/usr/bin/env python3
import time

import iio
import numpy as np
from PIL import Image, ImageOps

WIDTH = 640
HEIGHT = 480

DEVICE_NAME = "mwipcore0:hdmi_sink"
CHANNEL_NAME = "data0"


def image_to_rgb_bytes(path, target_size=(640, 480)):
    # 1. Open image
    img = Image.open(path).convert("RGB")

    # 2. Scale & pad to target size while keeping aspect ratio
    img = ImageOps.pad(img, target_size, color=(0, 0, 0))  # black padding

    # 3. Convert to numpy array (H, W, 3)
    arr = np.asarray(img, dtype=np.uint8)

    # 4. Swap channels from RGB -> BGR
    arr_bgr = arr[..., ::-1]

    # 5. Flatten into byte array in BGRBGR... order
    byte_array = bytearray(arr_bgr.tobytes())

    return byte_array


# Example usage
frame_bytes = image_to_rgb_bytes("cute-cat-spending-time-indoors.jpg")

# Open IIO device
ctx = iio.Context()
dev = ctx.find_device(DEVICE_NAME)
chan = dev.find_channel(CHANNEL_NAME, True)
chan.enabled = True

# Create cyclic buffer
buf = iio.Buffer(dev, len(frame_bytes), cyclic=True)
buf.write(frame_bytes)
buf.push()

try:
    time.sleep(10)
except:
    buf.cancel()
    del buf
