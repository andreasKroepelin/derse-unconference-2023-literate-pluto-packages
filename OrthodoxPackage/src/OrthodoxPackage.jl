module OrthodoxPackage

using LinearInterpolations


function euler_method(f::Function, x0, t0, Δt, t1)
	x = Float64(x0)
	xs = Float64[x0]
	ts = Float64[t0]
	for t in t0+Δt : Δt : t1
		x += Δt * f(x)
		push!(xs, x)
		push!(ts, t)
	end
    ts, xs
end

"""
	solve(f; x0, t0, Δt, t1)

Solve the initial value problem `dx/dt = f(x), x(t0) = x0` from `t = t0` to `t = t1` in time steps of `Δt`.
Return a callable object that returns the solution given an arbitrary time in [t0, t1].

# Example
-------

```julia-repl
julia> solution = solve(x -> -0.1*x, x0=50, t0=0, t1=20);

julia> solution(3.9485)  # solution at t = 3.9485
33.555815988496505
```
"""
function solve(f; x0, t0, t1, Δt=(t1 - t0)/100)
    ts, xs = euler_method(f, x0, t0, Δt, t1)
	Solution(ts, xs)
end

struct Solution
	ts::Vector{<: Real}
	xs::Vector
	interp::Interpolate

	Solution(ts, xs) = new(ts, xs, Interpolate(ts, xs))
end

(sol::Solution)(t) = sol.interp(t)

export solve

end  # module
