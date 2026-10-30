---
name: iwroteit
description: Create digital handwritten-style documents and PDFs with Typst, using real alternate glyphs, variable letterforms, seeded irregularity, and configurable pen and paper styles. Use for tablet-note or handwriting-simulator documents, not ordinary typed layouts or signature reproduction.
---

# Iwroteit:P

## Default delivery: no selectable text

Deliver an image-only PDF unless the user explicitly asks for copy/paste or
selectable/searchable text. This applies to this local skill and all ordinary
deliverables. Always use `scripts/compile.py`; a direct `typst compile` export
retains text and is only an intermediate. Never deliver that intermediate by
mistake. The exporter checks the serialized PDF and fails if an image-only
export contains text fonts/text extraction or lacks page images.

Keep `--selectable` as an explicit opt-in. It is not the default. Image-based
pages cannot prevent a PDF viewer from applying its own OCR; describe the
guarantee as "no embedded selectable text layer", not "OCR-proof".

Use Typst as the layout engine and the bundled OFL-licensed Shantell Sans
variable font as the handwriting engine. Apply the PDF skill when exporting
and verifying a PDF. Preserve the requested content, identity, and filename.

## Real variation, rather than a handwriting font alone

Two modes are bundled. Native Shantell Sans uses `rlig`/`calt` and has subtle
alternate shapes. The default `hw` mode uses the renamed OFL derivative
Iwroteit Ink: 32 addressable generated glyph choices per ASCII letter/digit,
with a new INKR axis that smoothly deforms outline/control points. This changes
the contours, not only the positions of words. Composite glyphs vary component
placement. The original font stays unmodified and its license is preserved.

`letter-variance` and `stroke-variance` both range 0%-100% and inherit intensity
by default. Set them document-wide on `handwritten` or override them on `hw`.
The first controls per-letter choices/geometry; the second controls contour
warping. Set both to 0% for native word shaping. `letter-variant: 1` through 32
on `hw` fixes a choice for comparison. At zero stroke variance the generated
glyphs reduce to the underlying native shapes, so many choices look alike.

Individual mode explicitly chooses `aalt` alternatives and turns off native
cycling for those characters; it is intended for this unjoined print font,
not cursive joining or complex-script shaping. Other characters use the original
font; joined scripts are outside individual mode's scope. Seeds are deterministic.

The 32 choices are generated contour variants, not 32 independently drawn
originals. Never describe them as authentic pen strokes or a personal font. It is a
generic synthetic handwriting style, not a reproduction of the user's hand.

Read [the research and implementation notes](references/research.md) when
choosing between fonts, neural synthesis, or a custom handwriting font.

## Author and customize

Import `assets/handwriting.typ` by a path relative to the document; compile with
a project root that contains both document and skill. Start with:

```typst
#import "/.agents/skills/iwroteit/assets/handwriting.typ": *
#show: handwritten.with(size: 12pt, paper: "plain")
#hw("Name and date", seed: 11)
#topic(1, "Example")
#note("A short explanation.", seed: 21)
#work("P(A) = 3/6 = 1/2", seed: 31)
#answer("Answer: 1/2 = 50%", seed: 41)
```

Choose plain white paper and dark blue pen for clean tablet notes. `paper:
"ruled"` adds a light notebook background, but the ruling is decorative and
does not automatically align every text baseline. Start with the main
`handwritten.with(intensity: 50%)` document setting: range 0%-100%, default 50%.
Each `hw` run inherits it; `hw(..., intensity: 85%)` overrides a passage. It coordinates
letter-shape irregularity, bounce, word gaps, scale jitter, slant, smooth
baseline movement, and stroke-weight variation. Use around 15% for neat notes,
50% for ordinary tablet writing, and 90% for loose writing. At 0%, added
irregularity is removed while font-internal alternate cycling stays enabled.

Individual properties override the defaults chosen by intensity. See the
README's control table for exact names and units. Do not claim a graphical
slider exists: the main control is a Typst parameter. Use `intensity: 0%`,
`fatigue: 0` when comparing the geometric baseline with more natural styles.

For requested progression, use `fatigue: 0, fatigue-to: 0.9` within a run or
increase fatigue from 0 to 1 between paragraphs. This is an opt-in visual
preset, not a diagnosis of the writer. It changes size, slant, irregularity,
spacing, baseline, and weight. `handline` adds whole-line `angle`, `inset`, and
`gap`; `baseline-drift` and `baseline-wave` adjust the baseline inside a run.
Use short explicit lines when each line should reset its slope/wave. Long
auto-wrapped paragraphs keep the progression across wraps.

`stroke-weight` selects a font weight from 300 to 800; `pressure` varies it
between words. `stroke-variance` additionally warps the curves. These are
font-outline variations, not pressure-sensitive tablet strokes or independent
pen-path editing. Keep equations readable and inspect small sizes for collisions.

Use `hfrac` for stacked handwritten fractions and `hpower` for superscripts.
Use `brush-answer` instead of `answer` for a yellow tablet-highlighter swipe
with seeded uneven edges, chisel-shaped ends, and overlapping translucent ink.
`brush-highlight(content, seed: 1)` wraps other short content. Each swipe is
unbroken; split long answers into separately highlighted lines to fit the page.
For simple probability work, readable slash fractions also work. Keep fractions,
set members, probabilities and operators unambiguous. Do not accept a mixed
printed-math appearance by accident: ordinary math mode often selects a math
font, because this handwriting font does not contain an OpenType MATH table.
For advanced math, explicitly choose legible hybrid math or build reviewed
vector notation; do not substitute ambiguous Unicode lookalikes.

Avoid excessive jitter, artificial misspellings, fake corrections, invented
pen strokes, and paper textures unless they serve the requested visual style.
Natural variation should not reduce legibility or alter the reasoning.

## Compile and inspect

Run `scripts/compile.py SOURCE OUTPUT --root WORKSPACE`, using absolute paths
or running from the intended project root. It uses the bundled font without
installing it globally. Default export is image-only at 300 DPI, with no
selectable/hidden text layer. `--no-selectable` explicitly chooses that mode;
`--selectable` retains vector text for copy/paste, searching and accessibility.
`--dpi 400` optionally adjusts raster resolution. URI links remain clickable.
Explain that external OCR may recognize even image-only pages; do not promise
to block OCR. Preserve editable Typst source, and honor the user's mode choice.
PyMuPDF is required for image-only export. Typst 0.15.1 was used for validation;
recheck custom variable-axis support on other versions.

Render every PDF page and inspect at readable scale. Check letterform variety,
ink weight, math symbols, superscripts, fraction bars, wrapping, clipping,
highlight bounds, and complete problem coverage. Preserve editable Typst.
When changing the engine, include repeated letters and repeated words in a
small specimen; compare `hw` variation on/off and `rlig` on/off. Use PDF vector
glyph geometry or font shaping to check that alternates actually render,
rather than inferring success from a font name or a valid compile.

Keep all visible Typst content consistent: titles, headings, tables, captions,
page numbers, code snippets, superscripts and equations must look handwritten.
Use `hw` where variation is needed and handwritten notation helpers for math.
The template also sets raw/code text to the handwriting font. Review any
fallback glyphs or math fonts before flattening: image export does not change
their appearance. Keep mathematical meaning unambiguous.

For default output, verify every page has no extracted text, no text fonts,
and at least one page image. Review pixels as well as PDF structure. Perform
content/glyph checks on the selectable intermediate before image-only export.
`scripts/verify_export.py OUTPUT.pdf` checks this structure; add `--selectable`
to verify an intentionally selectable export instead.

`assets/specimen.typ` is the reusable visual test. Compile it, then run
`scripts/verify_variation.py SPECIMEN.pdf` (requires PyMuPDF) to compare the
actual glyph IDs for repeated a, C, and 1 with cycling disabled/enabled.
Compile glyph and geometry fixtures with `--selectable`; their tests require
text objects. The public demo and ordinary deliverables use the image-only
default unless the user explicitly asks for selectable text.
For engine/control changes, compile `scripts/fixtures/controls.typ` and pass
its PDF to `scripts/verify_controls.py`. It checks master settings, inherited
and explicit values, individual overrides, and actual scale/baseline geometry.
Use `assets/demo.typ` for the humorous public preview; retain its clickable
font, layout-engine and skill credits when adapting the joke.

`assets/letter-variance.typ` shows enlarged same-text comparisons at different
stroke strengths and exact variant choices. Inspect it visually; distinct
glyph IDs alone do not prove visibly different contours. Font build/outline
validation uses fonttools only for development; ordinary use needs no new
dependency because both fonts are bundled. See assets/fonts/DERIVATION.md.

For preview PNGs, use `scripts/render_preview.py INPUT.pdf OUTPUT.png`.
It crops white margins with a small padding by default; keep the full PDF page
size unless the user asks to change it. `--no-crop` keeps a page-sized image.
The English public demo shows standard (50/50/50), careful, lazy and playful
wobbly presets. Keep the demo's humor without adding explanations of its jokes.
