"""Render a PDF page to PNG; crop white margins by default."""
import argparse
from pathlib import Path
import pymupdf


def content_bounds(pixmap, padding=24):
    raw = pixmap.samples
    table = bytes(0 if value >= 248 else 1 for value in range(256))
    left, top, right, bottom = pixmap.width, pixmap.height, 0, 0
    for y in range(pixmap.height):
        row = raw[y * pixmap.stride:(y + 1) * pixmap.stride].translate(table)
        stripped = row.lstrip(b"\0")
        if not stripped:
            continue
        x0 = (len(row) - len(stripped)) // pixmap.n
        x1 = (len(row.rstrip(b"\0")) - 1) // pixmap.n + 1
        left, top = min(left, x0), min(top, y)
        right, bottom = max(right, x1), max(bottom, y + 1)
    if right <= left:
        return (0, 0, pixmap.width, pixmap.height)
    return (max(0, left-padding), max(0, top-padding),
            min(pixmap.width, right+padding), min(pixmap.height, bottom+padding))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("pdf", type=Path)
    parser.add_argument("png", type=Path)
    parser.add_argument("--page", type=int, default=1)
    parser.add_argument("--dpi", type=int, default=150)
    parser.add_argument("--padding", type=int, default=24)
    parser.add_argument("--crop", action=argparse.BooleanOptionalAction, default=True)
    args = parser.parse_args()
    if args.dpi < 72 or args.padding < 0:
        parser.error("DPI must be at least 72 and padding must be nonnegative")
    with pymupdf.open(args.pdf) as document:
        if not 1 <= args.page <= len(document):
            parser.error("Page number is outside the PDF")
        page = document[args.page-1]
        pixmap = page.get_pixmap(dpi=args.dpi, colorspace=pymupdf.csRGB, alpha=False)
        if args.crop:
            x0, y0, x1, y1 = content_bounds(pixmap, args.padding)
            factor = args.dpi / 72
            pixmap = page.get_pixmap(dpi=args.dpi, colorspace=pymupdf.csRGB,
                                    alpha=False, clip=pymupdf.Rect(
                                        x0/factor, y0/factor, x1/factor, y1/factor))
        args.png.parent.mkdir(parents=True, exist_ok=True)
        pixmap.save(args.png)
        print(f"{args.png}: {pixmap.width} x {pixmap.height}, crop={args.crop}")


if __name__ == "__main__":
    main()
