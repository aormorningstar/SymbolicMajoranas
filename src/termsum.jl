
mutable struct TermSum <: AbstractVector{Term}
    #=
    Sum of terms. An operator that is a sum of Majorana products with coefficients can be
    represented by this type.
    =#

    terms::Vector{Term}

end

# interface with abstract array
size(ts::TermSum) = size(ts.terms)

getindex(ts::TermSum, i::Integer) = getindex(ts.terms, i)

setindex!(ts::TermSum, t::Term, i::Integer) = setindex!(ts.terms, t, i)

empty!(ts::TermSum) = empty!(ts.terms)

push!(ts::TermSum, tms...) = push!(ts.terms, tms...)

function zero!(ts::TermSum)
    #=
    Set to canonical zero.
    =#

    empty!(ts)
    push!(ts, zero(Term))

    nothing

end

function simplify!(ts::TermSum)
    #=
    Simplify the sum of terms.
    =#

    # put all terms into simplified form
    for t in ts
        simplify!(t)
    end

    # if coefficients can be added together, do so
    newterms = _compresssum(ts)

    # find the zeros
    zs = iszero!.(newterms)

    if all(zs)
        # set to canonical zero
        zero!(ts)
    else
        # remove the zero coefficents
        deleteat!(newterms, zs)

        # replace terms with simplified version
        ts.terms = newterms
    end

    nothing

end

function drop!(ts::TermSum, f::Function)
    #=
    Drop terms for which a function returns true.
    =#

    deleteat!(ts.terms, f.(ts))

    nothing

end

function *(ts1::TermSum, ts2::TermSum)
    #=
    Multiply two sums of terms.
    =#

    newterms = [t1 * t2 for t1 in ts1, t2 in ts2 if true] # a 1d array
    newts = TermSum(newterms)

    # simplify the result
    simplify!(newts)

    newts

end

function commutator(ts1::TermSum, ts2::TermSum)
    #=
    Commutator of term sums.
    =#

    newterms = [commutator(t1, t2) for t1 in ts1, t2 in ts2 if true] # a 1d array
    newtermsum = TermSum(newterms)

    # simplify the result
    simplify!(newtermsum)

    newtermsum

end

function +(ts1::TermSum, ts2::TermSum)
    #=
    Add term sums.
    =#

    newts = TermSum([ts1.terms; ts2.terms])

    # simplify the result
    simplify!(newts)

    newts

end
