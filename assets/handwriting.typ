// Digital handwriting: actual OpenType alternates plus reproducible variation.
#let pen = rgb("#193d76")
#let handwriting-settings = state("iwroteit-intensity", 60%)
#let random-unit(n) = {
  let a = calc.rem((n + 97) * 127773, 2147483647)
  calc.rem(a * 48271, 2147483647) / 2147483647
}

#let handwritten(body, size: 12pt, ink: pen, paper: "plain", intensity: 60%) = {
  assert(type(intensity) == ratio and intensity >= 0% and intensity <= 100%,
    message: "intensity must be a percentage from 0% to 100%")
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
  handwriting-settings.update(intensity)
  body
}

// Keep a word together for the font's real glyph-cycling rules. Do not split
// characters into independent boxes: doing that destroys contextual alternates.
// Jitter is bounded and seeded; a repeated render yields the same geometry.
#let hw(
  s, seed: 1, intensity: none, irregularity: none, bounce: none, variation: none,
  word-space: none, space-jitter: none,
  scale: 100%, scale-jitter: none, tracking: 0pt,
  baseline-drift: 0pt, baseline-wave: none,
  stroke-weight: none, pressure: none, slant: none, slant-jitter: none,
  fatigue: 0, fatigue-to: none,
) = context {
  if type(s) != str { return s }
  let intensity = if intensity == none { handwriting-settings.get() } else { intensity }
  assert(type(intensity) == ratio and intensity >= 0% and intensity <= 100%,
    message: "intensity must be a percentage from 0% to 100%")
  let strength = intensity / 100%
  // A main control chooses defaults. Explicit per-property settings win.
  let irregularity = if irregularity == none { 95 * strength } else { irregularity }
  let bounce = if bounce == none { 38 * strength } else { bounce }
  let variation = if variation == none { 1.7 * strength } else { variation }
  let word-space = if word-space == none { 100% + strength * 3% } else { word-space }
  let space-jitter = if space-jitter == none { 50% * strength } else { space-jitter }
  let scale-jitter = if scale-jitter == none { 10% * strength } else { scale-jitter }
  let baseline-wave = if baseline-wave == none { 1.6pt * strength } else { baseline-wave }
  let pressure = if pressure == none { 90 * strength } else { pressure }
  let slant = if slant == none { 0.17 * strength } else { slant }
  let slant-jitter = if slant-jitter == none { 0.18 * strength } else { slant-jitter }
  assert(fatigue >= 0 and fatigue <= 1, message: "fatigue must be 0..1")
  let end-fatigue = if fatigue-to == none { fatigue } else { fatigue-to }
  assert(end-fatigue >= 0 and end-fatigue <= 1,
    message: "fatigue-to must be 0..1")
  let words = s.split(" ")
  for (i, word) in words.enumerate() {
    let k = seed * 997 + i * 37
    let r = random-unit(k)
    let q = random-unit(k + 29)
    let z = random-unit(k + 61)
    let t = i / calc.max(words.len() - 1, 1)
    let f = fatigue + (end-fatigue - fatigue) * t
    let looseness = variation * (1 + 1.4 * f)
    let size-factor = calc.max(60%, scale * (1 - 0.06 * f)
      + (z - 0.5) * (scale-jitter + f * 7%))
    let wave = calc.sin(t * 360deg) * (baseline-wave + f * 0.9pt)
    let style = (
      variations: (
        "INFM": calc.clamp(irregularity + 14 * f + (r - 0.5) * 30 * looseness, 0, 100),
        "BNCE": calc.clamp(bounce + 10 * f + (q - 0.5) * 16 * looseness, -100, 100),
        "SPAC": r * 1.6 * looseness,
        "ital": calc.clamp(slant + (z - 0.5) * slant-jitter + f * 0.12, 0, 1),
      ),
      baseline: (q - 0.5) * 0.5pt * looseness + t * baseline-drift + wave,
      tracking: tracking + (z - 0.5) * 0.09pt * looseness,
      size: 1em * size-factor,
    )
    if stroke-weight != none or pressure != 0 or f != 0 {
      let base-weight = if stroke-weight == none { 350 } else { stroke-weight }
      style.insert("weight", int(calc.round(calc.clamp(base-weight - f * 30
        + (r - 0.5) * (pressure + f * 45), 300, 800))))
    }
    text(..style)[#word]
    if i < words.len() - 1 {
      let spacing = word-space + (r - 0.5) * (space-jitter + f * 35%) + f * 6%
      text(spacing: calc.max(40%, spacing))[ ]
    }
  }
}

// Explicit line: a sloped/curving baseline, inset, and line spacing without
// rotating individual letters or breaking the font's contextual alternate runs.
// Automatic wrapping still works; use short lines for controlled slope/drift.
#let handline(s, angle: 0deg, inset: 0pt, gap: 9pt, ..options) = block(
  above: 0pt, below: gap, inset: (left: inset), breakable: false,
)[#rotate(angle, origin: left + horizon, reflow: true)[#hw(s, ..options)]]

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
#let hfrac(n, d, ink: pen) = context {
  let numerator = hw(n, seed: 73)
  let denominator = hw(d, seed: 79)
  let w = calc.max(measure(numerator).width, measure(denominator).width) + 7pt
  box(baseline: 7pt)[
    #grid(columns: (w,), align: center, row-gutter: 0.7pt,
      numerator, line(length: 100%, stroke: 0.65pt + ink), denominator)
  ]
}
#let hpower(base, exponent) = [#base#super(exponent)]
