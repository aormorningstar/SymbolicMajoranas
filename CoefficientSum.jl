include("Coefficient.jl")
import Base: *, iterate, eltype, length, getindex, zero

mutable struct CoefficientSum
    #=
    Symbolic sum of symbolic coefficients paired with the same operator in a Majorana Hamiltonian.
    =#

    coeffs::Vector{Coefficient}

end

function zero(T::Type{CoefficientSum})
    #=
    A standard zero coefficient sum.
    =#

    CoefficientSum(zero(Coefficient))

end

# iterating over coefficients in coefficient sums --------------------------------------------------

getindex(cs::CoefficientSum, i::Integer)::Coefficient = cs.coeffs[i]
eltype(cs::CoefficientSum)::DataType = Coefficient
length(cs::CoefficientSum)::Integer = length(cs.coeffs)

function iterate(cs::CoefficientSum, i::Integer=0)::Union{Nothing, Tuple{Coefficient, Integer}}

    if i >= length(cs)
        return nothing
    else
        return (cs[i+1], i+1)
    end

end

#---------------------------------------------------------------------------------------------------

function simplify!(cs::CoefficientSum)::Nothing
    #=
    Simplify a sum of coefficients. Ex: collect common coefficients.
    =#

    nothing

end

function *(cs1::CoefficientSum, cs2::CoefficientSum)::CoefficientSum
    #=
    Product of coefficient sums.
    =#

    newcoeffs = [c1*c2 for c1 in cs1, c2 in cs2]
    newcoeffsum = CoefficientSum(newcoeffs)

    # simplify the result
    simplify!(newcoeffsum)

    newcoeffsum

end

function multnum!(c::CoefficientSum, mnum::Real)::Nothing
    #=
    Multiply the numerical prefactors of all coefficients.
    =#

    for c in cs
        multnum!(c, mnum)
    end

end

function addphase!(cs::CoefficientSum, aphase::Integer)::Nothing
    #=
    Add the same phase to the phase of all coefficients in the sum.
    =#

    for c in cs
        addphase!(c, aphase)
    end

end
