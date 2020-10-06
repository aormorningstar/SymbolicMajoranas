
mutable struct Coefficient
    #=
    Symbolic coefficient of a term in the Majorana Hamiltonian.
    =#

    num::Real # positive numerical prefactor
    phase::Integer # a factor i^phase; phase is defined mod 4
    numerator::Vector{BareCoefficient} # bare coefficients in the numerator
    denominator::Vector{BareCoefficient} # bare coefficients in the denom

end

zero(T::Type{Coefficient})::Coefficient = Coefficient(0, 0, BareCoefficient[], BareCoefficient[])

function canonicalize!(c::Coefficient)::Nothing
    #=
    Put the numerator and denominator into a canonical form.
    =#

    @assert c.num >= 0 "Coefficient.num must be nonnegative"

    phasemod = 4
    c.phase %= phasemod
    sort!(c.numerator)
    sort!(c.denominator)

    # if common factors in numerator and denominator, allow them to cancel out
    keep_n = trues(length(c.numerator))
    keep_d = trues(length(c.denominator))

    for (i, bci) in enumerate(c.numerator), (j, bcj) in enumerate(c.denominator)

        if bci == bcj && keep_n[i] && keep_d[j] # cancel if not already
            keep_n[i] = false
            keep_d[j] = false
        end

    end

    c.numerator = c.numerator[keep_n]
    c.denominator = c.denominator[keep_d]

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
