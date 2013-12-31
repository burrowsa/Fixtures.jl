using Fixtures
using FactCheck


facts("Registered Fixtures tests") do
  context("test add_fixture adds to fixtures") do
    patch(Fixtures, :fixtures, Dict()) do
      function somefunction()
      end

      @fact Fixtures.fixtures => Dict()
      add_fixture(somefunction, :somecontext)
      @fact Fixtures.fixtures => {:somecontext=>(somefunction,)}
    end
  end

  context("test apply_fixtures applies fixtures") do
    patch(Fixtures, :fixtures, Dict()) do
      global x = 0

      function somefunction()
        global x = 100
      end

      @fact Fixtures.fixtures => Dict()
      add_fixture(somefunction, :somecontext)
      @fact Fixtures.fixtures => {:somecontext=>(somefunction,)}
    end
  end

  context("test add_fixture with single fixture function") do
    patch(Fixtures, :fixtures, Dict()) do
      global x = 0

      function fixture_func()
        global x = 100
        produce()
        global x = 200
      end

      @fact Fixtures.fixtures => Dict()
      add_fixture(fixture_func, :somecontext)
      @fact x=>0
      apply_fixtures(:somecontext) do
        @fact x=>100
      end
      @fact x=>200
    end
  end

  context("test add_fixture with separate setup and teardown functions") do
    patch(Fixtures, :fixtures, Dict()) do
      global x = 0

      function setup_func()
        global x = 100
      end

      function teardown_func()
        global x = 200
      end

      @fact Fixtures.fixtures => Dict()
      add_fixture(setup_func, teardown_func, :somecontext)
      @fact x=>0
      apply_fixtures(:somecontext) do
        @fact x=>100
      end
      @fact x=>200
    end
  end

  context("Test that fixtures are scoped") do
    patch(Fixtures, :fixtures, Dict()) do
      global x = 0

      function fixture_func()
        global x = 100
        produce()
        global x = 200
      end

      apply_fixtures(:toplevel) do
        @fact Fixtures.fixtures => Dict()
        add_fixture(fixture_func, :somecontext)

        @fact Fixtures.fixtures => not(Dict())

        @fact x=>0
        apply_fixtures(:somecontext) do
          @fact x=>100
        end
        @fact x=>200
      end

      @fact Fixtures.fixtures => Dict()
    end
  end
end