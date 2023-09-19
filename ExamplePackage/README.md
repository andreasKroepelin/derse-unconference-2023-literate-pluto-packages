# ExamplePackage

This is an example julia package to demonstrate the directory/file layout.

## Directory and file layout

A quick overview of the most important files

* `Project.toml` contains package metadata such as
    * Package name and version (relevant for julia's built-in package manager)
    * Dependencies and constraints
* `Manifest.toml` current manifestation of the package environment **for the local checkout** (this is normally not checked in to version control)
* `test/runtests.jl` a julia script that serves as the entry point for tests. Tests can then be simply run by a single command in the julia REPL:

   ```julia
   ] test
   ```

* `src/ExamplePackage.jl`: A .jl file with the same name as the package, typically containing

    ```julia
    module ExamplePackage
    include("other_file.jl")
    include("yet_another_file.jl")
    ...
    end  # module
    ```
