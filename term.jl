
mutable struct Term
    #=
    A symbolic term in a Majorana Hamiltonian.
    =#

    op::MajoranaProduct # the product of majorana operators
    coeff::CoefficientSum # the sum of coefficients in front of the operator

end

function zero(T::Type{Term})::Term
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
    newcoeff = t1.coeff * t2.coeff
    addphase!(newcoeff, phase)
    newterm = Term(newop, newcoeff)

    newterm

end

multnum!(t::Term, mnum::Real)::Nothing = multnum!(t.coeff, mnum)

addphase!(t::Term, aphase::Integer)::Nothing = addphase!(t.coeff, aphase)

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
