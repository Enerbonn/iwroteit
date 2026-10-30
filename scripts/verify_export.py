"""Verify whether a PDF is image-only (default) or contains selectable text."""
import argparse
from pathlib import Path
import pymupdf


def check_image_only(document):
    """Fail if a saved PDF contains text objects/fonts or lacks page images."""
    if not len(document):
        raise ValueError("PDF contains no pages")
    for index, page in enumerate(document, 1):
        if page.get_text() or page.get_fonts() or not page.get_images():
            raise ValueError(f"Page {index} is not image-only")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("pdf", type=Path)
    parser.add_argument("--selectable", action="store_true")
    args = parser.parse_args()
    with pymupdf.open(args.pdf) as document:
        if not len(document):
            raise ValueError("PDF contains no pages")
        if args.selectable:
            if not any(page.get_text().strip() for page in document):
                raise ValueError("Expected selectable text")
        else:
            check_image_only(document)
        print(f"PASS: {len(document)} page(s), "
              + ("selectable text present" if args.selectable
                 else "page images present; no text layer or text fonts"))


if __name__ == "__main__":
    main()
