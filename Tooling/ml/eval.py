#!/usr/bin/env python3
"""
Go/no-go evaluation: does a fine-tuned encoder match REAL photos to the right card scan?

Put real photos in data/real/<code>/*.jpg (one folder per card code), then:

    ../coreml/.venv/bin/python eval.py --ckpt runs/s2.pt

Reports top-1 / top-5 retrieval accuracy against the scan index, and prints each photo's top-5.
Pass --ckpt "" to evaluate the off-the-shelf model (baseline).
"""

import argparse
import glob
import json
import os
import urllib.request

import torch
import torch.nn.functional as F
from PIL import Image

from augment import anchor_view
from model import build_encoder

CARDS_DIR = os.path.join(os.path.dirname(__file__), "data", "cards")
REAL_DIR = os.path.join(os.path.dirname(__file__), "data", "real")
CATALOG_URL = "https://swdb.coruscant-initiative.org/api/public/cards/"


def load_names():
    try:
        with urllib.request.urlopen(CATALOG_URL, timeout=60) as response:
            catalog = json.load(response)
        return {c["code"]: c.get("name", c["code"]) for c in catalog}
    except Exception:  # noqa: BLE001
        return {}


def pick_device():
    return torch.device("mps") if torch.backends.mps.is_available() else torch.device("cpu")


@torch.no_grad()
def embed(encoder, image, device):
    tensor = anchor_view(image).unsqueeze(0).to(device)
    return F.normalize(encoder(tensor), dim=-1).cpu()


@torch.no_grad()
def scores_with_rotation(encoder, image, index, device):
    """Best score per card across the 4 card orientations (cards get photographed sideways)."""
    per_rotation = []
    for angle in (0, 90, 180, 270):
        rotated = image.rotate(angle, expand=True) if angle else image
        query = embed(encoder, rotated, device)
        per_rotation.append((query @ index.t()).squeeze(0))
    return torch.stack(per_rotation).max(dim=0).values


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--ckpt", default="", help="checkpoint path; empty = off-the-shelf baseline")
    parser.add_argument("--model", default="MobileCLIP-S2")
    parser.add_argument("--pretrained", default="datacompdr")
    args = parser.parse_args()

    device = pick_device()
    encoder = build_encoder(args.model, args.pretrained)
    if args.ckpt:
        ckpt = torch.load(args.ckpt, map_location="cpu")
        encoder.load_state_dict(ckpt["state_dict"])
        print(f"Loaded {args.ckpt}")
    else:
        print("Baseline (off-the-shelf, no fine-tuning)")
    encoder = encoder.to(device).eval()

    names = load_names()
    name = lambda code: names.get(code, code)  # noqa: E731

    # Build scan index.
    scan_paths = sorted(glob.glob(os.path.join(CARDS_DIR, "*.jpg")))
    codes = [os.path.splitext(os.path.basename(p))[0] for p in scan_paths]
    index = torch.cat([embed(encoder, Image.open(p), device) for p in scan_paths])
    print(f"Index: {len(codes)} scans\n")

    real_paths = sorted(glob.glob(os.path.join(REAL_DIR, "*", "*.jpg")) +
                        glob.glob(os.path.join(REAL_DIR, "*", "*.jpeg")) +
                        glob.glob(os.path.join(REAL_DIR, "*", "*.JPG")))
    if not real_paths:
        print(f"No real photos in {REAL_DIR}/<code>/*.jpg")
        return

    labeled = [p for p in real_paths if os.path.basename(os.path.dirname(p)) != "unknown"]
    top1 = top5 = 0

    for path in real_paths:
        true_code = os.path.basename(os.path.dirname(path))
        scores = scores_with_rotation(encoder, Image.open(path).convert("RGB"), index, device)
        top = scores.topk(5)
        ranked = [(codes[i], scores[i].item()) for i in top.indices.tolist()]

        if true_code != "unknown":
            hit1 = ranked[0][0] == true_code
            top1 += hit1
            top5 += any(code == true_code for code, _ in ranked)
            flag = "✓" if hit1 else ("·" if any(c == true_code for c, _ in ranked) else "✗")
        else:
            flag = " "

        preview = " | ".join(f"{name(c)} {s:.2f}" for c, s in ranked)
        print(f"{flag} {os.path.basename(path):<14} → {preview}")

    if labeled:
        n = len(labeled)
        print(f"\nLabeled: {n}   top-1 {top1}/{n} ({100*top1/n:.0f}%)   top-5 {top5}/{n} ({100*top5/n:.0f}%)")


if __name__ == "__main__":
    main()
