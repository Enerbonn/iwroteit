"""Compile a handwriting Typst document with this skill's bundled font."""
import argparse
from pathlib import Path
import shutil
import subprocess


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument("--root", type=Path, required=True,
                        help="Typst project root containing source and skill")
    args = parser.parse_args()
    root = args.root.resolve()
    source = args.source.resolve()
    output = args.output.resolve()
    source.relative_to(root)
    output.relative_to(root)
    if source == output:
        parser.error("Source and output must be different files")
    executable = shutil.which("typst")
    if not executable:
        parser.error("Typst CLI is required")
    fonts = Path(__file__).resolve().parents[1] / "assets" / "fonts"
    output.parent.mkdir(parents=True, exist_ok=True)
    subprocess.run([executable, "compile", "--root", str(root),
                    "--font-path", str(fonts), str(source), str(output)], check=True)
    print(output)


if __name__ == "__main__":
    main()
