# OrthodoxPackage

This is an example Julia package to demonstrate the directory/file layout that define a julia package.

## Directory and file layout

A quick overview of the most important files

* `Project.toml` contains package metadata such as
    * Package name and version (relevant for Julia's built-in package manager)
    * Dependencies and constraints

  and defines the package **environment** toghether with the next file:
* `Manifest.toml` current manifestation of the package environment **for the local checkout** (this is normally not checked in to version control)
* `test/runtests.jl` a Julia script that serves as the entry point for tests. Tests can then be simply run by a single command in the Julia REPL:

   ```julia-repl
   ] test
   ```

* `src/OrthodoxPackage.jl`: A .jl file with the same name as the package, typically containing

    ```julia
    module OrthodoxPackage
    using SomePackage, AnotherPackage  # imports dependencies

    include("code_file.jl")
    include("another_code_file.jl")
    ...
    end  # module
    ```
