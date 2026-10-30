"""Development check: verify contour diversity, not only different glyph IDs."""
import argparse
from pathlib import Path
from fontTools.ttLib import TTFont


def normalized(points):
    left = min(x for x, _ in points)
    bottom = min(y for _, y in points)
    return tuple((round(x-left, 3), round(y-bottom, 3)) for x, y in points)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("font", type=Path)
    args = parser.parse_args()
    font = TTFont(args.font)
    cmap = font.getBestCmap()
    for character in "aeC":
        base = cmap[ord(character)]
        changed = 0
        outlines = set()
        for i in range(1, 33):
            name = f"{base}.ink{i:02}"
            points, _, _ = font["glyf"][name].getCoordinates(font["glyf"])
            warp = next(t for t in font["gvar"].variations[name] if "INKR" in t.axes)
            deformed = [(x+(delta[0] if delta else 0), y+(delta[1] if delta else 0))
                        for (x, y), delta in zip(points, warp.coordinates)]
            plain = normalized(points)
            shaped = normalized(deformed)
            changed += plain != shaped
            outlines.add(shaped)
        if changed != 32 or len(outlines) != 32:
            raise ValueError(f"Contour diversity failed for {character}: {changed}, {len(outlines)}")
        print(f"PASS {character}: 32 unique normalized contours at INKR=100; all change shape, not just position")


if __name__ == "__main__":
    main()
