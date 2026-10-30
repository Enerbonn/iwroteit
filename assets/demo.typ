#import "handwriting.typ": *
#set document(title: "I wrote this ;>", author: "Iwroteit:P")
#show: handwritten.with(size: 16pt, intensity: 50%,
  letter-variance: 50%, stroke-variance: 50%)
#set page(height: 10.4in, numbering: none,
  margin: (left: 0.66in, right: 0.62in, top: 0.5in, bottom: 0.4in))
#set par(leading: 0.7em)

#text(size: 28pt)[#hw("I wrote this ;>", seed: 71, stroke-weight: 420)]
#v(7pt)
#handline("Yep, wrote this myself. Promise lol.", seed: 13, gap: 6pt)
#handline("Used my tablet pen. Every single letter.", seed: 19, gap: 11pt)
#text(size: 13pt)[
  #hw("Definitely didn't use", seed: 23)
  #link("https://github.com/arrowtype/shantell-sans")[#underline[#hw("Shantell Sans", seed: 24)]]
  #hw("by Shantell Martin and Arrow Type.", seed: 25) \
  #hw("Or", seed: 31)
  #link("https://typst.app/")[#underline[#hw("Typst", seed: 32)]].
  #hw("Still calling it Typscript lol.", seed: 33) \
  #hw("No AI skill called", seed: 41)
  #link("https://github.com/Enerbonn/iwroteit")[#underline[#hw("Iwroteit:P", seed: 42)]]
  #hw("either. Obviously.", seed: 43)
]
#v(14pt)
#hw("Anyway, here are my very scientific presets:", seed: 45)
#v(11pt)

#let label(s) = block(above: 5pt, below: 4pt)[
  #text(size: 9.2pt, fill: rgb("#5b6573"))[#hw(s, seed: 91)]
]
#label("STANDARD / 50 intensity, 50 letters, 50 strokes")
#handline("This is my standard handwriting.", seed: 51, gap: 11pt)

#label("TRYING TO BE PERFECT / 10 intensity, 10 letters, 10 strokes")
#handline("This is me trying to be perfect.", seed: 53,
  intensity: 10%, letter-variance: 10%, stroke-variance: 10%, gap: 11pt)

#label("50% LAZY / standard + fatigue 0.5")
#handline("This is me writing with 50% laziness.", seed: 57,
  fatigue: 0.5, angle: -0.25deg, gap: 11pt)

#label("\"30% DRUNK\" / standard + extra wobble (a visual joke)")
#handline("This is me writing when I'm \"30% drunk\".", seed: 61,
  baseline-wave: 2pt, baseline-drift: -1pt, slant-jitter: 0.4,
  space-jitter: 35%, angle: -0.6deg, gap: 11pt)

#hw("Anyway, still claiming I wrote all of it ;>", seed: 67)
#v(11pt)
#text(size: 9pt)[
  #hw("Actual credits:", seed: 81)
  #link("https://github.com/arrowtype/shantell-sans")[Shantell Sans] +
  #link("https://typst.app/")[Typst] +
  #link("https://github.com/Enerbonn/iwroteit")[Iwroteit:P]. \
  #hw("Generated handwriting. The promises and preset names are jokes.", seed: 83)
]
