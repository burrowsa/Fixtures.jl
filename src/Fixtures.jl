module Fixtures
include("fixture.jl")
include("registered_fixtures.jl")
include("fact_check_support.jl")
include("matchers.jl")
include("file_fixtures.jl")
include("mock/mock.jl")
include("mock/patch.jl")

# If you only need to use Mocking feature, call `using Fixtures.Mocking`
module Mocking
include("mock/mock.jl")
include("mock/patch.jl")
end

end
