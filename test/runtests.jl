using Test
include("../src/SymbolicMajoranas.jl")

@testset "BareCoefficient" begin

    # for convenience
    BC = BareCoefficient

    # check order defined on bare coefficients
    @test BC(-3, 1) < BC(2, 4)
    @test BC(2, 2) < BC(2, 4)
    @test BC(2, 2) == BC(2, 2)

end

@testset "Coefficient" begin

    # for convenience
    BC = BareCoefficient
    C = Coefficient

    # check in place multiplication by a numerical factor
    @test begin

        c = C(-2//5, [BC(1, 2), BC(2, 3)], [BC(0, 1)])
        times!(c, -1//2)
        c.num == 1//5

    end

    # check zeroing a coefficent works as intended
    @test begin

        c = C(-2//5, [BC(1, 2), BC(2, 3)], [BC(0, 1)])
        zero!(c)
        c.num == 0 && isempty(c.top) && isempty(c.bot)

    end

    # check canonicalization and addition of coefficients
    @test begin

        c1 = C(1, [BC(1, 2), BC(2, 3), BC(4, 5)], [BC(4, 5), BC(0, 1)])
        c2 = C(2, [BC(2, 3), BC(1, 2)], [BC(0, 1)])
        canonicalize!(c1)
        canonicalize!(c2)
        addable(c1, c2)
        c3 = c1 + c2
        c3.num == 3

    end

end

@testset "CoefficientSum" begin

    # for convenience
    BC = BareCoefficient
    C = Coefficient
    CS = CoefficientSum

    # check the simplify! method
    @test begin

        cs = CS([
            C(1, [BC(1, 2), BC(2, 3)], [BC(0, 1)]),
            C(2, [BC(1, 2), BC(2, 3)], [BC(0, 1)]),
            C(3, [BC(3, 4)], []),
            C(4, [BC(3, 4), BC(0, 0)], [BC(0, 0)]),
            zero(C),
        ])

        simplify!(cs)
        size(cs) == (2,) && cs[1].num == 3 && cs[2].num == 7

    end

    # check in place multiplication by a scalar
    @test begin

        cs = CS([
            C(1, [BC(1, 2), BC(2, 3)], [BC(0, 1)]),
            C(4, [BC(3, 4), BC(0, 0)], [BC(0, 0)]),
        ])

        times!.(cs, -1im)
        cs[1].num == -1im && cs[2].num == -4im

    end

end

@testset "MajoranaProduct" begin

    # for convenience
    MP = MajoranaProduct

    # test canonicalization
    @test begin

        mp = MP([3, 1, 2, 1])
        ic1 = iscanonical(mp)
        n = canonicalize!(mp)
        ic2 = iscanonical(mp)

        !ic1 && n == 1 && ic2 && length(mp) == 2

    end

    # test * and ==
    @test begin

        mp1 = MP([1, 2, 3, 4])
        mp2 = MP([3, 1])
        mp3, n = mp1 * mp2
        mp3 == MP([2, 4]) && n == -1

    end

    # test commute
    @test commute(MP([1, 2]), MP([2, 4])) == false
    @test commute(MP([1, 2]), MP([3, 4])) == true


end

@testset "Term" begin

    # for convenience
    BC = BareCoefficient
    C = Coefficient
    CS = CoefficientSum
    MP = MajoranaProduct
    T = Term

    # TODO add tests here

end

@testset "TermSum" begin

    # for convenience
    BC = BareCoefficient
    C = Coefficient
    CS = CoefficientSum
    MP = MajoranaProduct
    T = Term
    TS = TermSum

    # TODO add tests here

end
