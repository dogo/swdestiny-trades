#!/usr/bin/env python3
"""
Build the scan-embedding index (.swdx) using the CONVERTED Core ML model, so the embeddings match
the app's runtime exactly.

    ../coreml/.venv/bin/python build_index.py \
        --model ../../SWDestinyTrades/Resources/MobileCLIPImage.mlpackage \
        --out ../../SWDestinyTrades/Resources/card-embeddings.swdx

Binary format (little-endian), shared with the Swift CardEmbeddingIndex:
  magic("SWDX") | version:u32 | dim:u32 | count:u32  then per entry  codeLen:u16 | codeUTF8 | dim×f32
"""

import argparse
import glob
import os
import struct

import coremltools as ct
from PIL import Image

CARDS_DIR = os.path.join(os.path.dirname(__file__), "data", "cards")
IMAGE_SIZE = 256


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--model", required=True)
    parser.add_argument("--out", default="card-embeddings.swdx")
    args = parser.parse_args()

    model = ct.models.MLModel(args.model)
    output_name = model.get_spec().description.output[0].name

    paths = sorted(glob.glob(os.path.join(CARDS_DIR, "*.jpg")))
    print(f"Embedding {len(paths)} scans…")

    entries = []
    for i, path in enumerate(paths):
        code = os.path.splitext(os.path.basename(path))[0]
        image = Image.open(path).convert("RGB").resize((IMAGE_SIZE, IMAGE_SIZE))
        vector = list(model.predict({"image": image})[output_name].flatten())
        entries.append((code, vector))
        if (i + 1) % 200 == 0:
            print(f"  {i + 1}/{len(paths)}")

    dim = len(entries[0][1])
    with open(args.out, "wb") as file:
        file.write(b"SWDX")
        file.write(struct.pack("<III", 1, dim, len(entries)))
        for code, vector in entries:
            code_bytes = code.encode("utf-8")
            file.write(struct.pack("<H", len(code_bytes)))
            file.write(code_bytes)
            file.write(struct.pack(f"<{dim}f", *vector))

    print(f"Wrote {len(entries)} embeddings (dim {dim}) to {args.out}")


if __name__ == "__main__":
    main()
