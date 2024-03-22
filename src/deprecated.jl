using Base: @deprecate
    # We will just store them under the CentralizedCaches's module key
@deprecate new_cache(T, args...; kwargs...) (@new_cache T(args...; kwargs...) :deprecated_way)