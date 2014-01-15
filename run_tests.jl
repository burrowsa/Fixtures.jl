my_tests = ["test/registered_fixtures.jl",
            "test/fact_check_support.jl",
            "test/patch.jl",
            "test/mock.jl",
            "test/matchers.jl",
            "test/README.jl"]

println("Running tests:")
for my_test in my_tests
  include(my_test)
end
