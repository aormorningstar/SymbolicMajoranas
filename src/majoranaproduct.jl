
mutable struct MajoranaProduct{T<:Integer}
    #=
    Product of Majorana operators.
    =#

    sites::Vector{T} # Majorana operators on these sites

end

function MajoranaProduct()
    #=
    Construct an empty product (the identity).
    =#

    sites = Int64[]

    MajoranaProduct(sites)

end

function show(io::IO, mp::MajoranaProduct)
    #=
    Formatted printing.
    =#

    if isempty(mp.sites)
        print(io, "I")
    else
        for s in mp.sites
            print(io, "X{", s, "}")
        end
    end

end

length(op::MajoranaProduct) = length(op.sites)

# Is the operator a constant (propto identity)?
isconst(op::MajoranaProduct) = isempty(op.sites)

function iscanonical(op::MajoranaProduct)
    #=
    Check if term is in canonical form.
    =#

    ic = true # in canonical form

    for i in 1:length(op)-1

        if op.sites[i+1] <= op.sites[i] # out of canonical form
            ic = false
            break
        end

    end

    ic

end

function canonicalize!(op::MajoranaProduct)
    #=
    Put product of Majorana operators into canonical form.
    =#

    num = 1 # will produce a factor of +1 or -1 from anticommuting Majorana oparators

    # normal order if not already true
    if !iscanonical(op)

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

function *(op1::MajoranaProduct, op2::MajoranaProduct)
    #=
    Multiply two Majorana products.
    =#

    newsites = [op1.sites; op2.sites]
    newop = MajoranaProduct(newsites)

    # put the new result into canonical form
    num = canonicalize!(newop)

    newop, num

end

function commute(op1::MajoranaProduct, op2::MajoranaProduct)
    #=
    Do these products of Majorana operators commute?
    =#

    # note op12 will equal op21
    op12, num12 = op1 * op2
    op21, num21 = op2 * op1

    # they commute if there's no relative minus sign
    num12 == num21

end

function (==)(op1::MajoranaProduct, op2::MajoranaProduct)
    #=
    Are the operators equal?
    =#

    _equalarrays(op1.sites, op2.sites)

end
