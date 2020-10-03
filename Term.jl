include("MajoranaProduct.jl")
include("CoefficientSum.jl")

struct Term
    #=
    A symbolic term in a Majorana Hamiltonian.
    =#

    op::MajoranaProduct # the product of majorana operators
    coeffsum::Vector{CoefficientSum} # the sum of coefficients in front of the operator

end
