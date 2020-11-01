
mutable struct CoefficientSum <: AbstractVector{Coefficient}
    #=
    Symbolic sum of symbolic coefficients.
    =#

    coeffs::Vector{Coefficient}

end

# interface with abstract array
size(cs::CoefficientSum) = size(cs.coeffs)

getindex(cs::CoefficientSum, i) = getindex(cs.coeffs, i)

setindex!(cs::CoefficientSum, c::Coefficient, i) = setindex!(cs.coeffs, c, i)

empty!(cs::CoefficientSum) = empty!(cs.coeffs)

push!(cs::CoefficientSum, cfs...) = push!(cs.coeffs, cfs...)

function show(io::IO, cs::CoefficientSum)
    #=
    Formatted printing.
    =#

    print(io, "(", cs[1])
    for c in cs[2:end]
        print(io, " + ", c)
    end
    print(io, ")")

end

# a zero element
zero(T::Type{CoefficientSum}) = CoefficientSum([zero(Coefficient)])

function zero!(cs::CoefficientSum)
    #=
    Set to canonical zero.
    =#

    empty!(cs)
    push!(cs, zero(Coefficient))

    nothing

end

function iszero!(cs::CoefficientSum)
    #=
    Is the coefficient sum a zero? Simplifies coefficient sum in the process.
    =#

    # first simplify in case coefficients cancel, then check if coefficient is zero
    simplify!(cs)
    all(iszero.(cs))

end

function simplify!(cs::CoefficientSum)
    #=
    Simplify the coefficeint sum.
    =#

    # put all coefficents into canonical form
    for c in cs
        canonicalize!(c)
    end

    # if coefficients can be added together, do so
    newcoeffs = _compresssum(cs)

    # find any zeros
    zs = iszero.(newcoeffs)

    if all(zs)
        # set to canonical zero
        zero!(cs)
    else
        # remove the zero coefficents
        deleteat!(newcoeffs, zs)

        # replace coefficients with simplified version
        cs.coeffs = newcoeffs
    end

    nothing

end

function *(cs1::CoefficientSum, cs2::CoefficientSum)
    #=
    Product of coefficient sums.
    =#

    newcoeffs = [c1*c2 for c1 in cs1, c2 in cs2 if true] # a 1d array
    newcs = CoefficientSum(newcoeffs)

    # simplify the result
    simplify!(newcs)

    newcs

end

function +(cs1::CoefficientSum, cs2::CoefficientSum)
    #=
    Add coefficient sums.
    =#

    newcs = CoefficientSum([cs1.coeffs; cs2.coeffs])

    # simplify the result
    simplify!(newcs)

    newcs

end
