#import "handwriting.typ": *
#set document(title: "I wrote this ;>", author: "Iwroteit:P")
#show: handwritten.with(size: 17pt)
#set page(height: 10.4in, numbering: none,
  margin: (left: 0.72in, right: 0.7in, top: 0.62in, bottom: 0.5in))
#set par(leading: 0.9em)

#text(size: 29pt)[#hw("I wrote this ;>", seed: 71, intensity: 25%, stroke-weight: 430)]
#v(3pt)
#line(length: 73%, angle: -0.4deg, stroke: 1.2pt + pen)
#v(20pt)

#handline("Yep, wrote this myself. Promise lol.", seed: 13,
  intensity: 20%, stroke-weight: 385, pressure: 12, gap: 11pt)
#handline("Used my tablet pen for the whole thing.", seed: 19,
  intensity: 30%, stroke-weight: 375, pressure: 22, gap: 16pt)

#block(below: 10pt)[
  #hw("Definitely didn't use", seed: 23)
  #link("https://github.com/arrowtype/shantell-sans")[#underline[#hw("Shantell Sans", seed: 24)]] \
  #hw("by Shantell Martin and Arrow Type. Nope.", seed: 25)
]
#block(below: 13pt)[
  #hw("And", seed: 31)
  #link("https://typst.app/")[#underline[#hw("Typst", seed: 32)]]?
  #hw("I still call that Typscript lol.", seed: 33) \
  #hw("So yeah, obviously this was all manual.", seed: 34, fatigue: 0.15)
]

#handline("No AI agent using a skill specifically made", seed: 41,
  fatigue: 0.2, fatigue-to: 0.4, pressure: 35, gap: 5pt)
#block(below: 17pt)[#hw("for this, like", seed: 43, fatigue: 0.3)
  #link("https://github.com/Enerbonn/iwroteit")[#underline[#hw("Iwroteit:P", seed: 44, fatigue: 0.35)]].
  #hw("That would be too convenient.", seed: 45, fatigue: 0.4)]

#handline("Getting lazy near the bottom now.", seed: 51,
  intensity: 75%, fatigue: 0.4, fatigue-to: 0.65, space-jitter: 24%,
  baseline-wave: 0.7pt, angle: -0.5deg, gap: 8pt)
#handline("My hand is tired, okay?", seed: 53,
  fatigue: 0.6, scale-jitter: 5%, word-space: 110%,
  baseline-drift: -1.6pt, inset: 6pt, gap: 9pt)
#handline("Nothing to do with fatigue: 0.85. Hehehe.", seed: 57,
  intensity: 90%, fatigue: 0.85, pressure: 65, scale: 96%, space-jitter: 35%,
  baseline-wave: 1.1pt, angle: -0.8deg, gap: 16pt)

#handline("Wait, you can change that with one setting?", seed: 61,
  fatigue: 0.9, scale: 97%, scale-jitter: 8%, word-space: 112%,
  baseline-wave: 1.7pt, pressure: 80, angle: 0.3deg, inset: 3pt, gap: 12pt)
#handline("Anyway, wrote it myself. You saw nothing ;>", seed: 67,
  intensity: 100%, fatigue: 1, scale: 103%, scale-jitter: 10%, pressure: 95,
  word-space: 111%, space-jitter: 35%, baseline-drift: -2pt,
  angle: -0.6deg, inset: 8pt, gap: 15pt)

#v(9pt)
#text(size: 10pt)[
  #hw("Okay fine, actual credits (click them):", seed: 81)
  #link("https://github.com/arrowtype/shantell-sans")[Shantell Sans] +
  #link("https://typst.app/")[Typst] +
  #link("https://github.com/Enerbonn/iwroteit")[Iwroteit:P]. \
  #hw("This is a generated handwriting demo. The promises are a joke.", seed: 83)
]
