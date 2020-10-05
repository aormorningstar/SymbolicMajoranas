import Base: *, length

mutable struct MajoranaProduct
    #=
    Product of Majorana operators.
    =#

    sites::Vector{Integer} # Majorana operators on these sites

end

function MajoranaProduct()
    #=
    Construct an empty product (the identity).
    =#

    sites = Int64[]

    MajoranaProduct(sites)

end

function length(op::MajoranaProduct)::Integer
    #=
    Number of Majorana operators in a product.
    =#

    length(op.sites)

end

function is_normal_ordered(op::MajoranaProduct)::Bool
    #=
    Check if term is normal ordered.
    =#

    no = true

    for i in 1:length(op)-1

        if op.sites[i+1] <= op.sites[i]
            no = false
        end

    end

    no

end

function normal_order!(op::MajoranaProduct)::Integer
    #=
    Normal order a product of Majorana operators.
    =#

    phase = 0 # coefficent i^phase

    # normal order if not already true
    if !is_normal_ordered(op)

        # bubble sort and keep track of minus signs from commuting majoranas
        l = length(op)

        for i in 1:l
            for j in 1:l-i

                if op.sites[j] > op.sites[j+1]
                    op.sites[j:1:j+1] = op.sites[j:-1:j+1] # swap sites
                    phase += 2 # majoranas anticommute (i^2 = -1)
                end

            end
        end

    end

    phase

end

function *(op1::MajoranaProduct, op2::MajoranaProduct)::Tuple{MajoranaProduct, Integer}
    #=
    Multiply two Majorana products.
    =#

    newsites = vcat(op1.sites, op2.sites)
    newop = MajoranaProduct(newsites)

    # normal order the new result
    phase = normal_order!(newop)

    newop, phase

end

function commute(op1::MajoranaProduct, op2::MajoranaProduct)::Bool
    #=
    Do these products of Majorana operators commute?
    =#

    # note op12 must equal op21
    op12, phase12 = op1*op2
    op21, phase21 = op2*op1

    comm = false # default, they don't commute
    phasemod = 4
    if phase12%phasemod == phase21%phasemod # then they do commute
        comm = true
    end

    comm

end
