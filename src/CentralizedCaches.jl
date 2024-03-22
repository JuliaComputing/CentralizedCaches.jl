module CentralizedCaches

export @new_cache, clear_all_caches!

const ALL_CACHES = Dict{Module, Any}()
const ALL_CACHES_LOCK = ReentrantLock()

"""
    @new_cache(cache, keys...)

register a new cache (`cache`) to be tracked by  CentralizedCaches
The only requirement on `T` is that it must implement `empty!(::T)`.

This will be tracked by CentralizedCaches.jl, such that it can be cleared using [`clear_all_caches`](@ref).


Example useage:
 - `@new_cache Dict()` creates a new `Dict` cache registered only by the module
 - `@new_cache IdDict() :solves` creates a new `IdDict` cache registered by module name and the key `:solves`
"""
macro new_cache(cache, keys...)
    :($_new_cache($(esc(cache)), @__MODULE__, $(esc.(keys)...)))
end

function _new_cache(cache, keys...)
    cur_lvl = ALL_CACHES
    lock(ALL_CACHES_LOCK) do
        for key in keys
            cur_lvl = get!(Dict, cur_lvl, key)
        end
        cur_lvl[CacheKey(length(cur_lvl))] = WeakRef(cache)
    end
    return cache
end

# A dummy struct to make sure that nothing that could be used as a Key can collide with the placeholer key used for a cache
struct CacheKey
    id::Int
end

"""
    clear_all_caches!(keys...)

Clears all the caches under the listed keys that we are tracking, by calling `empty!` on them.
Remembering that the first (and often only) key is the module the cache was declared from.

Note that calling this without any arguments will clear all caches from all modules.
Which might not be safe if e.g. code in a background thread is accessing a cache that you don't know about(y)
"""
function clear_all_caches!(keys...)
    lock(ALL_CACHES_LOCK) do 
        cur_level= ALL_CACHES
        for key in keys
            if !haskey(cur_level, key)
                @info "No Caches found" keys
                return
            end
            cur_level = cur_level[key]
        end
        _clear_all_below(cur_level)
    end
end

function _clear_all_below(cur_level)
    for val in values(cur_level)
        if val isa WeakRef
            empty_if_present!(val.value)
        else
            _clear_all_below(val)
        end
    end            
end

empty_if_present!(::Nothing)=nothing
empty_if_present!(x) = empty!(x)


include("deprecated.jl")

end
