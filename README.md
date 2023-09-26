# Literate package development using Julia and Pluto.jl

## Plan for the workshop

* [Crashcourse on Julia](#julia-in-5-minutes) (depending on the prior knowledge of the audience)
* [Software packages in Julia](#julia-packages)
* [Introducing Pluto notebooks](#pluto-notebooks)
* [Literate package development using notebooks](#creating-a-julia-package-made-of-notebooks)

## Julia in 5 minutes

### Install Julia

#### Linux and Mac
```bash
curl -fsSL https://install.julialang.org | sh
```
<details>
<summary>(details for other shells than bash)</summary>

Note that on shells other than `bash` you might have to manually add the `~/.juliaup/bin` directory to your `PATH`, e.g. on `fish`: 

```fish
set -U fish_user_paths ~/.juliaup/bin $fish_user_paths
```

Fore more details on `juliaup`, visit https://github.com/JuliaLang/juliaup
</details>
<details>
<summary>or  if you prefer a more manual process, expand this section</summary>

got to https://julialang.org/downloads/, download the right archive for your system, extract it and add the contained `bin` directory to your `$PATH`
</details>

#### Windows
```bash
winget install julia -s msstore
```

### Start Julia

```bash
julia
```
![alt text](images/REPL.png "Screenshot of the Julia REPL")

## Julia packages

### Package management

Julia package management is built around environments. We will explore

* what defines an environment in Julia
* how to create different environments for different projects
* how to install public and private packages in an environment

More information can be found in the [manual for Julia's included package manager](https://pkgdocs.julialang.org/v1/)

### Creating a Julia package

We will create a [small Julia package](./ExamplePackage/) and learn

* what defines a Julia package
* how to build a fully functional Julia package
* how to test our package
* how to use our new package

we will **not** discuss in detail:

* [how to publish our package](https://github.com/JuliaRegistries)
* [CI etc.](https://github.com/JuliaCI/)
* [documentation](https://documenter.juliadocs.org/stable/)
* [how to include non-Julia binaries, data, etc. in our package](https://pkgdocs.julialang.org/v1/artifacts/)

## Pluto notebooks

We will use Pluto.jl notebooks for the rest of the workshop.
You can install Pluto [here](https://plutojl.org/#install).
To follow the paradigm of [literate programming](https://en.wikipedia.org/wiki/Literate_programming),
we will explore the following concepts in Pluto notebooks:

- writing code
- adding Markdown formatted text
- reactive behaviour (think spreadsheets)
- notebooks are code files
- plotting results
- interactivity (using [`PlutoUI.jl` package](https://github.com/JuliaPluto/PlutoUI.jl))
- package management in Pluto
- exporting static HTML

## Creating a Julia package made of notebooks

Finally, we will combine all the previously gained knowledge to use Pluto to
create literate Julia packages.
Central ingredients are the [`PlutoDevMacros.jl`](https://github.com/disberd/PlutoDevMacros.jl)
and [`PlutoTest.jl`](https://github.com/JuliaPluto/PlutoTest.jl) packages.
With them, we can

- have code in the notebook (e.g. explorative and interactive elements) that is
  not part of the package
- differentiate between dependencies of our package and those that are only used
  for interactivity in the notebook
- split up our package into multiple files
- add interactive testing