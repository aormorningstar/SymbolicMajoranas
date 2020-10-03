include("BareCoefficient.jl")

struct Coefficient
    #=
    Symbolic coefficient of a term in the Majorana Hamiltonian.
    =#

    phase::Integer # a factor i^phase; phase is defined mod 4
    numerator::Vector{BareCoefficient} # bare coefficients in the numerator
    denominator::Vector{BareCoefficient} # bare coefficients in the denom

end
