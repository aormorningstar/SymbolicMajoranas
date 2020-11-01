
struct BareCoefficient{T<:Integer}
    #=
    Symbolic representation of a coefficent in the bare Majorana Hamiltonian.
    =#

    site::T # the site of the corresponding bare operator
    type::String # the type of the corresponding bare operator

end

# Formatted printing
show(io::IO, bc::BareCoefficient) = print(io, bc.type, "_{", bc.site, "}")

# Needed for broadcasting mutliplication by bare coefficients
length(bc::BareCoefficient) = 1
iterate(bc::BareCoefficient) = (bc, 1)
iterate(bc::BareCoefficient, state::Int) = nothing


function isless(bc1::BareCoefficient, bc2::BareCoefficient)
    #=
    Are two bare coefficients ordered?
    =#

    # sort by site first, then by type
    bc1.site < bc2.site || (bc1.site == bc2.site && bc1.type < bc2.type)

end

function (==)(bc1::BareCoefficient, bc2::BareCoefficient)
    #=
    Do two bare coefficients represent the same value?
    =#

    # site and type must both match
    bc1.site == bc2.site && bc1.type == bc2.type

end
