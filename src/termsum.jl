
mutable struct TermSum <: AbstractArray{Term, 1}
    #=
    Sum of terms. An operator that is a sum of Majorana products with coefficients can be
    represented by this type.
    =#

    terms::Vector{Term}

end

# interface with abstract array
size(ts::TermSum)::Tuple{Integer} = size(ts.terms)

getindex(ts::TermSum, i::Vararg{Integer})::Term = getindex(ts.terms, i)

setindex!(ts::TermSum, t::Term, i::Vararg{Integer})::TermSum = setindex!(ts.terms, t, i)

function simplify!(ts::TermSum)::Nothing
    #=
    Simplify the term sum.
    =#

    #=
    NOTE
    Need to complete this code.
    =#

    # put all majorana products into canonical form
    for t in ts
        canonicalize!(t)
    end

    # collect terms with common majorana products; add those coefficient sums up


    # simplify all the coefficient sums
    for t in ts
        simplify!(t.coeff)
    end

    nothing

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
