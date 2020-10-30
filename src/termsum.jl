
mutable struct TermSum <: AbstractArray{Term, 1}
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

function simplify!(ts::TermSum)::Nothing
    #=
    Simplify the term sum.
    =#

    # put all majorana products into simplified form
    for t in ts
        simplify!(t)
    end

    # if terms can be added together, do so
    newterms = _compresssum(ts)

    # replace terms with simplified version
    ts.terms = newterms

    nothing

end

function times!(ts::TermSum, mnum::ExactNumber)::Nothing
    #=
    Multiply in place by a constant numerical factor.
    =#

    for t in ts
        times!(t, mnum)
    end

    nothing

end

function *(ts1::TermSum, ts2::TermSum)::TermSum
    #=
    Multiply two sums of terms.
    =#

    newterms = [t1 * t2 for t1 in ts1, t2 in ts2 if true] # a 1d array
    newts = TermSum(newterms)

    # simplify the result
    simplify!(newts)

    newts

end

function commutator(ts1::TermSum, ts2::TermSum)::TermSum
    #=
    Commutator of term sums.
    =#

    newterms = [commutator(t1, t2) for t1 in ts1, t2 in ts2 if true] # a 1d array
    newtermsum = TermSum(newterms)

    # simplify the result
    simplify!(newtermsum)

    newtermsum

end

function +(ts1::TermSum, ts2::TermSum)::TermSum
    #=
    Add term sums.
    =#

    newts = TermSum([ts1.terms; ts2.terms])

    # simplify the result
    simplify!(newts)

    newts

end
