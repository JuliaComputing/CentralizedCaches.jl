@testset "deprecated" begin
    cache1 = @test_deprecated new_cache(Dict{Int, Int})
    get!(cache1, 2) do 
        4
    end
    @assert haskey(cache1, 2)
    clear_all_caches!()
    @test isempty(cache1)
end