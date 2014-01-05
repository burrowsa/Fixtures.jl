my_tests = ["test/fixture.jl",
            "test/registered_fixtures.jl",
            "test/fact_check_support.jl",
            "test/patch.jl",
            "test/mock.jl"]

println("Running tests:")
for my_test in my_tests
  include(my_test)
end
