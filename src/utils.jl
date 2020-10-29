
function _equalarrays(a1::AbstractArray{T}, a2::AbstractArray{T}) where T <: Any
    #=
    Compare two arrays for equality.
    =#

    size(a1) == size(a2) ? all(a1 .== a2) : false

end

# exact numeric type
ExactType = Union{Complex{Rational{Integer}}, Rational{Integer}, Integer}

function _compresssum(a::AbstractArray{T, 1}) where T

    # if elements can be added together, do so
    ca = T[]
    for e1 in a

        # try to add this element to one of the previous ones
        matched = false
        for (i, e2) in enumerate(ca)

            if addable(e1, e2)  # we found a place to add to
                ca[i] = e1 + e2
                matched = true
                break
            end

        end

        if !matched # we didn't find a spot to add to, so make a new entry
            push!(ca, e1)
        end

    end

    ca

end
