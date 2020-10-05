
# module SymbolicMajoranas

import Base: *, isless, zero, iterate, eltype, length, getindex

# export BareCoefficient, Coefficient, canonicalize!, CoefficientSum, simplify!, MajoranaProduct,
# is_normal_ordered, normal_order!, commute, Term, multnum!, addphase!, commutator

# Coefficients
include("barecoefficient.jl")
include("coefficient.jl")
include("coefficientSum.jl")

# Operators
include("majoranaproduct.jl")

# Terms have coefficients and operators
include("term.jl")

# end
