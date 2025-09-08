#!/usr/bin/env python3
import os
import time

import iio
import numpy as np

WIDTH = 640
HEIGHT = 480

DEVICE_NAME = "mwipcore0:hdmi_sink"
CHANNEL_NAME = "data0"

BUFFER_SIZE = WIDTH * HEIGHT * 3

# Open IIO device
ctx = iio.Context()
dev = ctx.find_device(DEVICE_NAME)
chan = dev.find_channel(CHANNEL_NAME, True)
chan.enabled = True

# Create buffer
buf = iio.Buffer(dev, BUFFER_SIZE, cyclic=False)
num = 0

try:
    while True:
        frame_bytes = bytearray(num.to_bytes(1, byteorder="big") * BUFFER_SIZE)
        buf.write(frame_bytes)
        buf.push()

        num = (num + 1) % 256
finally:
    buf.cancel()
    del buf
