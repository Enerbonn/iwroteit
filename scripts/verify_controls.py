"""Check geometry invariants in the PDF from scripts/fixtures/controls.typ."""
import argparse
from pathlib import Path
import pymupdf


def metrics(page):
    return [(char[0], round(span["size"], 4), round(char[2][0], 3),
             round(char[2][1], 3))
            for span in page.get_texttrace() for char in span["chars"]
            if chr(char[0]) in "cofe"]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("pdf", type=Path)
    args = parser.parse_args()
    with pymupdf.open(args.pdf) as document:
        if len(document) != 5:
            raise ValueError("Expected the five-page controls fixture")
        zero, full, passage_full, passage_zero, manual = map(metrics, document)
    checks = {
        "passage 0% overrides global 100%": zero == passage_zero,
        "passage 100% overrides global 0%": full == passage_full,
        "individual settings override master defaults": zero == manual,
        "0% has steady scale and baseline": bool(zero)
        and len({v[1] for v in zero}) == 1 and len({v[3] for v in zero}) == 1,
        "100% varies scale and baseline": len({v[1] for v in full}) > 1
        and len({v[3] for v in full}) > 1,
    }
    for label, passed in checks.items():
        if not passed:
            raise ValueError(label)
        print("PASS:", label)


if __name__ == "__main__":
    main()
