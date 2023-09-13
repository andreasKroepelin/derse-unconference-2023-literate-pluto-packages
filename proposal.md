# Literate package development using Julia and Pluto.jl

I propose a workshop in which we look into how to use [Pluto notebooks](https://plutojl.org/) to develop Julia packages in a way that tightly integrates implementation and exploration of scientific code.

## Motivation
Software development in a scientific context is often initiated by a phase of "playing around" with the research subject at hand and trying out different approaches to solving a problem in an explorative way. For this, notebooks (such as Jupyter) provide a powerful tool to combine pieces of code with explanatory text (often stylable using some markup language) and outputs such as visualisations. They therefore allow for quick computational feedback and rapid iteration cycles. If done right, such a notebook can also read as conveniently as a chapter in a textbook, guiding the reader through the possibly intricate details of the implementation.

Often, scientific code is not meant to solve the one particular instance of a problem that is typically found in a notebook, however. Say, you begin your research by analysing one specific data set but later you want to create a general implementation of your solution that others can use as a package. In this case, you would normally have to extract parts of the notebook and create a separate entity of code that then becomes the package. When the exploration continues in the notebook later, this portation has to happen again and again.

As a consequence, it can be very beneficial if the notebook environment allows for the notebook to be "normal" code that can be executed without the environment. For Jupyter notebooks and their JSON based format, this is rather complicated. The aforementioned Pluto notebooks, however, are stored as regular Julia code and can therefore actually be used for package development: The developer has to maintain a single entity of code that serves as the place for exploration, for tests, and for a reusable implementation. Based on ideas of Donald Knuth, this concept is sometimes called _literate programming_.

## Plan for the workshop
This workshop will have roughly the following agenda:
- brief crashcourse on Julia (depending on the prior knowledge of the audience)
- package management in Julia and the typical structure of a package
- introducing Pluto notebooks:
	- writing code
	- adding text
	- visualising results
	- adding interactivity (`PlutoUI.jl`)
	- exporting static HTML
- combining different files/notebooks using `PlutoLinks.jl` and `PlutoDevMacros.jl`
- integrating interactive tests using `PlutoTest.jl`
- developing an example package using what we learned