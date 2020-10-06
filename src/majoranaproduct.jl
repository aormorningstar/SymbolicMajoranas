
mutable struct MajoranaProduct
    #=
    Product of Majorana operators.
    =#

    sites::Vector{Integer} # Majorana operators on these sites

end

function MajoranaProduct()::MajoranaProduct
    #=
    Construct an empty product (the identity).
    =#

    sites = Int64[]

    MajoranaProduct(sites)

end

function is_canonical(op::MajoranaProduct)::Bool
    #=
    Check if term is in canonical form.
    =#

    no = true

    for i in 1:length(op)-1

        if op.sites[i+1] <= op.sites[i]
            no = false
        end

    end

    no

end

function canonicalize!(op::MajoranaProduct)::Integer
    #=
    Put product of Majorana operators into canonical form.
    =#

    phase = 0 # coefficent i^phase

    # normal order if not already true
    if !is_canonical(op)

        # bubble sort and keep track of minus signs from commuting majoranas
        l = length(op)

        for i in 1:l
            for j in 1:l-i

                if op.sites[j] > op.sites[j+1]
                    op.sites[j:1:j+1] = op.sites[j+1:-1:j] # swap sites
                    phase += 2 # majoranas anticommute (i^2 = -1)
                end

            end
        end

        # pair annihilate repeated sites (majoranas square to 1)
        keep = trues(l)

        i = 1
        while i < l

            if op.sites[i] == op.sites[i+1]
                keep[i:i+1] .= false
                i += 2
            else
                i += 1
            end

        end

        op.sites = op.sites[keep]

    end

    phase

end

function *(op1::MajoranaProduct, op2::MajoranaProduct)::Tuple{MajoranaProduct, Integer}
    #=
    Multiply two Majorana products.
    =#

    newsites = vcat(op1.sites, op2.sites)
    newop = MajoranaProduct(newsites)

    # put the new result into canonical form
    phase = canonicalize!(newop)

    newop, phase

end

function commute(op1::MajoranaProduct, op2::MajoranaProduct)::Bool
    #=
    Do these products of Majorana operators commute?
    =#

    # note op12 must equal op21
    op12, phase12 = op1*op2
    op21, phase21 = op2*op1

    comm = false # default they don't commute

    phasemod = 4
    if phase12%phasemod == phase21%phasemod # then they do commute
        comm = true
    end

    comm

end
