import json
import re
from datetime import datetime
from pathlib import Path
from fontTools.ttLib import TTFont

# raiz do projeto = pasta onde você executa o script
PROJECT_ROOT = Path(__file__).resolve().parents[1]

FONT_PATH = PROJECT_ROOT / "SWDestinyTrades/Resources/swdestiny.ttf"
MAPPING_PATH = PROJECT_ROOT / "Resources/mapping.json"
OUTPUT_PATH = PROJECT_ROOT / "SWDestinyTrades/Classes/Generated/SWDIcon.swift"

def to_valid_swift_identifier(name: str) -> str:
    name = re.sub(r"[^0-9a-zA-Z]+", " ", name)
    parts = name.strip().split()
    if not parts:
        return "icon"
    camel = parts[0].lower() + "".join(p.capitalize() for p in parts[1:])
    if camel[0].isdigit():
        camel = "_" + camel
    return camel

def load_mapping(path: Path):
    if not path.exists():
        return {}
    with open(path, "r") as f:
        data = json.load(f)
        return {k.upper(): v for k, v in data.items()}

def generate_enum():
    font = TTFont(str(FONT_PATH))
    cmap = font["cmap"].getBestCmap()

    private_use = {
        cp: glyph
        for cp, glyph in cmap.items()
        if 0xE000 <= cp <= 0xF8FF
    }

    sorted_items = sorted(private_use.items())
    mapping = load_mapping(MAPPING_PATH)

    now = datetime.now()
    last_update = now.strftime("%d/%m/%y")
    year = now.strftime("%Y")

    lines = []
    lines.append("//")
    lines.append("//  SWDIcon.swift")
    lines.append("//  swdestiny-trades")
    lines.append("//")
    lines.append(f"//  Last update: {last_update}.")
    lines.append(f"//  Copyright © {year} Diogo Autilio. All rights reserved.")
    lines.append("//\n")
    lines.append("// AUTO-GENERATED FILE. DO NOT EDIT.\n")
    lines.append("enum SWDIcon: String, CaseIterable {\n")

    for cp, _ in sorted_items:
        hex_code = f"{cp:04X}"
        case_name = (
            to_valid_swift_identifier(mapping[hex_code])
            if hex_code in mapping
            else f"icon{hex_code}"
        )
        lines.append(f'    case {case_name} = "\\u{{{hex_code}}}"')

    # Always add ic_unknown at the end
    lines.append('    case icUnknown = "\\u{2753}"')

    lines.append("\n    var unicode: String { rawValue }")
    lines.append("}\n")

    OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT_PATH.write_text("\n".join(lines))

    print(f"✅ Generated {OUTPUT_PATH.relative_to(PROJECT_ROOT)}")

if __name__ == "__main__":
    generate_enum()