# CentralizedCaches

[![Build Status](https://github.com/JuliaComputing/CentralizedCaches.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/JuliaComputing/CentralizedCaches.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/JuliaComputing/CentralizedCaches.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/JuliaComputing/CentralizedCaches.jl)
[![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)


CentralizedCaches.jl exists to solve the problem that you want to cache a whole bunch of stuff,
but you also want to develop your code interactively.
These means that sometimes you cache the wrong values.
So you need a way to flush all your caches in order to start fresh.

It's basically a way to automate the tracking of your caches.

Creating tracked caches is thread-safe, and the tracking does not prevent garbage collection.

## Usage

We expose a macro that is used to track a cache`@new_cache Dict()` would create a Dict type cache for example.
By default caches are tracked only by their module, but you can place extra code after to add extra keys,
such as `@new_cache IdDict() :solutions` would create a cache that is tracked by module and then within that under the key `solutions`.

Calling `clear_all_caches!(MyModule)` called `empty!` on all caches that are tracked which were declared within `MyModude`.
and `clear_all_caches!(MyModule, :solutions)` which calls `empty!` on the subset of these that were also declared with the `:solutions` key.
You can call `clear_all_caches()` without specifying any modules at all, but that will clear caches including potentially in other packages you know nothing about, so if (for example) you had that running in a background thread you might break something by emptying a cache you knew nothing about while it is being read from.

Generally you would never all `clear_all_caches!` in your package code, but rather you would call it manually from the REPL while interactively developing.