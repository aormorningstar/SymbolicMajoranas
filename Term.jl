include("MajoranaProduct.jl")
include("CoefficientSum.jl")
import Base: *, zero

mutable struct Term
    #=
    A symbolic term in a Majorana Hamiltonian.
    =#

    op::MajoranaProduct # the product of majorana operators
    coeffsum::Vector{CoefficientSum} # the sum of coefficients in front of the operator

end

function zero(T::Type{Term})
    #=
    A standard zero Term.
    =#

    Term(MajoranaProduct(), zero(CoefficientSum))

end

function *(t1::Term, t2::Term)::Term
    #=
    Multiply two terms.
    =#

    newop, phase = t1.op * t2.op # product automatically normal orders
    newcoeffsum = t1.coeffsum * t2.coeffsum
    phase_change!(newcoeffsum, phase)
    newterm = Term(newop, newcoeffsum)

    newterm

end

multnum!(t::Term, mnum::Real)::Nothing = multnum!(t.coeffsum, mnum)

addphase!(t::Term, aphase::Integer)::Nothing = addphase(t.coeffsum, aphase)

function commutator(t1::Term, t2::Term)::Term
    #=
    Commutator of terms.
    =#

    # do the operators commute?
    comm = commute(t1.op, t2.op)

    if comm # return a zero term
        newterm = zero(Term)
    else # terms anticommute
        newterm = t1*t2
        multnum!(newterm, 2)
    end

    newterm

end
