---
name: iwroteit
description: Create digital handwritten-style documents and PDFs with Typst, using real alternate glyphs, variable letterforms, seeded irregularity, and configurable pen and paper styles. Use for tablet-note or handwriting-simulator documents, not ordinary typed layouts or signature reproduction.
---

# Iwroteit:P

Use Typst as the layout engine and the bundled OFL-licensed Shantell Sans
variable font as the handwriting engine. Apply the PDF skill when exporting
and verifying a PDF. Preserve the requested content, identity, and filename.

## Real variation, rather than a handwriting font alone

The font contains real alternate glyphs cycled by its `rlig` OpenType feature.
Keep `rlig` and `calt` enabled. Its INFM axis varies shaping, BNCE varies the
baseline, SPAC varies spacing, and ital varies slope. The bundled `hw` helper
changes axis settings reproducibly between words, adds restrained baseline and
tracking variation, and preserves contextual shaping within each word.

This offers many rendered variations, but does not mean every letter has 30 or
50 independently drawn originals. Never invent an alternate count. It is a
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
does not automatically align every text baseline. Size, ink, per-word
irregularity, bounce, variation strength, and seeds are configurable. Reduce
variation for dense equations. Set `variation: 0` on `hw` to disable added
word jitter; font-internal alternate cycling remains enabled.

Use `hfrac` for stacked handwritten fractions and `hpower` for superscripts.
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
installing it globally. Typst 0.15.1 was used for the included validation;
recheck custom variable-axis support on other versions.

Render every PDF page and inspect at readable scale. Check letterform variety,
ink weight, math symbols, superscripts, fraction bars, wrapping, clipping,
highlight bounds, and complete problem coverage. Preserve editable Typst.
When changing the engine, include repeated letters and repeated words in a
small specimen; compare `hw` variation on/off and `rlig` on/off. Use PDF vector
glyph geometry or font shaping to check that alternates actually render,
rather than inferring success from a font name or a valid compile.

`assets/specimen.typ` is the reusable visual test. Compile it, then run
`scripts/verify_variation.py SPECIMEN.pdf` (requires PyMuPDF) to compare the
actual glyph IDs for repeated a, C, and 1 with cycling disabled/enabled.
