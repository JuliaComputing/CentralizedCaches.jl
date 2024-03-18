using CentralizedCaches
using Test
using Aqua

@testset "CentralizedCaches.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(CentralizedCaches)
    end
    
    @testset "functionality" begin
        cache1 = new_cache(Dict{Int, Int})
        get!(cache1, 2) do 
            4
        end
        @assert haskey(cache1, 2)
        clear_all_caches!()
        @test isempty(cache1)
    end
end
