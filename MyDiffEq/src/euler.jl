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

# ╔═╡ 404be5e1-0997-456e-a54d-f36444df8985
# ╠═╡ skip_as_script = true
#=╠═╡
using Rotations
  ╠═╡ =#

# ╔═╡ 59f4db11-dff7-49e4-8f42-f91c7e626f80
# ╠═╡ skip_as_script = true
#=╠═╡
using PlotlyLight
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
Let us now implement the _Euler method_ for solving ordinary differential equations.

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

# ╔═╡ c9add991-2d2a-461c-b16b-c983c567b005
md"""
For example, the following cell loads the `Rotations` package to simplify some testing of our solver later.
However, `Rotations` is only a dependency of this notebook, *not of our package*!
"""

# ╔═╡ 0f23c735-cefd-4e11-aa3b-2c44ba8f9189
#=╠═╡
settings!(
	layout = Config(
		margin = (l = 30, r = 30, t = 30, b = 30),
		height = 200,
		yaxis = (; scaleanchor = "x"),
	),
	config = Config(staticPlot = true),
);
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
	x -> Angle2d(α) * x;
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
Plot(
	x = [x[1] for x in sol.(plotting_times)],
	y = [x[2] for x in sol.(plotting_times)],
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

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlotlyLight = "ca7969ec-10b3-423e-8d99-40f33abb42bf"
PlutoDevMacros = "a0499f29-c39b-4c5c-807c-88074221b949"
PlutoTest = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Rotations = "6038ab10-8711-5258-84ad-4b1120ba62dc"

[compat]
PlotlyLight = "~0.7.3"
PlutoDevMacros = "~0.5.8"
PlutoTest = "~0.2.2"
PlutoUI = "~0.7.52"
Rotations = "~1.5.1"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.0"
manifest_format = "2.0"
project_hash = "6aef80f0ca9451fbd45ce06afefed7a32409ef1e"

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

[[deps.Cobweb]]
deps = ["DefaultApplication", "Markdown", "OrderedCollections", "Random", "Scratch"]
git-tree-sha1 = "49e3de5be079f856697995001c587db8605506a9"
uuid = "ec354790-cf28-43e8-bb59-b484409b7bad"
version = "0.5.2"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.2+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DefaultApplication]]
deps = ["InteractiveUtils"]
git-tree-sha1 = "c0dfa5a35710a193d83f03124356eef3386688fc"
uuid = "3f0dd361-4fe0-5fc6-8523-80b14ec94d85"
version = "1.1.0"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.EasyConfig]]
deps = ["JSON3", "OrderedCollections", "StructTypes"]
git-tree-sha1 = "d22224e636afcb14de0cb5a0a7039095e2238aee"
uuid = "acab07b0-f158-46d4-8913-50acef6d41fe"
version = "0.1.15"

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

[[deps.JSON3]]
deps = ["Dates", "Mmap", "Parsers", "PrecompileTools", "StructTypes", "UUIDs"]
git-tree-sha1 = "95220473901735a0f4df9d1ca5b171b568b2daa3"
uuid = "0f8b85d8-7281-11e9-16c2-39a750bddbf1"
version = "1.13.2"

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

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "716e24b21538abc91f6205fd1d8363f39b442851"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.0"

[[deps.PlotlyLight]]
deps = ["Artifacts", "Cobweb", "DefaultApplication", "Downloads", "EasyConfig", "JSON3", "Random", "Scratch", "StructTypes"]
git-tree-sha1 = "dc3346512c0cb475b578825e66bffe53b77d6fec"
uuid = "ca7969ec-10b3-423e-8d99-40f33abb42bf"
version = "0.7.3"

[[deps.PlutoDevMacros]]
deps = ["HypertextLiteral", "InteractiveUtils", "MacroTools", "Markdown", "Pkg", "Random", "TOML"]
git-tree-sha1 = "6ce1d9f7c078b493812161349c48735dee275466"
uuid = "a0499f29-c39b-4c5c-807c-88074221b949"
version = "0.5.8"

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

[[deps.Quaternions]]
deps = ["LinearAlgebra", "Random", "RealDot"]
git-tree-sha1 = "da095158bdc8eaccb7890f9884048555ab771019"
uuid = "94ee1d12-ae83-5a48-8b1c-48b8ff168ae0"
version = "0.7.4"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RealDot]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "9f0a1b71baaf7650f4fa8a1d168c7fb6ee41f0c9"
uuid = "c1ae055f-0cd5-4b69-90a6-9a35b1a98df9"
version = "0.1.0"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Rotations]]
deps = ["LinearAlgebra", "Quaternions", "Random", "StaticArrays"]
git-tree-sha1 = "54ccb4dbab4b1f69beb255a2c0ca5f65a9c82f08"
uuid = "6038ab10-8711-5258-84ad-4b1120ba62dc"
version = "1.5.1"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "30449ee12237627992a99d5e30ae63e4d78cd24a"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.0"

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

[[deps.StructTypes]]
deps = ["Dates", "UUIDs"]
git-tree-sha1 = "ca4bccb03acf9faaf4137a9abc1881ed1841aa70"
uuid = "856f2bd8-1eba-4b0a-8007-ebc267875bd4"
version = "1.10.0"

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
# ╟─c9add991-2d2a-461c-b16b-c983c567b005
# ╠═404be5e1-0997-456e-a54d-f36444df8985
# ╠═cdffad95-26c1-46c7-af90-c643a2a32199
# ╠═59f4db11-dff7-49e4-8f42-f91c7e626f80
# ╠═0f23c735-cefd-4e11-aa3b-2c44ba8f9189
# ╠═836019af-e493-4e14-81e8-61e4ca65831e
# ╠═6c7d0ed7-fedf-430d-9e4f-1a5fbf91ad2e
# ╠═2cef178b-ad44-414a-a446-029af8f2679c
# ╠═ac2395b5-9cee-432e-be5b-8d39c2fb03f2
# ╠═e307bc65-a7a6-4974-8d5a-a5776324a2f1
# ╠═6d8b6d57-d529-45d8-9e7c-e4df2cfccd62
# ╠═6547f672-83a8-45fe-8395-2913136a3f92
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
