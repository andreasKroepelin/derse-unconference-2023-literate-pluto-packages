### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ 282235da-a70d-433c-8a5d-bda7880cb461
using PlutoDevMacros

# ╔═╡ c80c39a6-454a-4fb1-9631-4c5f197d5885
@fromparent begin
	using ..MyDiffEq: Solution, tmin, tmax
end

# ╔═╡ 59f4db11-dff7-49e4-8f42-f91c7e626f80
# ╠═╡ skip_as_script = true
#=╠═╡
using PlutoPlotly
  ╠═╡ =#

# ╔═╡ 836019af-e493-4e14-81e8-61e4ca65831e
# ╠═╡ skip_as_script = true
#=╠═╡
using PlutoUI 
  ╠═╡ =#

# ╔═╡ 6d8b6d57-d529-45d8-9e7c-e4df2cfccd62
# ╠═╡ skip_as_script = true
#=╠═╡
using PlutoTest
  ╠═╡ =#

# ╔═╡ d08b694a-3355-4750-b812-76ef55d2df04
md"""
# My implementation of Differential Equation Solving

This notebook serves as a demonstration of how to develop Julia packages _inside_ interactive Pluto.jl notebooks.
"""

# ╔═╡ 9fe9e48f-6acb-4994-aa38-7ba05336703f
md"""
To enable this workflow, we rely on the `PlutoDevMacros` package.
"""

# ╔═╡ aaee3006-3dd4-44b9-a4d1-3bdf3ca837b9
md"""
It lets us include code from other notebooks that are part of this package.
"""

# ╔═╡ 129c56c2-adc3-4979-99a7-6c1ec533944b
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

# ╔═╡ 00ab19bc-5241-11ee-1934-c5b6418d55aa
"""
	solve(f; x0, t0, Δt, t1)

Solves the initial value problem `dx/dt = f(x), x(t0) = x0` from `t = t0` to `t = t1` in time steps of `Δt`.
"""
function solve(f; x0, t0, Δt, t1)
	x = x0
	xs = [x0]
	ts = [t0]
	for t in t0+Δt : Δt : t1
		x += Δt * f(x)
		push!(xs, x)
		push!(ts, t)
	end
	Solution(ts, xs)
end

# ╔═╡ 1f45300c-3344-4e6a-8d69-bc8947d4b303
btn_svg = """
<svg viewBox="0 0 512 512" xmlns="http://www.w3.org/2000/svg" width="16" height="16"><circle cx="256" cy="256" r="26"/><circle cx="346" cy="256" r="26"/><circle cx="166" cy="256" r="26"/><path d="M448 256c0-106-86-192-192-192S64 150 64 256s86 192 192 192 192-86 192-192Z" style="fill:none;stroke:#000;stroke-miterlimit:10;stroke-width:32px"/></svg>
""";

# ╔═╡ 4aec16b8-bb2c-4d9d-8d8f-4589a259e32a
md"""
Now, we don't just want to provide an implementation but also explore our code.
Users of our package, on the other hand, will in general not be interested in our exploration.
That is why many of the following cells have a **prominent right border**, indicating that the respective cell is only run as part of the notebook but is disabled when run as a file.
You can click on the $(HTML(btn_svg)) button in the top right corner of a code cell to change that.
"""

# ╔═╡ e4ee916a-b393-42e0-b639-be136348fa96
#=╠═╡
layout = Layout(yaxis = attr(scaleanchor = "x"))
  ╠═╡ =#

# ╔═╡ ac2395b5-9cee-432e-be5b-8d39c2fb03f2
#=╠═╡
@bind α Slider(.01:.01:2pi, show_value = true, default = pi/2)
  ╠═╡ =#

# ╔═╡ e307bc65-a7a6-4974-8d5a-a5776324a2f1
#=╠═╡
@bind dt Slider(0.0001:0.01:1)
  ╠═╡ =#

# ╔═╡ cdffad95-26c1-46c7-af90-c643a2a32199
#=╠═╡
sol = solve(
	x -> [cos(α) -sin(α); sin(α) cos(α)] * x;
	x0 = [1., 0.],
	t0 = 0., Δt = dt, t1 = 11.
)
  ╠═╡ =#

# ╔═╡ 6c7d0ed7-fedf-430d-9e4f-1a5fbf91ad2e
# ╠═╡ skip_as_script = true
#=╠═╡
plotting_times = tmin(sol) : .1 : tmax(sol)
  ╠═╡ =#

# ╔═╡ 2cef178b-ad44-414a-a446-029af8f2679c
#=╠═╡
plot(
	scatter(
		x = [x[1] for x in sol.(plotting_times)],
		y = [x[2] for x in sol.(plotting_times)],
	),
	layout
)
  ╠═╡ =#

# ╔═╡ 6547f672-83a8-45fe-8395-2913136a3f92
#=╠═╡
@test all(
	diff(
		solve(x -> -x, x0 = 1., t0 = 0., Δt = .1, t1 = 1.).xs
	)
	.< 0
)
  ╠═╡ =#

# ╔═╡ 72d1a763-a993-4356-9fec-e11ca3d32f9b
diff([1, 2, 3, -6])

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoDevMacros = "a0499f29-c39b-4c5c-807c-88074221b949"
PlutoPlotly = "8e989ff0-3d88-8e9f-f020-2b208a939ff0"
PlutoTest = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoDevMacros = "~0.5.8"
PlutoPlotly = "~0.3.9"
PlutoTest = "~0.2.2"
PlutoUI = "~0.7.52"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.0"
manifest_format = "2.0"
project_hash = "c88c72d5a20a32238062ceb85be581e6ee819cbd"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "91bd53c39b9cbfb5ef4b015e8b582d344532bd0a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.0"

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

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "9ee1618cbf5240e6d4e0371d6f24065083f60c48"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.11"

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

[[deps.PlutoDevMacros]]
deps = ["HypertextLiteral", "InteractiveUtils", "MacroTools", "Markdown", "Pkg", "Random", "TOML"]
git-tree-sha1 = "6ce1d9f7c078b493812161349c48735dee275466"
uuid = "a0499f29-c39b-4c5c-807c-88074221b949"
version = "0.5.8"

[[deps.PlutoPlotly]]
deps = ["AbstractPlutoDingetjes", "Colors", "Dates", "HypertextLiteral", "InteractiveUtils", "LaTeXStrings", "Markdown", "PackageExtensionCompat", "PlotlyBase", "PlutoUI", "Reexport"]
git-tree-sha1 = "9a77654cdb96e8c8a0f1e56a053235a739d453fe"
uuid = "8e989ff0-3d88-8e9f-f020-2b208a939ff0"
version = "0.3.9"

    [deps.PlutoPlotly.extensions]
    PlotlyKaleidoExt = "PlotlyKaleido"

    [deps.PlutoPlotly.weakdeps]
    PlotlyKaleido = "f2990250-8cf9-495f-b13a-cce12b45703c"

[[deps.PlutoTest]]
deps = ["HypertextLiteral", "InteractiveUtils", "Markdown", "Test"]
git-tree-sha1 = "17aa9b81106e661cffa1c4c36c17ee1c50a86eda"
uuid = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"
version = "0.2.2"

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
# ╟─d08b694a-3355-4750-b812-76ef55d2df04
# ╟─9fe9e48f-6acb-4994-aa38-7ba05336703f
# ╠═282235da-a70d-433c-8a5d-bda7880cb461
# ╟─aaee3006-3dd4-44b9-a4d1-3bdf3ca837b9
# ╠═c80c39a6-454a-4fb1-9631-4c5f197d5885
# ╟─129c56c2-adc3-4979-99a7-6c1ec533944b
# ╠═00ab19bc-5241-11ee-1934-c5b6418d55aa
# ╟─1f45300c-3344-4e6a-8d69-bc8947d4b303
# ╟─4aec16b8-bb2c-4d9d-8d8f-4589a259e32a
# ╠═cdffad95-26c1-46c7-af90-c643a2a32199
# ╠═59f4db11-dff7-49e4-8f42-f91c7e626f80
# ╠═836019af-e493-4e14-81e8-61e4ca65831e
# ╠═6c7d0ed7-fedf-430d-9e4f-1a5fbf91ad2e
# ╠═e4ee916a-b393-42e0-b639-be136348fa96
# ╠═2cef178b-ad44-414a-a446-029af8f2679c
# ╠═ac2395b5-9cee-432e-be5b-8d39c2fb03f2
# ╠═e307bc65-a7a6-4974-8d5a-a5776324a2f1
# ╠═6d8b6d57-d529-45d8-9e7c-e4df2cfccd62
# ╠═6547f672-83a8-45fe-8395-2913136a3f92
# ╠═72d1a763-a993-4356-9fec-e11ca3d32f9b
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
