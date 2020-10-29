
mutable struct Term
    #=
    A symbolic term in a Majorana Hamiltonian.
    =#

    op::MajoranaProduct # the product of majorana operators
    coeff::CoefficientSum # the sum of coefficients in front of the operator

end

times!(t::Term, mnum::ExactNumber)::Nothing = times!(t.coeff, mnum)

zero(T::Type{Term})::Term = Term(MajoranaProduct(), zero(CoefficientSum))

function simplify!(t::Term)::Nothing
    #=
    Simplify the majorana product and coefficient sum.
    =#

    num = canonicalize!(t.op)
    times!(t.coeff, num)
    simplify!(t.coeff)

    nothing

end

function *(t1::Term, t2::Term)::Term
    #=
    Multiply two terms.
    =#

    newo, num = t1.op * t2.op # operator, sign from normal ordering
    newc = t1.coeff * t2.coeff
    times!(newc, num)
    newt = Term(newo, newc)

    newt

end

function commutator(t1::Term, t2::Term)::Term
    #=
    Commutator of terms.
    =#

    # do the operators commute?
    comm = commute(t1.op, t2.op)

    if comm # return a zero term
        newterm = zero(Term)
    else # terms anticommute
        newterm = t1 * t2
        times!(newterm, 2)
    end

    newterm

end

function addable(t1::Term, t2::Term)::Bool
    #=
    Can we add these two terms and get a single resultant term?
    =#

    t1.op == t2.op

end

function +(t1::Term, t2::Term)::Term
    #=
    Add t1 and t2. Only works when they are addable.
    =#

    @assert addable(t1, t2) "Cannot add terms."

    # add the coefficient sums
    Term(deepcopy(t1.op), t1.coeff + t2.coeff)

end
