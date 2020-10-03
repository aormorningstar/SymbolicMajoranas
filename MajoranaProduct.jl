
mutable struct MajoranaProduct
    #=
    Product of Majorana operators.
    =#

    sites::Vector{Integer} # Majorana operators on these sites

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

    phase % 4 # phase defined mod 4 because i^4 = 1

end
