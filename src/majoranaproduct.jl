
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

    ic = true

    for i in 1:length(op)-1

        if op.sites[i+1] <= op.sites[i]
            ic = false
            break
        end

    end

    ic

end

function canonicalize!(op::MajoranaProduct)::Integer
    #=
    Put product of Majorana operators into canonical form.
    =#

    num = 1 # will produce a factor of +1 or -1

    # normal order if not already true
    if !is_canonical(op)

        # bubble sort and keep track of minus signs from commuting majoranas
        l = length(op)

        for i in 1:l
            for j in 1:l-i

                if op.sites[j] > op.sites[j+1]
                    op.sites[j:1:j+1] = op.sites[j+1:-1:j] # swap sites
                    num *= -1 # majoranas anticommute
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

    num

end

function *(op1::MajoranaProduct, op2::MajoranaProduct)::Tuple{MajoranaProduct, Integer}
    #=
    Multiply two Majorana products.
    =#

    newsites = [op1.sites; op2.sites]
    newop = MajoranaProduct(newsites)

    # put the new result into canonical form
    num = canonicalize!(newop)

    newop, num

end

function commute(op1::MajoranaProduct, op2::MajoranaProduct)::Bool
    #=
    Do these products of Majorana operators commute?
    =#

    # note op12 must equal op21
    op12, num12 = op1 * op2
    op21, num21 = op2 * op1

    # they commute if there's no relative minus sign
    num12 == num21

end

function (==)(op1::MajoranaProduct, op2::MajoranaProduct)::Bool
    #=
    Are the operators equal?
    =#

    _equalarrays(op1.sites, op2.sites)

end
