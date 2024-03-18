# CentralizedCaches

[![Build Status](https://github.com/JuliaComputing/CentralizedCaches.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/JuliaComputing/CentralizedCaches.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/JuliaComputing/CentralizedCaches.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/JuliaComputing/CentralizedCaches.jl)
[![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)


CentralizedCaches.jl exists to solve the problem that you want to cache a whole bunch of stuff,
but you also want to develop your code interactively.
These means that sometimes you cache the wrong values.
So you need a way to flush all your caches in order to start fresh.

It's basically a way to automate the tracking of your caches.

It is thread-safe, and doesn't leak memory.

## Usage
We expose just two functions `new_cache(T, args...; kwargs...)` to create new tracked caches by calling `T(args...; kwargs...)`;
and `clear_all_caches()!` which calls `empty!` on all caches that are tracked (and haven't been GCed already).

Generally you would never all `clear_all_caches` in your code, but rather you would call it manually from the REPL while interactively developing.

Be generally aware that declaring a cache using `new_cache` means someone else (developing some other package) might cause it to be cleared.
By the nature of it being a cache this should always be fine, but exceptions are exceptional.

