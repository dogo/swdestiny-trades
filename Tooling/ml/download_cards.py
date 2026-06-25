#!/usr/bin/env python3
"""
Download every card's canonical scan from the API into data/cards/<code>.jpg.

These scans are the training anchors: augmented "photo" views are matched back to them.
"""

import json
import os
import urllib.request
from concurrent.futures import ThreadPoolExecutor

CATALOG_URL = "https://swdb.coruscant-initiative.org/api/public/cards/"
OUT_DIR = os.path.join(os.path.dirname(__file__), "data", "cards")


def fetch_catalog():
    with urllib.request.urlopen(CATALOG_URL, timeout=60) as response:
        return json.load(response)


def download(card):
    code = card.get("code")
    src = card.get("imagesrc")
    if not code or not src:
        return None
    path = os.path.join(OUT_DIR, f"{code}.jpg")
    if os.path.exists(path) and os.path.getsize(path) > 0:
        return code
    try:
        urllib.request.urlretrieve(src, path)
        return code
    except Exception as error:  # noqa: BLE001
        print(f"  failed {code}: {error}")
        return None


def main():
    os.makedirs(OUT_DIR, exist_ok=True)
    catalog = fetch_catalog()
    print(f"Catalog: {len(catalog)} cards")

    done = 0
    with ThreadPoolExecutor(max_workers=16) as pool:
        for result in pool.map(download, catalog):
            if result:
                done += 1
            if done % 200 == 0:
                print(f"  {done} downloaded")

    print(f"Done. {done} scans in {OUT_DIR}")


if __name__ == "__main__":
    main()
