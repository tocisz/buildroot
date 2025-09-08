#!/usr/bin/env python3
import time

import iio
import numpy as np

WIDTH = 640
HEIGHT = 480

DEVICE_NAME = "mwipcore0:hdmi_sink"
CHANNEL_NAME = "data0"

# Create coordinate grids
y = np.arange(HEIGHT).reshape(-1, 1)
x = np.arange(WIDTH).reshape(1, -1)

# Generate vectorized plasma
v = np.sin(x / 32.0) + np.sin(y / 16.0) + np.sin(np.sqrt(x**2 + y**2) / 16.0)

# Normalize v to [0, 255]
v_norm = ((v - v.min()) / (v.max() - v.min()) * 255).astype(np.uint8)

# Create RGB channels with slightly different phases
r = np.sin(v_norm * 0.1) * 127 + 128
g = np.sin(v_norm * 0.13) * 127 + 128
b = np.sin(v_norm * 0.17) * 127 + 128

frame = np.stack([r, g, b], axis=2).astype(np.uint8)

# Flatten for IIO
frame_bytes = bytearray(frame.ravel().tobytes())

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
