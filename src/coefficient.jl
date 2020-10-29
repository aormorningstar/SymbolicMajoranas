
mutable struct Coefficient
    #=
    Symbolic coefficient of a term in the Majorana Hamiltonian.
    =#

    num::Rational{Integer} # rational prefactor
    phase::Integer # a factor i^phase; phase is defined mod 4
    numerator::Vector{BareCoefficient} # bare coefficients in the numerator
    denominator::Vector{BareCoefficient} # bare coefficients in the denom

end

function multnum!(c::Coefficient, mnum::Union{Rational{Integer}, Integer})::Nothing
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

    c.phase = (c.phase + aphase) % PHASE_MOD

    nothing

end

zero(T::Type{Coefficient})::Coefficient = Coefficient(zero(Rational{Integer}), 0,
BareCoefficient[], BareCoefficient[])

function canonicalize!(c::Coefficient)::Nothing
    #=
    Put the numerator and denominator into a canonical form.
    =#

    @assert c.num >= 0 "Coefficient.num must be nonnegative"

    c.phase %= PHASE_MOD
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

# function addable(c1::Coefficient, c2::Coefficient)::Bool
#     #=
#     Can we add these two coefficients and get a single resultant coefficient?
#     =#
#
#     # compare phases, numerators, and denominators
#     phase = c1.phase == c2.phase
#     numer = _equalarrays(c1.numerator, c2.numerator)
#     denom = _equalarrays(c1.denominator, c2.denominator)
#
#     phase & numer & denom
#
# end
#
# function +(c1::Coefficient, c2::Coefficient)::Coefficient
#     #=
#     Add coefficients. Only works when they are addable.
#     =#
#
#     @assert addable(c1, c2) "Cannot add coefficients."
#
#     # add the rational coefficients
#     Coefficient(c1.num + c2.num, c1.phase, c1.numerator, c1.denominator)
#
# end
