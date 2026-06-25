#!/usr/bin/env python3
"""
Convert a fine-tuned encoder checkpoint to Core ML (FP32) for the app.

    ../coreml/.venv/bin/python convert_trained.py --ckpt runs/s2.pt \
        --out ../../SWDestinyTrades/Resources/MobileCLIPImage.mlpackage

FP32 because the raw features overflow FP16 to NaN. Normalization is baked in; L2 is left to the
Swift cosine step.
"""

import argparse

import coremltools as ct
import torch

from model import build_encoder

IMAGE_SIZE = 256


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--ckpt", required=True)
    parser.add_argument("--out", default="MobileCLIPImage.mlpackage")
    args = parser.parse_args()

    checkpoint = torch.load(args.ckpt, map_location="cpu")
    encoder = build_encoder(checkpoint["model"], checkpoint["pretrained"])
    encoder.load_state_dict(checkpoint["state_dict"])
    encoder.eval()

    example = torch.rand(1, 3, IMAGE_SIZE, IMAGE_SIZE)
    exported = torch.export.export(encoder, (example,)).run_decompositions({})

    mlmodel = ct.convert(
        exported,
        inputs=[ct.ImageType(name="image", shape=example.shape,
                             scale=1.0 / 255.0, bias=[0.0, 0.0, 0.0],
                             color_layout=ct.colorlayout.RGB)],
        outputs=[ct.TensorType(name="embedding")],
        compute_precision=ct.precision.FLOAT32,
        minimum_deployment_target=ct.target.iOS17,
    )
    mlmodel.short_description = f"Fine-tuned {checkpoint['model']} image encoder"
    mlmodel.save(args.out)
    print(f"Saved {args.out}")


if __name__ == "__main__":
    main()
