module FixtureMacroTests

using Fixtures
using FactCheck

@fixture shorthand_beginend0a() = global state = "shorthand_beginend0a"
@fixture shorthand_beginend0b() = begin
  global state = "shorthand_beginend0b"
end
@fixture shorthand_beginend0c() = begin
  global state = "shorthand_beginend0c"
  yield_fixture()
end
@fixture shorthand_beginend0d() = begin
  global state = "shorthand_beginend0d"
  yield_fixture()
  global state = ""
end
@fixture (shorthand_beginend0e)() = begin
  global state = "shorthand_beginend0e"
  yield_fixture()
  global state = ""
end


@fixture shorthand_beginend1a(x) = global state = "shorthand_beginend1a_$x"
@fixture shorthand_beginend1b(x) = begin
  global state = "shorthand_beginend1b_$x"
end
@fixture shorthand_beginend1c(x) = begin
  global state = "shorthand_beginend1c_$x"
  yield_fixture()
end
@fixture shorthand_beginend1d(x) = begin
  global state = "shorthand_beginend1d_$x"
  yield_fixture()
  global state = ""
end
@fixture shorthand_beginend1e(x::Integer) = begin
  global state = "shorthand_beginend1e_$x"
  yield_fixture()
  global state = ""
end
@fixture shorthand_beginend1f{T}(x::T) = begin
  global state = "shorthand_beginend1f_$x"
  yield_fixture()
  global state = ""
end


@fixture shorthand_beginend2a(x, y) = global state = "shorthand_beginend2a_$(x)_$(y)"
@fixture shorthand_beginend2b(x, y) = begin
  global state = "shorthand_beginend2b_$(x)_$(y)"
end
@fixture shorthand_beginend2c(x, y) = begin
  global state = "shorthand_beginend2c_$(x)_$(y)"
  yield_fixture()
end
@fixture shorthand_beginend2d(x, y) = begin
  global state = "shorthand_beginend2d_$(x)_$(y)"
  yield_fixture()
  global state = ""
end
@fixture shorthand_beginend2e(x::Integer, y::Integer) = begin
  global state = "shorthand_beginend2e_$(x)_$(y)"
  yield_fixture()
  global state = ""
end
@fixture shorthand_beginend2f{T1, T2}(x::T1, y::T2) = begin
  global state = "shorthand_beginend2f_$(x)_$(y)"
  yield_fixture()
  global state = ""
end


@fixture shorthand_brackets0a() = global state = "shorthand_brackets0a"
@fixture shorthand_brackets0b() = (
  global state = "shorthand_brackets0b";
)
@fixture shorthand_brackets0c() = (
  global state = "shorthand_brackets0c";
  yield_fixture()
)
@fixture shorthand_brackets0d() = (
  global state = "shorthand_brackets0d";
  yield_fixture();
  global state = ""
)


@fixture shorthand_brackets1a(x) = global state = "shorthand_brackets1a_$x"
@fixture shorthand_brackets1b(x) = (
  global state = "shorthand_brackets1b_$x";
)
@fixture shorthand_brackets1c(x) = (
  global state = "shorthand_brackets1c_$x";
  yield_fixture()
)
@fixture shorthand_brackets1d(x) = (
  global state = "shorthand_brackets1d_$x";
  yield_fixture();
  global state = ""
)
@fixture shorthand_brackets1e(x::Integer) = (
  global state = "shorthand_brackets1e_$x";
  yield_fixture();
  global state = ""
)


@fixture shorthand_brackets2a(x, y) = global state = "shorthand_brackets2a_$(x)_$(y)"
@fixture shorthand_brackets2b(x, y) = (
  global state = "shorthand_brackets2b_$(x)_$(y)";
)
@fixture shorthand_brackets2c(x, y) = (
  global state = "shorthand_brackets2c_$(x)_$(y)";
  yield_fixture()
)
@fixture shorthand_brackets2d(x, y) = (
  global state = "shorthand_brackets2d_$(x)_$(y)";
  yield_fixture();
  global state = ""
)
@fixture shorthand_brackets2e(x::Integer, y::Integer) = (
  global state = "shorthand_brackets2e_$(x)_$(y)";
  yield_fixture();
  global state = ""
)


function0a = @fixture function()
  global state = "function0a"
end
function0b = @fixture function()
  global state = "function0b"
  yield_fixture()
end
function0c = @fixture function()
  global state = "function0c"
  yield_fixture()
  global state = ""
end


function1a = @fixture function(x)
  global state = "function1a_$x"
end
function1b = @fixture function(x)
  global state = "function1b_$x"
  yield_fixture()
end
function1c = @fixture function(x)
  global state = "function1c_$x"
  yield_fixture()
  global state = ""
end
function1d = @fixture function(x::Integer)
  global state = "function1d_$x"
  yield_fixture()
  global state = ""
end


function2a = @fixture function(x, y)
  global state = "function2a_$(x)_$(y)"
end
function2b = @fixture function(x, y)
  global state = "function2b_$(x)_$(y)"
  yield_fixture()
end
function2c = @fixture function(x, y)
  global state = "function2c_$(x)_$(y)"
  yield_fixture()
  global state = ""
end
function2d = @fixture function(x::Integer, y::Integer)
  global state = "function2d_$(x)_$(y)"
  yield_fixture()
  global state = ""
end


@fixture function method0a()
  global state = "method0a"
end
@fixture function method0b()
  global state = "method0b"
  yield_fixture()
end
@fixture function method0c()
  global state = "method0c"
  yield_fixture()
  global state = ""
end
@fixture function (method0d)()
  global state = "method0d"
  yield_fixture()
  global state = ""
end


@fixture function method1a(x)
  global state = "method1a_$x"
end
@fixture function method1b(x)
  global state = "method1b_$x"
  yield_fixture()
end
@fixture function method1c(x)
  global state = "method1c_$x"
  yield_fixture()
  global state = ""
end
@fixture function method1d(x::Integer)
  global state = "method1d_$x"
  yield_fixture()
  global state = ""
end
@fixture function method1e{T}(x::T)
  global state = "method1e_$x"
  yield_fixture()
  global state = ""
end


@fixture function method2a(x, y)
  global state = "method2a_$(x)_$(y)"
end
@fixture function method2b(x, y)
  global state = "method2b_$(x)_$(y)"
  yield_fixture()
end
@fixture function method2c(x, y)
  global state = "method2c_$(x)_$(y)"
  yield_fixture()
  global state = ""
end
@fixture function method2d(x::Integer, y::Integer)
  global state = "method2d_$(x)_$(y)"
  yield_fixture()
  global state = ""
end
@fixture function method2e{T1, T2}(x::T1, y::T2)
  global state = "method2e_$(x)_$(y)"
  yield_fixture()
  global state = ""
end


lambda_beginend0a = @fixture () -> global state = "lambda_beginend0a"
lambda_beginend0b = @fixture () -> begin
  global state = "lambda_beginend0b"
end
lambda_beginend0c = @fixture () -> begin
  global state = "lambda_beginend0c"
  yield_fixture()
end
lambda_beginend0d = @fixture () -> begin
  global state = "lambda_beginend0d"
  yield_fixture()
  global state = ""
end


lambda_beginend1a = @fixture (x) -> global state = "lambda_beginend1a_$x"
lambda_beginend1b = @fixture (x) -> begin
  global state = "lambda_beginend1b_$x"
end
lambda_beginend1c = @fixture (x) -> begin
  global state = "lambda_beginend1c_$x"
  yield_fixture()
end
lambda_beginend1d = @fixture (x) -> begin
  global state = "lambda_beginend1d_$x"
  yield_fixture()
  global state = ""
end
lambda_beginend1e = @fixture (x::Integer) -> begin
  global state = "lambda_beginend1e_$x"
  yield_fixture()
  global state = ""
end


lambda_beginend2a = @fixture (x, y) -> global state = "lambda_beginend2a_$(x)_$(y)"
lambda_beginend2b = @fixture (x, y) -> begin
  global state = "lambda_beginend2b_$(x)_$(y)"
end
lambda_beginend2c = @fixture (x, y) -> begin
  global state = "lambda_beginend2c_$(x)_$(y)"
  yield_fixture()
end
lambda_beginend2d = @fixture (x, y) -> begin
  global state = "lambda_beginend2d_$(x)_$(y)"
  yield_fixture()
  global state = ""
end
lambda_beginend2e = @fixture (x::Integer, y::Integer) -> begin
  global state = "lambda_beginend2e_$(x)_$(y)"
  yield_fixture()
  global state = ""
end


lambda_brackets0a = @fixture () -> global state = "lambda_brackets0a"
lambda_brackets0b = @fixture () -> (
  global state = "lambda_brackets0b";
)
lambda_brackets0c = @fixture () -> (
  global state = "lambda_brackets0c";
  yield_fixture()
)
lambda_brackets0d = @fixture () -> (
  global state = "lambda_brackets0d";
  yield_fixture();
  global state = ""
)


lambda_brackets1a = @fixture (x) -> global state = "lambda_brackets1a_$x"
lambda_brackets1b = @fixture (x) -> (
  global state = "lambda_brackets1b_$x";
)
lambda_brackets1c = @fixture (x) -> (
  global state = "lambda_brackets1c_$x";
  yield_fixture()
)
lambda_brackets1d = @fixture (x) -> (
  global state = "lambda_brackets1d_$x";
  yield_fixture();
  global state = ""
)
lambda_brackets1e = @fixture (x::Integer) -> (
  global state = "lambda_brackets1e_$x";
  yield_fixture();
  global state = ""
)


lambda_brackets2a = @fixture (x, y) -> global state = "lambda_brackets2a_$(x)_$(y)"
lambda_brackets2b = @fixture (x, y) -> (
  global state = "lambda_brackets2b_$(x)_$(y)";
)
lambda_brackets2c = @fixture (x, y) -> (
  global state = "lambda_brackets2c_$(x)_$(y)";
  yield_fixture()
)
lambda_brackets2d = @fixture (x, y) -> (
  global state = "lambda_brackets2d_$(x)_$(y)";
  yield_fixture();
  global state = ""
)
lambda_brackets2e = @fixture (x::Integer, y::Integer) -> (
  global state = "lambda_brackets2e_$(x)_$(y)";
  yield_fixture();
  global state = ""
)


@fixture function fixture_that_produces_a_value()
  global state = "fixture_that_produces_a_value"
  yield_fixture(100)
  global state = ""
end

@fixture function fixture_that_produces_two_values()
  global state = "fixture_that_produces_two_values"
  yield_fixture(100,200)
  global state = ""
end

@fixture function method1p0d0kw(x)
  global state = "method1p0d0kw_$x"
  yield_fixture()
  global state = ""
end
@fixture function method0p1d0kw(x=10)
  global state = "method0p1d0kw_$x"
  yield_fixture()
  global state = ""
end
@fixture function method0p0d1kw(;x=10)
  global state = "method0p0d1kw_$x"
  yield_fixture()
  global state = ""
end
@fixture function method2p0d0kw(x,y)
  global state = "method2p0d0kw_$(x)_$(y)"
  yield_fixture()
  global state = ""
end
@fixture function method0p2d0kw(x=10,y=20)
  global state = "method2p0d0kw_$(x)_$(y)"
  yield_fixture()
  global state = ""
end
@fixture function method0p0d2kw(;x=10,y=20)
  global state = "method0p0d2kw_$(x)_$(y)"
  yield_fixture()
  global state = ""
end
@fixture function method1p1d1kw(x,y=10;z=20)
  global state = "method1p1d1kw_$(x)_$(y)_$z"
  yield_fixture()
  global state = ""
end
@fixture function method2p2d2kw(x1,x2,y1=10,y2=20;z1=30,z2=40)
  global state = "method2p2d2kw_$(x1)_$(x2)_$(y1)_$(y2)_$(z1)_$z2"
  yield_fixture()
  global state = ""
end
@fixture function method1p0d0kwT(x::Integer)
  global state = "method1p0d0kwT_$x"
  yield_fixture()
  global state = ""
end

@fixture function method0p1d0kwT(x::Integer=10)
  global state = "method0p1d0kwT_$x"
  yield_fixture()
  global state = ""
end
@fixture function method0p0d1kwT(;x::Integer=10)
  global state = "method0p0d1kwT_$x"
  yield_fixture()
  global state = ""
end
@fixture function method2p0d0kwT(x::Integer,y::Integer)
  global state = "method2p0d0kwT_$(x)_$(y)"
  yield_fixture()
  global state = ""
end
@fixture function method0p2d0kwT(x::Integer=10,y::Integer=20)
  global state = "method0p2d0kwT$(x)_$(y)"
  yield_fixture()
  global state = ""
end
@fixture function method0p0d2kwT(;x::Integer=10,y::Integer=20)
  global state = "method0p0d2kwT_$(x)_$(y)"
  yield_fixture()
  global state = ""
end
@fixture function method1p1d1kwT(x::Integer,y::Integer=10;z::Integer=20)
  global state = "method1p1d1kwT_$(x)_$(y)_$z"
  yield_fixture()
  global state = ""
end
@fixture function method2p2d2kwT(x1::Integer,x2::Integer,y1::Integer=10,y2::Integer=20;z1::Integer=30,z2::Integer=40)
  global state = "method2p2d2kwT_$(x1)_$(x2)_$(y1)_$(y2)_$(z1)_$z2"
  yield_fixture()
  global state = ""
end

@fixture function method_variadic_a(args...)
  global state = "method_variadic_a_$args"
  yield_fixture()
  global state = ""
end
@fixture function method_variadic_b(;args...)
  global state = "method_variadic_b_$args"
  yield_fixture()
  global state = ""
end
@fixture function method_variadic_c(args...;kwargs...)
  global state = "method_variadic_c_$(args)_$kwargs"
  yield_fixture()
  global state = ""
end
@fixture function method_variadic_d(x, args...)
  global state = "method_variadic_d_$(x)_$args"
  yield_fixture()
  global state = ""
end
@fixture function method_variadic_e(; x=10, args...)
  global state = "method_variadic_e_$(x)_$args"
  yield_fixture()
  global state = ""
end
@fixture function method_variadic_f(x, args...; y=10, kwargs...)
  global state = "method_variadic_f_$(x)_$(args)_$(y)_$kwargs"
  yield_fixture()
  global state = ""
end
@fixture function method_variadic_g(args::Integer...)
  global state = "method_variadic_g_$args"
  yield_fixture()
  global state = ""
end
@fixture function method_variadic_h(args::Integer...;kwargs...)
  global state = "method_variadic_h_$(args)_$kwargs"
  yield_fixture()
  global state = ""
end
@fixture function method_variadic_i(x::Integer, args::Integer...)
  global state = "method_variadic_i_$(x)_$args"
  yield_fixture()
  global state = ""
end
@fixture function method_variadic_j(; x::Integer=10, args...)
  global state = "method_variadic_j_$(x)_$args"
  yield_fixture()
  global state = ""
end
@fixture function method_variadic_k(x::Integer, args::Integer...; y::Integer=10, kwargs...)
  global state = "method_variadic_k_$(x)_$(args)_$(y)_$kwargs"
  yield_fixture()
  global state = ""
end


facts("@Fixture tests") do
  context("shorthand_brackets0a") do
    res = shorthand_brackets0a() do
      @fact state=>"shorthand_brackets0a"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("shorthand_brackets0b") do
    res = shorthand_brackets0b() do
      @fact state=>"shorthand_brackets0b"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("shorthand_brackets0c") do
    res = shorthand_brackets0c() do
      @fact state=>"shorthand_brackets0c"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("shorthand_brackets0d") do
    res = shorthand_brackets0d() do
      @fact state=>"shorthand_brackets0d"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("shorthand_brackets1a") do
    res = shorthand_brackets1a(100) do
      @fact state=>"shorthand_brackets1a_100"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("shorthand_brackets1b") do
    res = shorthand_brackets1b(100) do
      @fact state=>"shorthand_brackets1b_100"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("shorthand_brackets1c") do
    res = shorthand_brackets1c(100) do
      @fact state=>"shorthand_brackets1c_100"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("shorthand_brackets1d") do
    res = shorthand_brackets1d(100) do
      @fact state=>"shorthand_brackets1d_100"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("shorthand_brackets1e") do
    res = shorthand_brackets1e(100) do
      @fact state=>"shorthand_brackets1e_100"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("shorthand_brackets2a") do
    res = shorthand_brackets2a(100, 200) do
      @fact state=>"shorthand_brackets2a_100_200"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("shorthand_brackets2b") do
    res = shorthand_brackets2b(100, 200) do
      @fact state=>"shorthand_brackets2b_100_200"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("shorthand_brackets2c") do
    res = shorthand_brackets2c(100, 200) do
      @fact state=>"shorthand_brackets2c_100_200"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("shorthand_brackets2d") do
    res = shorthand_brackets2d(100, 200) do
      @fact state=>"shorthand_brackets2d_100_200"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("shorthand_brackets2e") do
    res = shorthand_brackets2e(100, 200) do
      @fact state=>"shorthand_brackets2e_100_200"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("shorthand_beginend0a") do
    res = shorthand_beginend0a() do
      @fact state=>"shorthand_beginend0a"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("shorthand_beginend0b") do
    res = shorthand_beginend0b() do
      @fact state=>"shorthand_beginend0b"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("shorthand_beginend0c") do
    res = shorthand_beginend0c() do
      @fact state=>"shorthand_beginend0c"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("shorthand_beginend0d") do
    res = shorthand_beginend0d() do
      @fact state=>"shorthand_beginend0d"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("shorthand_beginend0e") do
    res = shorthand_beginend0e() do
      @fact state=>"shorthand_beginend0e"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("shorthand_beginend1a") do
    res = shorthand_beginend1a(100) do
      @fact state=>"shorthand_beginend1a_100"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("shorthand_beginend1b") do
    res = shorthand_beginend1b(100) do
      @fact state=>"shorthand_beginend1b_100"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("shorthand_beginend1c") do
    res = shorthand_beginend1c(100) do
      @fact state=>"shorthand_beginend1c_100"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("shorthand_beginend1d") do
    res = shorthand_beginend1d(100) do
      @fact state=>"shorthand_beginend1d_100"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("shorthand_beginend1e") do
    res = shorthand_beginend1e(100) do
      @fact state=>"shorthand_beginend1e_100"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("shorthand_beginend1f") do
    res = shorthand_beginend1f(100) do
      @fact state=>"shorthand_beginend1f_100"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("shorthand_beginend2a") do
    res = shorthand_beginend2a(100, 200) do
      @fact state=>"shorthand_beginend2a_100_200"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("shorthand_beginend2b") do
    res = shorthand_beginend2b(100, 200) do
      @fact state=>"shorthand_beginend2b_100_200"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("shorthand_beginend2c") do
    res = shorthand_beginend2c(100, 200) do
      @fact state=>"shorthand_beginend2c_100_200"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("shorthand_beginend2d") do
    res = shorthand_beginend2d(100, 200) do
      @fact state=>"shorthand_beginend2d_100_200"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("shorthand_beginend2e") do
    res = shorthand_beginend2e(100, 200) do
      @fact state=>"shorthand_beginend2e_100_200"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("shorthand_beginend2f") do
    res = shorthand_beginend2f(100, 200) do
      @fact state=>"shorthand_beginend2f_100_200"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method0a") do
    res = method0a() do
      @fact state=>"method0a"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method0b") do
    res = method0b() do
      @fact state=>"method0b"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method0c") do
    res = method0c() do
      @fact state=>"method0c"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method0d") do
    res = method0d() do
      @fact state=>"method0d"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method1a") do
    res = method1a(100) do
      @fact state=>"method1a_100"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method1b") do
    res = method1b(100) do
      @fact state=>"method1b_100"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method1c") do
    res = method1c(100) do
      @fact state=>"method1c_100"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method1d") do
    res = method1d(100) do
      @fact state=>"method1d_100"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method1e") do
    res = method1e(100) do
      @fact state=>"method1e_100"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method2a") do
    res = method2a(100, 200) do
      @fact state=>"method2a_100_200"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method2b") do
    res = method2b(100, 200) do
      @fact state=>"method2b_100_200"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method2c") do
    res = method2c(100, 200) do
      @fact state=>"method2c_100_200"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method2d") do
    res = method2d(100, 200) do
      @fact state=>"method2d_100_200"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method2e") do
    res = method2e(100, 200) do
      @fact state=>"method2e_100_200"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("function0a") do
    res = function0a() do
      @fact state=>"function0a"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("function0b") do
    res = function0b() do
      @fact state=>"function0b"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("function0c") do
    res = function0c() do
      @fact state=>"function0c"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("function1a") do
    res = function1a(100) do
      @fact state=>"function1a_100"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("function1b") do
    res = function1b(100) do
      @fact state=>"function1b_100"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("function1c") do
    res = function1c(100) do
      @fact state=>"function1c_100"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("function1d") do
    res = function1d(100) do
      @fact state=>"function1d_100"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("function2a") do
    res = function2a(100, 200) do
      @fact state=>"function2a_100_200"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("function2b") do
    res = function2b(100, 200) do
      @fact state=>"function2b_100_200"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("function2c") do
    res = function2c(100, 200) do
      @fact state=>"function2c_100_200"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("function2d") do
    res = function2d(100, 200) do
      @fact state=>"function2d_100_200"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("lambda_beginend0a") do
    res = lambda_beginend0a() do
      @fact state=>"lambda_beginend0a"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("lambda_beginend0b") do
    res = lambda_beginend0b() do
      @fact state=>"lambda_beginend0b"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("lambda_beginend0c") do
    res = lambda_beginend0c() do
      @fact state=>"lambda_beginend0c"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("lambda_beginend0d") do
    res = lambda_beginend0d() do
      @fact state=>"lambda_beginend0d"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("lambda_beginend1a") do
    res = lambda_beginend1a(100) do
      @fact state=>"lambda_beginend1a_100"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("lambda_beginend1b") do
    res = lambda_beginend1b(100) do
      @fact state=>"lambda_beginend1b_100"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("lambda_beginend1c") do
    res = lambda_beginend1c(100) do
      @fact state=>"lambda_beginend1c_100"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("lambda_beginend1d") do
    res = lambda_beginend1d(100) do
      @fact state=>"lambda_beginend1d_100"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("lambda_beginend1e") do
    res = lambda_beginend1e(100) do
      @fact state=>"lambda_beginend1e_100"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("lambda_beginend2a") do
    res = lambda_beginend2a(100, 200) do
      @fact state=>"lambda_beginend2a_100_200"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("lambda_beginend2b") do
    res = lambda_beginend2b(100, 200) do
      @fact state=>"lambda_beginend2b_100_200"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("lambda_beginend2c") do
    res = lambda_beginend2c(100, 200) do
      @fact state=>"lambda_beginend2c_100_200"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("lambda_beginend2d") do
    res = lambda_beginend2d(100, 200) do
      @fact state=>"lambda_beginend2d_100_200"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("lambda_beginend2e") do
    res = lambda_beginend2e(100, 200) do
      @fact state=>"lambda_beginend2e_100_200"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("lambda_brackets0a") do
    res = lambda_brackets0a() do
      @fact state=>"lambda_brackets0a"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("lambda_brackets0b") do
    res = lambda_brackets0b() do
      @fact state=>"lambda_brackets0b"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("lambda_brackets0c") do
    res = lambda_brackets0c() do
      @fact state=>"lambda_brackets0c"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("lambda_brackets0d") do
    res = lambda_brackets0d() do
      @fact state=>"lambda_brackets0d"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("lambda_brackets1a") do
    res = lambda_brackets1a(100) do
      @fact state=>"lambda_brackets1a_100"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("lambda_brackets1b") do
    res = lambda_brackets1b(100) do
      @fact state=>"lambda_brackets1b_100"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("lambda_brackets1c") do
    res = lambda_brackets1c(100) do
      @fact state=>"lambda_brackets1c_100"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("lambda_brackets1d") do
    res = lambda_brackets1d(100) do
      @fact state=>"lambda_brackets1d_100"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("lambda_brackets1e") do
    res = lambda_brackets1e(100) do
      @fact state=>"lambda_brackets1e_100"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("lambda_brackets2a") do
    res = lambda_brackets2a(100, 200) do
      @fact state=>"lambda_brackets2a_100_200"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("lambda_brackets2b") do
    res = lambda_brackets2b(100, 200) do
      @fact state=>"lambda_brackets2b_100_200"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("lambda_brackets2c") do
    res = lambda_brackets2c(100, 200) do
      @fact state=>"lambda_brackets2c_100_200"
      global state=""
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("lambda_brackets2d") do
    res = lambda_brackets2d(100, 200) do
      @fact state=>"lambda_brackets2d_100_200"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("lambda_brackets2e") do
    res = lambda_brackets2e(100, 200) do
      @fact state=>"lambda_brackets2e_100_200"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("misplaced yield_fixture() causes an error") do
    caught = false
    try
      eval(:(yield_fixture()))
    catch
      caught = true
    end
    @fact caught=>true
  end

  context("fixture_that_produces_a_value") do
    res = fixture_that_produces_a_value() do x
      @fact state=>"fixture_that_produces_a_value"
      @fact x=>100
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("fixture_that_produces_two_values") do
    res = fixture_that_produces_two_values() do x, y
      @fact state=>"fixture_that_produces_two_values"
      @fact x=>100
      @fact y=>200
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method0p0d1kw") do
    res = method0p0d1kw(x=100) do
      @fact state=>"method0p0d1kw_100"
      1234
    end
    @fact res=>1234
    @fact state=>""
    res = method0p0d1kw() do
      @fact state=>"method0p0d1kw_10"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method0p0d1kwT") do
    res = method0p0d1kwT(x=100) do
      @fact state=>"method0p0d1kwT_100"
      1234
    end
    @fact res=>1234
    @fact state=>""
    res = method0p0d1kwT() do
      @fact state=>"method0p0d1kwT_10"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method0p0d2kw") do
    res = method0p0d2kw(x=100,y=200) do
      @fact state=>"method0p0d2kw_100_200"
      1234
    end
    @fact res=>1234
    @fact state=>""
    res = method0p0d2kw() do
      @fact state=>"method0p0d2kw_10_20"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method0p0d2kwT") do
    res = method0p0d2kwT(x=100,y=200) do
      @fact state=>"method0p0d2kwT_100_200"
      1234
    end
    @fact res=>1234
    @fact state=>""
    res = method0p0d2kwT() do
      @fact state=>"method0p0d2kwT_10_20"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method0p1d0kw") do
    res = method0p1d0kw() do
      @fact state=>"method0p1d0kw_10"
      1234
    end
    @fact res=>1234
    @fact state=>""
    res = method0p1d0kw(100) do
      @fact state=>"method0p1d0kw_100"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method0p1d0kwT") do
    res = method0p1d0kwT() do
      @fact state=>"method0p1d0kwT_10"
      1234
    end
    @fact res=>1234
    @fact state=>""
    res = method0p1d0kwT(100) do
      @fact state=>"method0p1d0kwT_100"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method0p2d0kw") do
    res = method0p2d0kw(100,200) do
      @fact state=>"method2p0d0kw_100_200"
      1234
    end
    @fact res=>1234
    @fact state=>""
    res = method0p2d0kw() do
      @fact state=>"method2p0d0kw_10_20"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method0p2d0kwT") do
    res = method0p2d0kwT(100,200) do
      @fact state=>"method0p2d0kwT100_200"
      1234
    end
    @fact res=>1234
    @fact state=>""
    res = method0p2d0kwT() do
      @fact state=>"method0p2d0kwT10_20"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method1p0d0kw") do
    res = method1p0d0kw(100) do
      @fact state=>"method1p0d0kw_100"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method1p0d0kwT") do
    res = method1p0d0kwT(100) do
      @fact state=>"method1p0d0kwT_100"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method1p1d1kw") do
    res = method1p1d1kw(100,200,z=300) do
      @fact state=>"method1p1d1kw_100_200_300"
      1234
    end
    @fact res=>1234
    @fact state=>""
    res = method1p1d1kw(100) do
      @fact state=>"method1p1d1kw_100_10_20"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method1p1d1kwT") do
    res = method1p1d1kwT(100,200,z=300) do
      @fact state=>"method1p1d1kwT_100_200_300"
      1234
    end
    @fact res=>1234
    @fact state=>""
    res = method1p1d1kwT(100) do
      @fact state=>"method1p1d1kwT_100_10_20"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method2p0d0kw") do
    res = method2p0d0kw(100,200) do
      @fact state=>"method2p0d0kw_100_200"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method2p0d0kwT") do
    res = method2p0d0kwT(100,200) do
      @fact state=>"method2p0d0kwT_100_200"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method2p2d2kw") do
    res = method2p2d2kw(100,200,300,400,z1=500,z2=600) do
      @fact state=>"method2p2d2kw_100_200_300_400_500_600"
      1234
    end
    @fact res=>1234
    @fact state=>""
    res = method2p2d2kw(100,200) do
      @fact state=>"method2p2d2kw_100_200_10_20_30_40"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method2p2d2kwT") do
    res = method2p2d2kwT(100,200,300,400,z1=500,z2=600) do
      @fact state=>"method2p2d2kwT_100_200_300_400_500_600"
      1234
    end
    @fact res=>1234
    @fact state=>""
    res = method2p2d2kwT(100,200) do
      @fact state=>"method2p2d2kwT_100_200_10_20_30_40"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method_variadic_a") do
    res = method_variadic_a(10,20,30) do
      @fact state=>"method_variadic_a_(10,20,30)"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method_variadic_b") do
    res = method_variadic_b(x=10,y=20,z=30) do
      @fact state=>"method_variadic_b_Any[(:x,10),(:y,20),(:z,30)]"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method_variadic_c") do
    res = method_variadic_c(10,20,30,x=10,y=20,z=30) do
      @fact state=>"method_variadic_c_(10,20,30)_Any[(:x,10),(:y,20),(:z,30)]"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method_variadic_d") do
    res = method_variadic_d(10,20,30) do
      @fact state=>"method_variadic_d_10_(20,30)"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method_variadic_e") do
    res = method_variadic_e(x=10,y=20,z=30) do
      @fact state=>"method_variadic_e_10_Any[(:y,20),(:z,30)]"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method_variadic_f") do
    res = method_variadic_f(10,20,30,x=10,y=20,z=30) do
      @fact state=>"method_variadic_f_10_(20,30)_20_Any[(:x,10),(:z,30)]"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method_variadic_g") do
    res = method_variadic_g(10,20,30) do
      @fact state=>"method_variadic_g_(10,20,30)"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method_variadic_h") do
    res = method_variadic_h(10,20,30,x=10,y=20,z=30) do
      @fact state=>"method_variadic_h_(10,20,30)_Any[(:x,10),(:y,20),(:z,30)]"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method_variadic_i") do
    res = method_variadic_i(10,20,30) do
      @fact state=>"method_variadic_i_10_(20,30)"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method_variadic_j") do
    res = method_variadic_j(x=10,y=20,z=30) do
      @fact state=>"method_variadic_j_10_Any[(:y,20),(:z,30)]"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

  context("method_variadic_k") do
    res = method_variadic_k(10,20,30,x=10,y=20,z=30) do
      @fact state=>"method_variadic_k_10_(20,30)_20_Any[(:x,10),(:z,30)]"
      1234
    end
    @fact res=>1234
    @fact state=>""
  end

end

end
