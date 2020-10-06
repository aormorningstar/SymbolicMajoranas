
# module SymbolicMajoranas

import Base: *, isless, zero, iterate, eltype, length, getindex, ==, +

# export BareCoefficient, Coefficient, canonicalize!, CoefficientSum, simplify!, MajoranaProduct,
# is_canonical, commute, Term, multnum!, addphase!, commutator

# Coefficients
include("barecoefficient.jl")
include("coefficient.jl")
include("coefficientsum.jl")

# Operators
include("majoranaproduct.jl")

# Terms
include("term.jl")
include("termsum.jl")

# end
