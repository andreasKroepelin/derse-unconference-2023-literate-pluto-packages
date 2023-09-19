#set page(paper: "presentation-16-9", margin: 0cm, fill: rgb(239, 241, 245))
#set text(size: 25pt, font: "Atkinson Hyperlegible", fill: rgb(76, 79, 105))
#set list(marker: [--])
#show link: set text(font: "JuliaMono")

#block(inset: 1cm, fill: rgb(32, 159, 181), width: 100%, spacing: 0pt, {
  set text(fill: rgb(230, 233, 239))
  text(size: 1.1em)[*Literate package development with Julia and Pluto.jl*]
  linebreak()
  text(font: "Kalam", size: .9em)[
    "The *exploration*  is the *implementation*  is the *documentation*."
  ]
})

#show: pad.with(top: 0cm, rest: 1cm)

#grid(columns: 2, gutter: 1em,
  {
    set align(center)
    set block(spacing: 12pt)
    image("screenshot.png", width: 8cm)
    align(center, sym.arrow.b)
    block(inset: 5pt, radius: 5pt, width: 9cm, fill: rgb(124, 127, 147))[
      #set align(left)
      #set text(font: "JuliaMono", size: 9pt, fill: rgb(239, 241, 245))
      #text(fill: rgb(188, 192, 204))[\# in Julia REPL:] \
      julia> using Gaussian \
      julia> Gaussian.gaussian(3., μ = 4., σ = 1.) \
      0.24197072451914337
    ]
  },
  [
    #v(1fr)

    - Crashcourse on Julia and Pluto.jl notebooks

    - How to develop packages in Julia

    - Create your first literate Julia package as a notebook

    #v(2fr)

    #set text(size: .6em)
    #stack(dir: ltr,
      1fr,
      align(bottom, stack(dir: ttb,
        [Access the GitHub repository:],
        5mm,
        link("https://t1p.de/literate-pluto")[*t1p.de/literate-pluto*]
      )),
      1cm,
      box(image("qr-code.png", height: 4cm))
    )
  ]
)

