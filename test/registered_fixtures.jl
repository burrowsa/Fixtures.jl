module RegisteredFixturesTests

using Fixtures
using FactCheck


facts("Registered Fixtures tests") do
  context("test add_fixture adds to fixtures") do
    patch(Fixtures, :fixtures, Dict()) do
      function somefunction(fn::Function)
        fn()
      end

      @fact Fixtures.fixtures => Dict()
      add_fixture(:somecontext, somefunction)
      @fact length(Fixtures.fixtures)=>1
      @fact Fixtures.fixtures[:somecontext].name => nothing
      @fact Fixtures.fixtures[:somecontext].fn => anything_of_type(Function)
    end
  end

  context("test add_fixture with single fixture function") do
    patch(Fixtures, :fixtures, Dict()) do
      global x = 0

      function fixture_func(fn::Function)
        global x = 100
        try
          fn()
        finally
          global x = 200
        end
      end

      @fact Fixtures.fixtures => Dict()
      add_fixture(:somecontext, fixture_func)
      @fact x=>0
      apply_fixtures(:somecontext) do
        @fact x=>100
      end
      @fact x=>200
    end
  end

  context("test add_simple_fixture with separate setup and teardown functions") do
    patch(Fixtures, :fixtures, Dict()) do
      global x = 0

      function setup_func()
        global x = 100
      end

      function teardown_func()
        global x = 200
      end

      @fact Fixtures.fixtures => Dict()
      add_simple_fixture(:somecontext, setup_func, teardown_func)
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

      function fixture_func(fn::Function)
        global x = 100
        try
          fn()
        finally
          global x = 200
        end
      end

      apply_fixtures(:toplevel) do
        @fact Fixtures.fixtures => Dict()
        add_fixture(:somecontext, fixture_func)

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

  context("A 1-part-function fixture", using_fixtures) do
    global x = 0

    function changex(fn::Function)
      global x = 100
      fn()
    end

    add_fixture(:examplescope, changex)

    @fact x => 0
    apply_fixtures(:examplescope) do
      @fact x => 100
    end
    @fact x => 100
  end

  context("A 2-part-function fixture", using_fixtures) do
    global x = 0

    function changex(fn::Function)
      global x = 100
      try
        fn()
      finally
        global x = 200
      end
    end

    add_fixture(:examplescope, changex)

    @fact x => 0
    apply_fixtures(:examplescope) do
      @fact x => 100
    end
    @fact x => 200
  end

  context("combine two 2-part-function fixtures", using_fixtures) do
    global x = 0
    global y = 0

    function changex(fn::Function)
      global x = 100
      try
        fn()
      finally
        global x = 200
      end
    end

    function changey(fn::Function)
      global y = 100
      try
        fn()
      finally
        global y = 200
      end
    end

    add_fixture(:examplescope, changex)
    add_fixture(:examplescope, changey)

    @fact x => 0
    @fact y => 0
    apply_fixtures(:examplescope) do
      @fact x => 100
      @fact y => 100
    end
    @fact x => 200
    @fact y => 200
  end

  context("combine two 2-part-function fixtures check order", using_fixtures) do
    global x = ""

    function appenda(fn::Function)
      global x = x*"a"
      try
        fn()
      finally
        global x = x*"A"
      end
    end

    function appendb(fn::Function)
      global x = x*"b"
      try
        fn()
      finally
        global x = x*"B"
      end
    end

    add_fixture(:examplescope, appenda)
    add_fixture(:examplescope, appendb)

    @fact x => ""
    apply_fixtures(:examplescope) do
      @fact x => "ab"
    end
    @fact x => "abBA"
  end

  context("combine 1-part-function and 2-part-function fixtures", using_fixtures) do
    global x = 0
    global y = 0

    function changex(fn::Function)
      global x = 100
      fn()
    end

    function changey(fn::Function)
      global y = 100
      try
        fn()
      finally
        global y = 200
      end
    end

    add_fixture(:examplescope, changex)
    add_fixture(:examplescope, changey)

    @fact x => 0
    @fact y => 0
    apply_fixtures(:examplescope) do
      @fact x => 100
      @fact y => 100
    end
    @fact x => 100
    @fact y => 200
  end

  context("A fixture with no values", using_fixtures) do
    function nadda(fn::Function)
      fn()
    end

    add_fixture(:examplescope, :nowt, nadda)

    apply_fixtures(:examplescope, fixture_values=true) do values
      @fact collect(keys(values)) => [:nowt]
      @fact values[:nowt] => nothing
    end
  end

  context("A fixture with one value", using_fixtures) do
    function produce_n(fn::Function, n::Integer)
      fn(n)
    end

    add_fixture(:examplescope, :one_hundred, produce_n, 100)

    apply_fixtures(:examplescope, fixture_values=true) do values
      @fact collect(keys(values)) => [:one_hundred]
      @fact values[:one_hundred] => 100
    end
  end

  context("A fixture with one 0-tuple value", using_fixtures) do
    function produce_empty(fn::Function)
      fn(())
    end

    add_fixture(:examplescope, :empty, produce_empty)

    apply_fixtures(:examplescope, fixture_values=true) do values
      @fact collect(keys(values)) => [:empty]
      @fact values[:empty] => ()
    end
  end

  context("A fixture with one 1-tuple value", using_fixtures) do
    function produce_n(fn::Function, n::Integer)
      fn((n,))
    end

    add_fixture(:examplescope, :one_hundred, produce_n, 100)

    apply_fixtures(:examplescope, fixture_values=true) do values
      @fact collect(keys(values)) => [:one_hundred]
      @fact values[:one_hundred] => (100,)
    end
  end

  context("A fixture with one 2-tuple value", using_fixtures) do
    function produce_n(fn::Function, n::Any)
      fn(n)
    end

    add_fixture(:examplescope, :some_nums, produce_n, (100, 200))

    apply_fixtures(:examplescope, fixture_values=true) do values
      @fact collect(keys(values)) => [:some_nums]
      @fact values[:some_nums] => (100, 200)
    end
  end

  context("A fixture with two values", using_fixtures) do
    function produce_n_and_m(fn::Function, n::Integer, m::Integer)
      fn(n, m)
    end

    add_fixture(:examplescope, :some_nums, produce_n_and_m, 100, 200)

    apply_fixtures(:examplescope, fixture_values=true) do values
      @fact collect(keys(values)) => [:some_nums]
      @fact values[:some_nums] => (100, 200)
    end
  end

  context("A fixture with three values", using_fixtures) do
    function produce_n_m_and_o(fn::Function, n::Integer, m::Integer, o::Integer)
      fn(n, m, o)
    end

    add_fixture(:examplescope, :some_nums, produce_n_m_and_o, 100, 200, 300)

    apply_fixtures(:examplescope, fixture_values=true) do values
      @fact collect(keys(values)) => [:some_nums]
      @fact values[:some_nums] => (100, 200, 300)
    end
  end

  context("An anonymous fixture with one value", using_fixtures) do
    function produce_n(fn::Function, n::Integer)
      fn(n)
    end

    add_fixture(:examplescope, produce_n, 100)

    apply_fixtures(:examplescope, fixture_values=true) do values
      @fact collect(keys(values)) => []
    end
  end

  context("Two fixture with one value each", using_fixtures) do
    function produce_n(fn::Function, n::Integer)
      fn(n)
    end

    add_fixture(:examplescope, :peter, produce_n, 100)
    add_fixture(:examplescope, :paul, produce_n, 200)

    apply_fixtures(:examplescope, fixture_values=true) do values
      @fact sort(collect(keys(values))) => sort([:peter, :paul])
      @fact values[:peter] => 100
      @fact values[:paul] => 200
    end
  end
end

end