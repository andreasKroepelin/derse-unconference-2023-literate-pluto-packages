using OrthodoxPackage
using Test

@testset "OrthodoxPackage.jl" begin
    @testset "solve" begin
        decay_solution = solve(N -> -0.1 * N; x0=50, t0=0, t1=20)
        Ns = [decay_solution(t) for t in 0:3:20]
        @test all(diff(Ns) .< 0)
    end
end
