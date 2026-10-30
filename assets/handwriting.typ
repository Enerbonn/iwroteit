// Digital handwriting: actual OpenType alternates plus reproducible variation.
#let pen = rgb("#193d76")
#let random-unit(n) = {
  let a = calc.rem((n + 97) * 127773, 2147483647)
  calc.rem(a * 48271, 2147483647) / 2147483647
}

#let handwritten(body, size: 12pt, ink: pen, paper: "plain") = {
  set page(
    paper: "us-letter",
    margin: (left: 0.78in, right: 0.66in, top: 0.6in, bottom: 0.62in),
    numbering: "1",
    number-align: right,
    background: if paper == "ruled" { context {
      for i in range(36) {
        place(top + left, dy: (43 + i * 20) * 1pt,
          line(length: 100%, stroke: 0.3pt + rgb("#e0e8f2")))
      }
    } },
  )
  set text(font: "Shantell Sans", size: size, weight: 350, fill: ink,
    features: ("rlig": 1, "calt": 1),
    variations: ("INFM": 65, "BNCE": 14, "SPAC": 0, "ital": 0.12),
    hyphenate: false, lang: "en")
  set par(justify: false, leading: 0.65em, spacing: 0.7em)
  body
}

// Keep a word together for the font's real glyph-cycling rules. Do not split
// characters into independent boxes: doing that destroys contextual alternates.
// Jitter is bounded and seeded; a repeated render yields the same geometry.
#let hw(s, seed: 1, irregularity: 65, bounce: 14, variation: 1) = {
  if type(s) != str { return s }
  for (i, word) in s.split(" ").enumerate() {
    let k = seed * 997 + i * 37
    let r = random-unit(k)
    let q = random-unit(k + 29)
    let z = random-unit(k + 61)
    text(
      variations: (
        "INFM": calc.clamp(irregularity + (r - 0.5) * 30 * variation, 0, 100),
        "BNCE": calc.clamp(bounce + (q - 0.5) * 16 * variation, -100, 100),
        "SPAC": r * 1.6 * variation,
        "ital": 0.12 + z * 0.08 * variation,
      ),
      baseline: (q - 0.5) * 0.5pt * variation,
      tracking: (z - 0.5) * 0.09pt * variation,
    )[#word]
    if i < s.split(" ").len() - 1 { [ ] }
  }
}

#let topic(number, title, seed: 1) = block(above: 12pt, below: 6pt)[
  #text(size: 13pt, weight: 470)[#hw(str(number) + ". " + title, seed: seed)]
]
#let note(s, seed: 1) = block(above: 4pt, below: 5pt)[#hw(s, seed: seed)]
#let work(s, seed: 1) = block(above: 5pt, below: 5pt, inset: (left: 13pt))[
  #hw(s, seed: seed)
]
#let answer(s, seed: 1) = block(above: 7pt, below: 8pt)[
  #box(fill: rgb("#fff0a6"), inset: (x: 6pt, y: 3pt), radius: 2pt)[
    #hw(s, seed: seed)
  ]
]

// Handwriting fractions without silently falling back to a printed math font.
// Use in a work block; stacked fractions increase the required line height.
#let hfrac(n, d) = context {
  let numerator = hw(n, seed: 73)
  let denominator = hw(d, seed: 79)
  let w = calc.max(measure(numerator).width, measure(denominator).width) + 7pt
  box(baseline: 7pt)[
    #grid(columns: (w,), align: center, row-gutter: 0.7pt,
      numerator, line(length: 100%, stroke: 0.65pt + pen), denominator)
  ]
}
#let hpower(base, exponent) = [#base#super(exponent)]
