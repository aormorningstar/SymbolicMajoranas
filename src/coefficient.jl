
mutable struct Coefficient
    #=
    Symbolic coefficient of a term in the Majorana Hamiltonian.
    =#

    num::ExactNumber # numeric prefactor
    top::Vector{BareCoefficient} # bare coefficients in the numerator
    bot::Vector{BareCoefficient} # bare coefficients in the denominator

end

function show(io::IO, c::Coefficient)
    #=
    Formatted printing.
    =#

    num = simplify(c.num::ExactNumber)

    if imag(num) == 0
        print(io, real(num))
    elseif real(num) == 0
        print(io, imag(num), "i")
    else
        print(io, num)
    end

    print(io, " [")
    for bc in c.top[1:end-1]
        print(io, bc, " ")
    end
    print(io, c.top[end], "]")

    if !isempty(c.bot)
        print(io, "/[")
        for bc in c.bot[1:end-1]
            print(io, bc, " ")
        end
        print(io, c.bot[end], "]")
    end

end

function times!(c::Coefficient, mnum::ExactNumber)
    #=
    Multiply the numerical prefactor in place.
    =#

    c.num *= mnum

    nothing

end

function times!(c::Coefficient, bc::BareCoefficient)
    #=
    Multiply the numerical prefactor in place by a BareCoefficient.
    =#

    append!(c.top, bc)
    canonicalize!(c)

    nothing

end

function div!(c::Coefficient, bc::BareCoefficient)
    #=
    Divice the numerical prefactor in place by a BareCoefficient.
    =#

    append!(c.bot, bc)
    canonicalize!(c)

    nothing

end

zero(T::Type{Coefficient}) = Coefficient(zero(ExactNumber), BareCoefficient[], BareCoefficient[])

# Is the coefficient a zero?
iszero(c::Coefficient) = iszero(c.num)

function zero!(c::Coefficient)
    #=
    Set the coefficient to canonical zero.
    =#

    c.num = 0
    c.top = BareCoefficient[]
    c.bot = BareCoefficient[]

    nothing

end

function canonicalize!(c::Coefficient)
    #=
    Put the numerator and denominator into a canonical form.
    =#

    if iszero(c)
        # set to canonical zero
        zero!(c)
    else
        # sort numerator and denominator and cancel common factors
        sort!(c.top)
        sort!(c.bot)
        _cancelpairs!(c.top, c.bot)

        # store prefactor in simplest form
        c.num = simplify(c.num::ExactNumber)
    end

    nothing

end

function *(c1::Coefficient, c2::Coefficient)
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

function addable(c1::Coefficient, c2::Coefficient)
    #=
    Can we add these two coefficients and get a single resultant coefficient?
    =#

    # compare numerators and denominators
    t = _equalarrays(c1.top, c2.top)
    b = _equalarrays(c1.bot, c2.bot)

    t && b

end

function +(c1::Coefficient, c2::Coefficient)
    #=
    Add c1 and c2. Only works when they are addable.
    =#

    @assert addable(c1, c2) "Cannot add coefficients."

    # add the rational coefficients
    Coefficient(c1.num + c2.num, deepcopy(c1.top), deepcopy(c1.bot))

end
