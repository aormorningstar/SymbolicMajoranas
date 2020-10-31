
mutable struct Term
    #=
    A symbolic term in a Majorana Hamiltonian.
    =#

    op::MajoranaProduct # the product of majorana operators
    coeff::CoefficientSum # the sum of coefficients in front of the operator

end

times!(t::Term, mnum::ExactNumber) = times!.(t.coeff, mnum)

zero(T::Type{Term})::Term = Term(MajoranaProduct(), zero(CoefficientSum))

# Is the term equivalent to a zero? Simplifies coeff in the process.
iszero!(t::Term) = iszero!(t.coeff)

function zero!(t::Term)
    #=
    Set the term to canonical zero.
    =#

    t.op = MajoranaProduct()
    t.coeff = zero(CoefficientSum)

    nothing

end

# Is the term a constant (propto identity)?
isconst(t::Term) = isconst(t.op)

function simplify!(t::Term)
    #=
    Simplify the majorana product and coefficient sum.
    =#

    if iszero!(t) # calling this simplifies the coefficient
        # set to canonical zero
        zero!(t)
    else
        num = canonicalize!(t.op)
        times!.(t.coeff, num)
    end

    nothing

end

function *(t1::Term, t2::Term)
    #=
    Multiply two terms.
    =#

    newo, num = t1.op * t2.op # operator, sign from normal ordering
    newc = t1.coeff * t2.coeff
    times!.(newc, num)
    newt = Term(newo, newc)

    newt

end

function commutator(t1::Term, t2::Term)
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

function addable(t1::Term, t2::Term)
    #=
    Can we add these two terms and get a single resultant term?
    =#

    t1.op == t2.op

end

function +(t1::Term, t2::Term)
    #=
    Add t1 and t2. Only works when they are addable.
    =#

    @assert addable(t1, t2) "Cannot add terms."

    # add the coefficient sums
    Term(deepcopy(t1.op), t1.coeff + t2.coeff)

end
