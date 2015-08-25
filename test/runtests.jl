using FactCheck

include("mock/mock.jl")
include("mock/patch.jl")
include("registered_fixtures.jl")
include("fact_check_support.jl")
include("file_fixtures.jl")
include("fixture.jl")
include("matchers.jl")

# Throws errors when a @fact failed a test.
exitstatus()