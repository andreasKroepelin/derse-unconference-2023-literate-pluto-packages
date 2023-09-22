using ExamplePackage
using Test

@testset "ExamplePackage.jl" begin
    @testset "dot" begin
        e_x = [1, 0, 0]
        e_y = [0, 1, 0]
        e_z = [0, 0, 1]
        
        @test dot(e_x, e_x) == 1
        @test dot(e_x, 5 .* e_x) == 5
        @test dot(e_x, e_y) == 0
        @test dot(e_x, e_z) == 0
    end
end
