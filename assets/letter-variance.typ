#import "handwriting.typ": *
#show: handwritten.with(size: 12pt, ink: black)
#set page(numbering: none, height: 10.4in)
#text(size: 23pt)[#hw("Look closely at the letters.", intensity: 35%, seed: 11)]
#v(7pt)
#hw("Same text and seed. Change the letter and stroke controls.", seed: 12)
#let row(label, letters, strokes) = block(above: 15pt, below: 7pt)[
  #text(size: 10pt)[#label]
  #v(7pt)
  #text(size: 34pt)[#hw("aaaa eeee cccc", seed: 42, intensity: 60%,
    letter-variance: letters, stroke-variance: strokes,
    scale-jitter: 0%, baseline-wave: 0pt, pressure: 0)]
]
#row("Native font cycling only: letters 0%, strokes 0%", 0%, 0%)
#row("Individual choices: letters 80%, strokes 0%", 80%, 0%)
#row("Moderate contour changes: letters 80%, strokes 50%", 80%, 50%)
#row("Stronger contour changes: letters 80%, strokes 100%", 80%, 100%)
#v(9pt)
#hw("Pick exact variants too (1, 5, 9, 13, 17, 21, 25, 29):", seed: 51)
#v(7pt)
#text(size: 36pt)[
  #for i in (1, 5, 9, 13, 17, 21, 25, 29) [
    #hw("a", intensity: 0%, letter-variance: 0%, stroke-variance: 100%,
      letter-variant: i, seed: 7) #h(6pt)
  ]
]
#v(15pt)
#hw("Coffee, little letters, hello. 1111 2222.", seed: 61,
  intensity: 90%, letter-variance: 90%, stroke-variance: 85%)
#v(13pt)
#text(size: 9pt)[Generated contour variations of Shantell Sans, not separate
hand-drawn originals. This is font-outline shaping, not tablet pen-path synthesis.]
