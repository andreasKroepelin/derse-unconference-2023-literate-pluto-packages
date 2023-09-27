### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 69910123-e70c-4cbf-bbff-6747b62e8980
using LinearInterpolations

# ╔═╡ a764fcd0-04cc-49e1-a5d4-df08a20b8716
using PlutoPlotly

# ╔═╡ 5ff47949-68d2-4632-8666-4ca7d340595e
using PlutoUI

# ╔═╡ 1e2864a8-40f3-45fa-96b4-1e5db6c96bed
md"""
# Differential Equation Solving

This notebook serves as a demonstration of Pluto.jl notebooks.
"""

# ╔═╡ 314417f3-e3af-405f-b9ee-b274f6aaafa7
md"""
Let us implement the _Euler method_ for solving ordinary differential equations.

Given an initial value problem
```math
\frac{\mathrm{d}x}{\mathrm{d}t} = f(x), \quad x(t_0) = x_0
```
it makes use of the approximation
```math
\frac{x_\text{next} - x_\text{prev}}{\Delta t} \approx f(x_\text{prev})
```
for small enough ``\Delta t``.
Rearranging yields:
```math
x_\text{next} \approx x_\text{prev} + \Delta t \cdot f(x_\text{prev})
```
As Julia code, this could look like the following:
"""

# ╔═╡ 70a95f8a-12dc-4b79-a12c-f1ceef92981f
function solve_raw(f; x0, t0, Δt, t1)
	x = x0
	xs = [x0]
	ts = [t0]
	for t in t0+Δt : Δt : t1
		x += Δt * f(x)
		push!(xs, x)
		push!(ts, t)
	end

	(;ts, xs)
end

# ╔═╡ 69a34fdf-e15c-4a5c-9249-a8106a80a489
md"""
Let us test this implementation on a very simple problem:
```math
\dot{x} = -x
\qquad
x(0) = 2
```
"""

# ╔═╡ c9ba7552-0a62-4425-9150-5ad3fd8ac5da
sol = solve_raw(
	x -> -x;
	x0 = 2.,
	t0 = 0., Δt = .1, t1 = 11.
)

# ╔═╡ 589fe43b-5f30-4081-9433-c89f286432c9
md"""
The solution should approach zero.
"""

# ╔═╡ c8782cb3-d42a-40f6-a788-8163025e9c50
last(sol.xs)

# ╔═╡ 37f90e79-4150-48ec-b34f-18bd0331bd17
md"""
## Interpolation
We used a time step of `.1` for the algorithm but what if we want to evaluate the solution at other points in time than the integration nodes?

Let us implement a wrapper around the raw `xs` and `ts` arrays from before that allows for interpolation:
"""

# ╔═╡ ecc33216-47f2-4c28-8ff7-2d74f102240c
begin
struct Solution
	ts::Vector{<: Real}
	xs::Vector
	interp::Interpolate

	Solution(ts, xs) = new(ts, xs, Interpolate(ts, xs))
end

(sol::Solution)(t) = sol.interp(t)
	
end

# ╔═╡ c609c2c8-5dae-43a3-9c69-0ef6ef94c7ff
md"""
Let us see this in action.
"""

# ╔═╡ 9c9b5d86-c387-4ecb-a151-530d628aeb74
sol_finegrained = Solution(sol.ts, sol.xs)

# ╔═╡ ad192426-69a3-49a1-8f97-c1eaf8894bfb
md"""
We can call this object like a function to obtain values at arbitrary time steps along the integration interval.
"""

# ╔═╡ a4e516f6-2e79-4411-a6d9-66ad0df86791
sol_finegrained(.05)

# ╔═╡ dce5d1b9-40dc-43bc-b496-3faf152c4909
md"""
We can write a new `solve` function that automatically wraps its output in a `Solution`:
"""

# ╔═╡ 4b1c8642-0d43-4765-8bd1-c55fe5309f22
"""
	solve(f; x0, t0, Δt, t1)

Solves the initial value problem `dx/dt = f(x), x(t0) = x0` from `t = t0` to `t = t1` in time steps of `Δt`.
"""
function solve(f; x0, t0, Δt, t1)
	s = solve_raw(f; x0, t0, Δt, t1)
	Solution(s.ts, s.xs)
end

# ╔═╡ 6d08a15a-b878-4ad0-93a6-15595e3e097b
md"""
## Plotting
Now, let us plot our solution!
"""

# ╔═╡ 4567e8ca-003b-4128-a778-1d4dd421fdfa
plotting_times = 0:.01:10

# ╔═╡ a49fabdd-b34f-4ad4-97cc-3b85a60e6487
plot(
	scatter(x = plotting_times, y = sol_finegrained.(plotting_times))
)

# ╔═╡ 231baeb1-1b04-4cc2-a061-59e6d7ca0980
md"""
## Interactivity
We can also make all this interactive!
"""

# ╔═╡ a190ae62-c605-477d-825a-4f024cfa6dc6
@bind rate Slider(.1:.1:5, show_value = true)

# ╔═╡ 09871353-2148-40b8-8d16-16373f827fba
sol_variable = solve(
	x -> -rate * x;
	x0 = 2.,
	t0 = 0., Δt = .1, t1 = 11.
)

# ╔═╡ 662b4c82-de3d-43cc-b20a-db9d9c898f2a
plot(
	scatter(x = plotting_times, y = sol_variable.(plotting_times))
)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
LinearInterpolations = "b20c7882-2490-4592-a606-fbbfe9e745e8"
PlutoPlotly = "8e989ff0-3d88-8e9f-f020-2b208a939ff0"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
LinearInterpolations = "~0.1.6"
PlutoPlotly = "~0.3.9"
PlutoUI = "~0.7.52"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.0"
manifest_format = "2.0"
project_hash = "f894da6203532736132a0370ad486c1025d83d00"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "91bd53c39b9cbfb5ef4b015e8b582d344532bd0a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.0"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "76289dc51920fdc6e0013c872ba9551d54961c24"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.6.2"
weakdeps = ["StaticArrays"]

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

[[deps.ArgCheck]]
git-tree-sha1 = "a3a402a35a2f7e0b87828ccabbd5ebfbebe356b4"
uuid = "dce04be8-c92d-5529-be00-80e4d2c0e197"
version = "2.3.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "d9a8f86737b665e15a9641ecbac64deef9ce6724"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.23.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

    [deps.ColorVectorSpace.weakdeps]
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.2+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LinearInterpolations]]
deps = ["Adapt", "ArgCheck", "StaticArrays"]
git-tree-sha1 = "aae00c2026735299eabe4ba71e5b2eec0ebf2273"
uuid = "b20c7882-2490-4592-a606-fbbfe9e745e8"
version = "0.1.6"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OrderedCollections]]
git-tree-sha1 = "2e73fe17cac3c62ad1aebe70d44c963c3cfdc3e3"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.2"

[[deps.PackageExtensionCompat]]
git-tree-sha1 = "f9b1e033c2b1205cf30fd119f4e50881316c1923"
uuid = "65ce6f38-6b18-4e1d-a461-8949797d7930"
version = "1.0.1"
weakdeps = ["Requires", "TOML"]

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "716e24b21538abc91f6205fd1d8363f39b442851"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.0"

[[deps.PlotlyBase]]
deps = ["ColorSchemes", "Dates", "DelimitedFiles", "DocStringExtensions", "JSON", "LaTeXStrings", "Logging", "Parameters", "Pkg", "REPL", "Requires", "Statistics", "UUIDs"]
git-tree-sha1 = "56baf69781fc5e61607c3e46227ab17f7040ffa2"
uuid = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
version = "0.8.19"

[[deps.PlutoPlotly]]
deps = ["AbstractPlutoDingetjes", "Colors", "Dates", "HypertextLiteral", "InteractiveUtils", "LaTeXStrings", "Markdown", "PackageExtensionCompat", "PlotlyBase", "PlutoUI", "Reexport"]
git-tree-sha1 = "9a77654cdb96e8c8a0f1e56a053235a739d453fe"
uuid = "8e989ff0-3d88-8e9f-f020-2b208a939ff0"
version = "0.3.9"

    [deps.PlutoPlotly.extensions]
    PlotlyKaleidoExt = "PlotlyKaleido"

    [deps.PlutoPlotly.weakdeps]
    PlotlyKaleido = "f2990250-8cf9-495f-b13a-cce12b45703c"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "e47cd150dbe0443c3a3651bc5b9cbd5576ab75b7"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.52"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "7eb1686b4f04b82f96ed7a4ea5890a4f0c7a09f1"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore"]
git-tree-sha1 = "51621cca8651d9e334a659443a74ce50a3b6dfab"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.6.3"
weakdeps = ["Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysStatisticsExt = "Statistics"

[[deps.StaticArraysCore]]
git-tree-sha1 = "36b3d696ce6366023a0ea192b4cd442268995a0d"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.2"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"

[[deps.URIs]]
git-tree-sha1 = "b7a5e99f24892b6824a954199a45e9ffcc1c70f0"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.7.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╟─1e2864a8-40f3-45fa-96b4-1e5db6c96bed
# ╟─314417f3-e3af-405f-b9ee-b274f6aaafa7
# ╠═70a95f8a-12dc-4b79-a12c-f1ceef92981f
# ╟─69a34fdf-e15c-4a5c-9249-a8106a80a489
# ╠═c9ba7552-0a62-4425-9150-5ad3fd8ac5da
# ╟─589fe43b-5f30-4081-9433-c89f286432c9
# ╠═c8782cb3-d42a-40f6-a788-8163025e9c50
# ╟─37f90e79-4150-48ec-b34f-18bd0331bd17
# ╠═69910123-e70c-4cbf-bbff-6747b62e8980
# ╠═ecc33216-47f2-4c28-8ff7-2d74f102240c
# ╟─c609c2c8-5dae-43a3-9c69-0ef6ef94c7ff
# ╠═9c9b5d86-c387-4ecb-a151-530d628aeb74
# ╟─ad192426-69a3-49a1-8f97-c1eaf8894bfb
# ╠═a4e516f6-2e79-4411-a6d9-66ad0df86791
# ╟─dce5d1b9-40dc-43bc-b496-3faf152c4909
# ╠═4b1c8642-0d43-4765-8bd1-c55fe5309f22
# ╟─6d08a15a-b878-4ad0-93a6-15595e3e097b
# ╠═a764fcd0-04cc-49e1-a5d4-df08a20b8716
# ╠═4567e8ca-003b-4128-a778-1d4dd421fdfa
# ╠═a49fabdd-b34f-4ad4-97cc-3b85a60e6487
# ╟─231baeb1-1b04-4cc2-a061-59e6d7ca0980
# ╠═5ff47949-68d2-4632-8666-4ca7d340595e
# ╠═09871353-2148-40b8-8d16-16373f827fba
# ╠═a190ae62-c605-477d-825a-4f024cfa6dc6
# ╠═662b4c82-de3d-43cc-b20a-db9d9c898f2a
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
