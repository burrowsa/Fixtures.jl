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
      @fact length(Fixtures.fixtures[:somecontext])=>1
      @fact Fixtures.fixtures[:somecontext][1].name => nothing
      @fact Fixtures.fixtures[:somecontext][1].fn => anything_of_type(Function)
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
end

end