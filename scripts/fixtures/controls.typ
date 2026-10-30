#import "../../assets/handwriting.typ": *
#let sentence = "coffee coffee coffee coffee coffee coffee coffee coffee"
#handwritten(size: 14pt, intensity: 0%)[#hw(sentence, seed: 17)]
#pagebreak()
#handwritten(size: 14pt, intensity: 100%)[#hw(sentence, seed: 17)]
#pagebreak()
#handwritten(size: 14pt, intensity: 0%)[#hw(sentence, seed: 17, intensity: 100%)]
#pagebreak()
#handwritten(size: 14pt, intensity: 100%)[#hw(sentence, seed: 17, intensity: 0%)]
#pagebreak()
#handwritten(size: 14pt, intensity: 100%)[#hw(sentence, seed: 17,
  scale-jitter: 0%, pressure: 0, baseline-wave: 0pt, variation: 0,
  bounce: 0, irregularity: 0, slant: 0, slant-jitter: 0,
  word-space: 100%, space-jitter: 0%, letter-variance: 0%, stroke-variance: 0%)]
#pagebreak()
#handwritten(size: 14pt)[#hw(sentence, seed: 17)]
#pagebreak()
#handwritten(size: 14pt, intensity: 50%, letter-variance: 50%, stroke-variance: 50%)[#hw(sentence, seed: 17)]
