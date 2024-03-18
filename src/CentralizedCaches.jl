module CentralizedCaches

export new_cache, clear_all_caches!

const ALL_CACHES = WeakRef[]
const ALL_CACHES_LOCK = ReentrantLock()

"""
    new_cache(T, args...; kwargs...)

Creates a new cache by calling `T(args...; kwargs...)`.
The only requirement on `T` is that it must implement `empty!(::T)`.

This will be tracked by CentralizedCaches.jl, such that it can be cleared using [`clear_all_caches`](@ref).
"""
function new_cache(type, args...; kwargs...)
    ret = type(args...; kwargs...)
    lock(ALL_CACHES_LOCK) do
        push!(ALL_CACHES, WeakRef(ret))
    end
    return ret
end


"""
    clear_all_caches!()

Clears all the caches that we are tracking, by calling `empty!` on them.
Also clears out our internal null references to caches that have already been GC'd
"""
function clear_all_caches!()
    lock(ALL_CACHES_LOCK) do 
        for wref in ALL_CACHES
            empty_if_present!(wref.value)
        end

        # Now is an opertune time to clear out WeakRef's that reference things that have been GC'd
        # since presumably user is not in a performance critical part of code.
        filter!(ALL_CACHES) do wref
            !isnothing(wref.value)
        end
    end
end

empty_if_present!(::Nothing)=nothing
empty_if_present!(x) = empty!(x)



end
