#!/usr/bin/env python3
import struct

import numpy as np

WIDTH = 240
HEIGHT = 240


def rgb565_numpy(r, g, b):
    """Convert 8-bit RGB arrays to 16-bit RGB565."""
    return ((r & 0xF8) << 8) | ((g & 0xFC) << 3) | (b >> 3)


# Create coordinate grids
y = np.arange(HEIGHT).reshape(-1, 1)
x = np.arange(WIDTH).reshape(1, -1)

# Plasma effect
v = (
    (128 + 128 * np.sin(x / 16.0)) + (128 + 128 * np.sin(y / 8.0)) + (128 + 128 * np.sin(np.sqrt(x**2 + y**2) / 8.0))
) / 3.0

# RGB channels
r = ((np.sin(v * 0.1) + 1) * 127).astype(np.uint16)
g = ((np.sin(v * 0.13) + 1) * 127).astype(np.uint16)
b = ((np.sin(v * 0.17) + 1) * 127).astype(np.uint16)

# Convert to RGB565
frame565 = rgb565_numpy(r, g, b).astype(np.uint16)

# Flatten to bytes for writing
frame_bytes = frame565.tobytes()

# Write to framebuffer
with open("/dev/fb0", "wb") as fb:
    fb.write(frame_bytes)
