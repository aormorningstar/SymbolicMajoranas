
struct BareCoefficient
    #=
    Symbolic representation of a coefficent in the bare Majorana Hamiltonian.
    =#

    site::Integer # the site of the corresponding bare operator
    type::Integer # the type of the corresponding bare operator

end

function isless(bc1::BareCoefficient, bc2::BareCoefficient)::Bool
    #=
    Compare two bare coefficients.
    =#

    bc1.site < bc2.site || (bc1.site == bc2.site && bc1.type < bc2.type)

end
