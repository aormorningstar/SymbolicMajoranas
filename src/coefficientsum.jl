
mutable struct CoefficientSum <: AbstractArray{Coefficient, 1}
    #=
    Symbolic sum of symbolic coefficients.
    =#

    coeffs::Vector{Coefficient}

end

# interface with abstract array
size(cs::CoefficientSum) = size(cs.coeffs)

getindex(cs::CoefficientSum, i::Integer) = getindex(cs.coeffs, i)

setindex!(cs::CoefficientSum, c::Coefficient, i::Integer) = setindex!(cs.coeffs, c, i)

function times!(cs::CoefficientSum, mnum::ExactNumber)::Nothing
    #=
    Multiply the numerical prefactors of all coefficients.
    =#

    for c in cs
        times!(c, mnum)
    end

    nothing

end

# a zero element
zero(T::Type{CoefficientSum})::CoefficientSum = CoefficientSum([zero(Coefficient)])

function simplify!(cs::CoefficientSum)::Nothing
    #=
    Simplify the coefficeint sum.
    =#

    # put all coefficents into canonical form
    for c in cs
        canonicalize!(c)
    end

    # if coefficients can be added together, do so
    newcoeffs = _compresssum(cs)

    # replace coefficients with simplified version
    cs.coeffs = newcoeffs

    nothing

end

function *(cs1::CoefficientSum, cs2::CoefficientSum)::CoefficientSum
    #=
    Product of coefficient sums.
    =#

    newcoeffs = [c1*c2 for c1 in cs1, c2 in cs2 if true] # a 1d array
    newcs = CoefficientSum(newcoeffs)

    # simplify the result
    simplify!(newcs)

    newcs

end

function +(cs1::CoefficientSum, cs2::CoefficientSum)::CoefficientSum
    #=
    Add coefficient sums.
    =#

    newcs = CoefficientSum([cs1.coeffs; cs2.coeffs])

    # simplify the result
    simplify!(newcs)

    newcs

end
