
mutable struct Coefficient
    #=
    Symbolic coefficient of a term in the Majorana Hamiltonian.
    =#

    num::Real # positive numerical prefactor
    phase::Integer # a factor i^phase; phase is defined mod 4
    numerator::Vector{BareCoefficient} # bare coefficients in the numerator
    denominator::Vector{BareCoefficient} # bare coefficients in the denom

end

function zero(T::Type{Coefficient})::Coefficient
    #=
    A standard zero coefficient.
    =#

    Coefficient(0, 0, BareCoefficient[], BareCoefficient[])

end

function canonicalize!(c::Coefficient)::Nothing
    #=
    Put the numerator and denominator into a canonical order.
    =#

    c.phase %= 4
    sort!(c.numerator)
    sort!(c.denominator)

    @assert c.num >= 0 "Coefficient.num must be nonnegative"

    nothing

end

function *(c1::Coefficient, c2::Coefficient)::Coefficient
    #=
    Product of symbolic coefficients.
    =#

    newnum = c1.num * c2.num
    newphase = c1.phase + c2.phase
    newnumerator = vcat(c1.numerator, c2.numerator)
    newdenominator = vcat(c1.denominator, c2.denominator)
    newcoeff = Coefficient(newnum, newphase, newnumerator, newdenominator)

    # put new coefficient into canonical form
    canonicalize!(newcoeff)

    newcoeff

end

function multnum!(c::Coefficient, mnum::Real)::Nothing
    #=
    Multiply the numerical prefactor.
    =#

    c.num *= mnum

    nothing

end

function addphase!(c::Coefficient, aphase::Integer)::Nothing
    #=
    Add to the phase of the coefficient.
    =#

    phasemod = 4
    c.phase = (c.phase + aphase)%phasemod

    nothing

end
