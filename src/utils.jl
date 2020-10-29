
function _equalarrays(a1::AbstractArray{T}, a2::AbstractArray{T}) where T <: Any
    #=
    Compare two arrays for equality.
    =#

    size(a1) == size(a2) ? all(a1 .== a2) : false

end

# exact numeric type
ExactType = Union{Complex{Rational{Integer}}, Rational{Integer}, Integer}
