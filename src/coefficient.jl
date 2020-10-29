
mutable struct Coefficient
    #=
    Symbolic coefficient of a term in the Majorana Hamiltonian.
    =#

    num::ExactType # numeric prefactor
    top::Vector{BareCoefficient} # bare coefficients in the numerator
    bot::Vector{BareCoefficient} # bare coefficients in the denominator

end

function times!(c::Coefficient, mnum::ExactType)::Nothing
    #=
    Multiply the numerical prefactor in place.
    =#

    c.num *= mnum

    nothing

end

zero(T::Type{Coefficient})::Coefficient = Coefficient(zero(ExactType), BareCoefficient[],
BareCoefficient[])

function canonicalize!(c::Coefficient)::Nothing
    #=
    Put the numerator and denominator into a canonical form.
    =#

    sort!(c.top)
    sort!(c.bot)

    # if common factors in numerator and denominator, allow them to cancel out
    keep_t = trues(length(c.top))
    keep_b = trues(length(c.bot))

    for (i, bci) in enumerate(c.top), (j, bcj) in enumerate(c.bot)

        if bci == bcj && keep_t[i] && keep_b[j] # cancel if not already
            keep_t[i] = false
            keep_b[j] = false
        end

    end

    c.top = c.top[keep_t]
    c.bot = c.bot[keep_b]

    nothing

end

function *(c1::Coefficient, c2::Coefficient)::Coefficient
    #=
    Product of symbolic coefficients.
    =#

    newnum = c1.num * c2.num
    newtop = [c1.top; c2.top]
    newbot = [c1.bot; c2.bot]
    newc = Coefficient(newnum, newtop, newbot)

    # put new coefficient into canonical form
    canonicalize!(newc)

    newc

end

function addable(c1::Coefficient, c2::Coefficient)::Bool
    #=
    Can we add these two coefficients and get a single resultant coefficient?
    =#

    # compare numerators and denominators
    t = _equalarrays(c1.top, c2.top)
    b = _equalarrays(c1.bot, c2.bot)

    t & b

end

function +(c1::Coefficient, c2::Coefficient)::Coefficient
    #=
    Add c1 and c2. Only works when they are addable.
    =#

    @assert addable(c1, c2) "Cannot add coefficients."

    # add the rational coefficients
    Coefficient(c1.num + c2.num, deepcopy(c1.top), deepcopy(c1.bottom))

end
