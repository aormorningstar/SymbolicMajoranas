using Test
include("../src/SymbolicMajoranas.jl")

@testset "unit - BareCoefficient" begin

    bc1 = BareCoefficient(-3, 1)
    bc2 = BareCoefficient(2, 4)
    bc3 = BareCoefficient(2, 2)
    bc4 = BareCoefficient(2, 2)

    @test bc1 < bc2
    @test bc3 < bc2
    @test bc3 == bc4

end

@testset "unit - Coefficient" begin

    c1 = Coefficient(-2//5, [BareCoefficient(1,2), BareCoefficient(2,3)], [BareCoefficient(0,1)])
    times!(c1, -1//2)
    @test c1.num == 1//5

    c2 = Coefficient(-2//3, [BareCoefficient(2,3), BareCoefficient(1,2)], [BareCoefficient(0,1)])
    canonicalize!(c2)
    @test addable(c1, c2)
    c3 = c1 + c2
    @test c3.num == -7//15

    c4 = Coefficient(1im, [BareCoefficient(0,1)], [])
    c5 = c3 * c4
    @test c5.num == -7im//15
    @test isempty(c5.bot)
    @test !any(BareCoefficient(0,1) == c5.top)

    c6 = Coefficient(1, [BareCoefficient(0,0)], [BareCoefficient(0,0)])
    canonicalize!(c6)
    @test isempty(c6.top) && isempty(c6.bot)

end
