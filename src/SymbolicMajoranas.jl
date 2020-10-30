
import Base: *, isless, zero, iszero, iterate, eltype, size, length, getindex, setindex!, ==, +

# Helper functions
include("utils.jl")

# Coefficients
include("barecoefficient.jl")
include("coefficient.jl")
include("coefficientsum.jl")

# Operators
include("majoranaproduct.jl")

# Terms
include("term.jl")
include("termsum.jl")
