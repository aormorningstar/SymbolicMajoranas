
import Base: *, isless, zero, iterate, eltype, size, length, getindex, setindex!, ==, +

# Global constants
const global PHASE_MOD = 4

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
