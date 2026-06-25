#!/usr/bin/env python3
"""
Turn a clean card scan into a synthetic "phone photo" view, and a mild anchor view.

Training pulls a photo view toward the anchor of the same card and away from other cards, so the
encoder learns to bridge the scan→photo domain gap that defeated the off-the-shelf model.
"""

import io
import random

import torch
from PIL import Image
from torchvision.transforms import v2

IMAGE_SIZE = 256


def _jpeg(image: Image.Image, quality: int) -> Image.Image:
    buffer = io.BytesIO()
    image.save(buffer, format="JPEG", quality=quality)
    buffer.seek(0)
    return Image.open(buffer).convert("RGB")


_photo = v2.Compose([
    v2.RandomPerspective(distortion_scale=0.35, p=0.85),
    v2.RandomRotation(degrees=8),
    v2.ColorJitter(brightness=0.45, contrast=0.45, saturation=0.4, hue=0.05),
    v2.RandomResizedCrop(IMAGE_SIZE, scale=(0.65, 1.0), ratio=(0.65, 0.8), antialias=True),
    v2.GaussianBlur(kernel_size=3, sigma=(0.1, 1.6)),
    v2.ToImage(),
    v2.ToDtype(torch.float32, scale=True),
])

_anchor = v2.Compose([
    v2.Resize((IMAGE_SIZE, IMAGE_SIZE), antialias=True),
    v2.ToImage(),
    v2.ToDtype(torch.float32, scale=True),
])


def photo_view(image: Image.Image) -> torch.Tensor:
    image = image.convert("RGB")
    if random.random() < 0.8:
        image = _jpeg(image, random.randint(35, 90))
    return _photo(image)


def anchor_view(image: Image.Image) -> torch.Tensor:
    return _anchor(image.convert("RGB"))
