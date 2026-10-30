"""Verify real glyph cycling in a PDF compiled from assets/specimen.typ."""
import argparse
import json
from pathlib import Path
import pymupdf


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("specimen", type=Path)
    args = parser.parse_args()
    document = pymupdf.open(args.specimen)
    runs = [span for page in document for span in page.get_texttrace()
            if len(span["chars"]) >= 20
            and all(char[0] == ord("a") for char in span["chars"][:20])]
    if len(runs) != 2:
        raise ValueError("Expected the specimen's cycling-off and cycling-on runs")
    results = {}
    for character in ("a", "C", "1"):
        counts = [len({c[1] for c in span["chars"] if c[0] == ord(character)})
                  for span in runs]
        if counts[0] != 1 or counts[1] <= counts[0]:
            raise ValueError(f"Alternate glyphs did not render for {character}: {counts}")
        results[character] = {"cycling_off": counts[0], "cycling_on": counts[1]}
    print(json.dumps(results, indent=2))


if __name__ == "__main__":
    main()
