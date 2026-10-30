"""Compile handwriting; image-only PDF by default, selectable text on request."""
import argparse
from pathlib import Path
import shutil
import subprocess


def image_only_pdf(data, dpi=300):
    """Render pages without a text layer, preserving metadata and URI links."""
    import pymupdf
    with pymupdf.open(stream=data, filetype="pdf") as original:
        with pymupdf.open() as result:
            result.set_metadata(original.metadata)
            for source_page in original:
                page = result.new_page(width=source_page.rect.width,
                                       height=source_page.rect.height)
                pixmap = source_page.get_pixmap(dpi=dpi, colorspace=pymupdf.csRGB,
                                               alpha=False)
                page.insert_image(page.rect, stream=pixmap.tobytes("png"))
                for link in source_page.get_links():
                    if link.get("kind") == pymupdf.LINK_URI:
                        page.insert_link({"kind": pymupdf.LINK_URI,
                                          "from": link["from"], "uri": link["uri"]})
            return result.tobytes(garbage=4, deflate=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument("--root", type=Path, required=True,
                        help="Typst project root containing source and skill")
    parser.add_argument("--selectable", action=argparse.BooleanOptionalAction,
                        default=False, help="Keep selectable text (default: off)")
    parser.add_argument("--dpi", type=int, default=300,
                        help="Image-only export resolution (default: 300)")
    args = parser.parse_args()
    root = args.root.resolve()
    source = args.source.resolve()
    output = args.output.resolve()
    source.relative_to(root)
    output.relative_to(root)
    if source == output:
        parser.error("Source and output must be different files")
    if args.dpi < 72:
        parser.error("--dpi must be at least 72")
    executable = shutil.which("typst")
    if not executable:
        parser.error("Typst CLI is required")
    fonts = Path(__file__).resolve().parents[1] / "assets" / "fonts"
    output.parent.mkdir(parents=True, exist_ok=True)
    compiled = subprocess.run([executable, "compile", "--format", "pdf",
                               "--root", str(root), "--font-path", str(fonts),
                               str(source), "-"], stdout=subprocess.PIPE, check=True)
    data = compiled.stdout if args.selectable else image_only_pdf(compiled.stdout, args.dpi)
    output.write_bytes(data)
    print(f"{output} ({'selectable text' if args.selectable else 'image-only, no text layer'})")


if __name__ == "__main__":
    main()
