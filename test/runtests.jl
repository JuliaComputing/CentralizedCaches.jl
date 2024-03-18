using CentralizedCaches
using Test
using Aqua

@testset "CentralizedCaches.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(CentralizedCaches)
    end
    # Write your tests here.
end
