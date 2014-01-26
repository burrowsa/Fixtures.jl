my_tests = ["test/meta.jl",
            "test/fixture.jl",
            "test/registered_fixtures.jl",
            "test/fact_check_support.jl",
            "test/file_fixtures.jl",
            "test/patch.jl",
            "test/mock.jl",
            "test/matchers.jl",
            "test/README.jl"]

println("Running tests:")
for my_test in my_tests
  include(my_test)
end
