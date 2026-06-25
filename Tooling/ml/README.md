# Scanner ML pipeline (fine-tuned embeddings)

Goal: fix the scan→photo domain gap that defeated the off-the-shelf model. We fine-tune the
MobileCLIP image encoder so a phone photo of a card embeds near that card's clean scan, then ship
the fine-tuned encoder + a scan-embedding index.

Setup (reuses the existing venv):
```bash
cd Tooling/ml
../coreml/.venv/bin/pip install -r requirements.txt   # already installed
```

## 1. Download scans (training anchors)
```bash
../coreml/.venv/bin/python download_cards.py     # → data/cards/<code>.jpg
```

## 2. Provide REAL photos (the go/no-go input)
Photograph cards and drop them in `data/real/<code>/`, one folder per card code:
```
data/real/01004/IMG_1.jpg
data/real/01004/IMG_2.jpg
data/real/02001/IMG_1.jpg
```
If labeling by code is a pain, dump everything in `data/real/unknown/` and read the printed top-5
per photo by eye instead of the accuracy number.

## 3. Train
```bash
../coreml/.venv/bin/python train.py --limit 400 --epochs 8 --out runs/s2.pt   # start small
../coreml/.venv/bin/python train.py --epochs 10 --out runs/s2.pt              # full catalog
```

## 4. Evaluate on real photos (go/no-go)
```bash
../coreml/.venv/bin/python eval.py --ckpt runs/s2.pt
../coreml/.venv/bin/python eval.py --ckpt ""        # baseline (off-the-shelf) for comparison
```

## 5. Ship (only if eval looks good)
```bash
../coreml/.venv/bin/python convert_trained.py --ckpt runs/s2.pt \
    --out ../../SWDestinyTrades/Resources/MobileCLIPImage.mlpackage
# then build the scan index with the same model and restore the Swift embedding matcher
```

`data/` and `runs/` are gitignored (large, regenerable).
