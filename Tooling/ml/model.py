#!/usr/bin/env python3
"""Shared image encoder: CLIP normalization baked in, raw features out (cosine normalizes later)."""

import open_clip
import torch
import torch.nn as nn

CLIP_MEAN = (0.48145466, 0.4578275, 0.40821073)
CLIP_STD = (0.26862954, 0.26130258, 0.27577711)


class ImageEncoder(nn.Module):
    def __init__(self, visual, mean=CLIP_MEAN, std=CLIP_STD):
        super().__init__()
        self.visual = visual
        self.register_buffer("mean", torch.tensor(mean).view(1, 3, 1, 1))
        self.register_buffer("std", torch.tensor(std).view(1, 3, 1, 1))

    def forward(self, image):  # image in [0, 1], shape (B, 3, H, W)
        return self.visual((image - self.mean) / self.std)


def build_encoder(model_name="MobileCLIP-S2", pretrained="datacompdr"):
    model, _, _ = open_clip.create_model_and_transforms(model_name, pretrained=pretrained)
    return ImageEncoder(model.visual)
