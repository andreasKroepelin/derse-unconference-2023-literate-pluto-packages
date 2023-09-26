using Plots


"""
    solve_decay(N0, t1, λ, [Δt])

Solve the radioactive decay problem starting at time = 0 with `N0`
atoms until time = `t1` given a decay rate parameter `λ`.
Output the solution as a vector of descrete time steps separated by `Δt`
and a vector of atom counts at those time steps.
"""
function solve_decay(N0, t1, λ, Δt=t1/100)
	N = Float64(N0)
	Ns = Float64[N0]
	ts = Float64[0]
	for t in Δt : Δt : t1
        # change in # atoms per time proportional to # atoms
        ΔN_per_time = - λ * N
		N += Δt * ΔN_per_time
		push!(Ns, N)
		push!(ts, t)
	end
    ts, Ns
end

N0 = 50  # Start with 50 atoms
t1 = 20  # Observe the decay for 20 seconds
λ = 0.1  # Avg decay rate of every tenth atom per second

ts, Ns = solve_decay(N0, t1, λ)

p = plot(ts, Ns)
savefig(p, "decay.png")