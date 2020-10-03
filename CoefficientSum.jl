include("Coefficient.jl")

struct CoefficientSum
    #=
    Symbolic sum of symbolic coefficients paired with the same operator in a Majorana Hamiltonian.
    =#

    coeffs::Vector{Coefficient}

end
