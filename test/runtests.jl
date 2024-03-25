using CentralizedCaches
using Test
using Aqua


module Foo
    using CentralizedCaches
    CACHE = @new_cache Dict{Int, Int}()
    op(x) = get!(()->x^2, CACHE, x)
end

module Bar
    using CentralizedCaches
    CACHE = @new_cache Dict{Int, Int}() :🥚
    op(x) = get!(()->x^2, CACHE, x)
end
@testset "CentralizedCaches.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(CentralizedCaches)
    end

    @testset "functionality" begin
        @assert length(Foo.CACHE) == 0
        Foo.op(1)
        Foo.op(2)
        Foo.op(1)
        @assert length(Foo.CACHE) == 2

        @assert length(Bar.CACHE) == 0
        Bar.op(1)
        Bar.op(2)
        Bar.op(3)
        @assert length(Bar.CACHE) == 3

        clear_all_caches!(Foo)
        @test length(Foo.CACHE) == 0
        @test length(Bar.CACHE) == 3

        clear_all_caches!(Bar)
        @test length(Bar.CACHE) == 0
    end


    include("deprecated.jl")
end
