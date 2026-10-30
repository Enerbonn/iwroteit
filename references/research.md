# Research and engine choices

Researched 2026-10-30. Verified links are primary project/documentation sources.

## Default: Shantell Sans + Typst

- Font and license: https://github.com/arrowtype/shantell-sans
- Design process and alternate generation: https://shantellsans.com/process
- Typst text feature/axis controls: https://typst.app/docs/reference/text/text/

Native Shantell Sans cycles glyph alternates using `rlig`, not only `calt`. Its five
axes are wght 300-800, ital 0-1, INFM 0-100, BNCE -100 to 100, and SPAC 0-100.
Alternates and variable-axis interpolation complement each other: the first
changes selected glyph designs; the second provides continuous variation in
shape, height, spacing, and slope. Word-scoped text runs preserve the font's
within-word alternate rules in native mode. Those native alternates can be
visually subtle despite having different IDs and contours.

The current default adds the renamed OFL derivative Iwroteit Ink. It provides
32 generated choices per ASCII letter/digit and an INKR axis for coherent
outline/control-point displacement. Individual mode explicitly selects aalt
variants and disables native rlig/calt for those glyphs; it does not depend on
native contextual cycling after splitting the run. Native mode remains
available when both letter-variance and stroke-variance are zero.

Development checks compare normalized point geometry, excluding translation:
the 32 a, e and C variants are distinct at INKR=100, and all change contour
shape from INKR=0. The enlarged comparison and actual document pages are also
visually reviewed. This tests more than glyph IDs, while not claiming that
font warping is equivalent to learned pen-stroke synthesis.

The font file is bundled unmodified with its OFL license. Download source:
https://raw.githubusercontent.com/arrowtype/shantell-sans/main/fonts/Shantell%20Sans/Desktop/ShantellSans%5BBNCE%2CINFM%2CSPAC%2Cital%2Cwght%5D.ttf

## Other approaches

- https://github.com/ewilderj/hw2font creates OpenType fonts from actual supplied
  writing templates, including contextual alternates from multiple sets. Use
  when the user specifically wants their own writing and supplies samples.
- https://github.com/tmarkovski/longhand offers neural handwriting synthesis and
  SVG output. Its README distinguishes software licensing from model weights;
  some weights are unlicensed and inherited research data has restrictions.
  Audit current weights, punctuation and math coverage before adopting it.
- https://www.cs.toronto.edu/~graves/gen_seq_rnn.pdf is a foundational recurrent
  handwriting-synthesis paper; neural synthesis generates strokes but adds
  model/runtime and exact-text verification work. It is not needed to produce
  varied, searchable Typst notes with correct mathematical notation.

## Boundaries of the default

No personal handwriting sample was supplied. The result is a synthetic digital
handwriting style. It does not simulate pressure-sensitive tablet stroke data.
The number of independently drawn glyphs is finite and differs by character;
continuous axis settings must not be described as independently drawn originals.
