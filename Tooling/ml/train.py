#!/usr/bin/env python3
"""
Fine-tune the MobileCLIP image encoder so a synthetic phone-photo view of a card matches the card's
clean scan (CLIP-style symmetric InfoNCE within each batch).

    ../coreml/.venv/bin/python train.py --limit 400 --epochs 8 --out runs/s2.pt

Start small (--limit) to validate before training the full catalog.
"""

import argparse
import glob
import os

import torch
import torch.nn.functional as F
from PIL import Image
from torch.utils.data import DataLoader, Dataset

from augment import anchor_view, photo_view
from model import build_encoder

DATA_DIR = os.path.join(os.path.dirname(__file__), "data", "cards")


class CardDataset(Dataset):
    def __init__(self, paths):
        self.paths = paths

    def __len__(self):
        return len(self.paths)

    def __getitem__(self, index):
        image = Image.open(self.paths[index]).convert("RGB")
        return photo_view(image), anchor_view(image)


def pick_device():
    if torch.backends.mps.is_available():
        return torch.device("mps")
    return torch.device("cpu")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--data", default=DATA_DIR)
    parser.add_argument("--model", default="MobileCLIP-S2")
    parser.add_argument("--pretrained", default="datacompdr")
    parser.add_argument("--limit", type=int, default=0, help="0 = all cards")
    parser.add_argument("--epochs", type=int, default=8)
    parser.add_argument("--batch", type=int, default=32)
    parser.add_argument("--lr", type=float, default=1e-5)
    parser.add_argument("--temp", type=float, default=0.07)
    parser.add_argument("--out", default="runs/encoder.pt")
    args = parser.parse_args()

    device = pick_device()
    print(f"Device: {device}")

    paths = sorted(glob.glob(os.path.join(args.data, "*.jpg")))
    if args.limit > 0:
        paths = paths[: args.limit]
    print(f"Training on {len(paths)} cards")

    loader = DataLoader(
        CardDataset(paths),
        batch_size=args.batch,
        shuffle=True,
        num_workers=2,
        drop_last=True,
    )

    encoder = build_encoder(args.model, args.pretrained).to(device).train()
    optimizer = torch.optim.AdamW(encoder.parameters(), lr=args.lr)

    for epoch in range(args.epochs):
        total, steps = 0.0, 0
        for photo, anchor in loader:
            photo, anchor = photo.to(device), anchor.to(device)

            photo_emb = F.normalize(encoder(photo), dim=-1)
            anchor_emb = F.normalize(encoder(anchor), dim=-1)

            logits = photo_emb @ anchor_emb.t() / args.temp
            labels = torch.arange(logits.size(0), device=device)
            loss = (F.cross_entropy(logits, labels) + F.cross_entropy(logits.t(), labels)) / 2

            optimizer.zero_grad()
            loss.backward()
            optimizer.step()

            total += loss.item()
            steps += 1
        print(f"epoch {epoch + 1}/{args.epochs}  loss {total / max(steps, 1):.4f}")

    os.makedirs(os.path.dirname(args.out), exist_ok=True)
    torch.save({"model": args.model, "pretrained": args.pretrained,
                "state_dict": encoder.state_dict()}, args.out)
    print(f"Saved {args.out}")


if __name__ == "__main__":
    main()
