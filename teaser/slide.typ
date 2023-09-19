#set page(paper: "presentation-16-9", margin: 1cm, fill: rgb(239, 241, 245))
#set text(size: 25pt, font: "Atkinson Hyperlegible", fill: rgb(76, 79, 105))
#set list(marker: [--])

*Literate package development with Julia and Pluto.jl*

#grid(columns: 2, gutter: 1em,
  image("screenshot.png", height: 13cm),
  [
    #text(size: 1.2em)[
      _"The exploration \ is the implementation \ is the documentation"_
    ]

    - Crashcourse: Julia and Pluto.jl notebooks
    - How to develop packages in Julia
    - Create your first literal Julia package as a notebook

    #align(right, {
      text(size: .3em)[Access the GitHub repository!]
      image("qr-code.png", height: 3em)
    })
  ]
)

