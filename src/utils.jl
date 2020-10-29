
function _equalarrays(a1::AbstractArray{T}, a2::AbstractArray{T}) where T <: Any
    #=
    Compare two arrays for equality.
    =#

    size(a1) == size(a2) ? all(a1 .== a2) : false

end

# exact numeric type
ExactNumber = Union{Complex{Rational{I1}}, Rational{I2}, I3, Complex{I4}} where I1 <: Integer where
I2 <: Integer where I3 <: Integer where I4 <: Integer

function _compresssum(v::AbstractArray{T, 1}) where T

    # if elements can be added together, do so
    cv = Vector{T}()
    for e1 in v

        # try to add this element to one of the previous ones
        matched = false
        for (i, e2) in enumerate(cv)

            if addable(e1, e2)  # we found a place to add to
                cv[i] = e1 + e2
                matched = true
                break
            end

        end

        if !matched # we didn't find a spot to add to, so make a new entry
            push!(cv, e1)
        end

    end

    cv

end
