module FixtureMacroTests

using Fixtures
using FactCheck


@fixture shorthand_beginend0a() = global state = "shorthand_beginend0a"
@fixture shorthand_beginend0b() = begin
  global state = "shorthand_beginend0b"
end
@fixture shorthand_beginend0c() = begin
  global state = "shorthand_beginend0c"
  @>>>
end
@fixture shorthand_beginend0d() = begin
  global state = "shorthand_beginend0d"
  @>>>
  global state = ""
end


@fixture shorthand_beginend1a(x) = global state = "shorthand_beginend1a_$x"
@fixture shorthand_beginend1b(x) = begin
  global state = "shorthand_beginend1b_$x"
end
@fixture shorthand_beginend1c(x) = begin
  global state = "shorthand_beginend1c_$x"
  @>>>
end
@fixture shorthand_beginend1d(x) = begin
  global state = "shorthand_beginend1d_$x"
  @>>>
  global state = ""
end
@fixture shorthand_beginend1e(x::Integer) = begin
  global state = "shorthand_beginend1e_$x"
  @>>>
  global state = ""
end


@fixture shorthand_beginend2a(x, y) = global state = "shorthand_beginend2a_$(x)_$(y)"
@fixture shorthand_beginend2b(x, y) = begin
  global state = "shorthand_beginend2b_$(x)_$(y)"
end
@fixture shorthand_beginend2c(x, y) = begin
  global state = "shorthand_beginend2c_$(x)_$(y)"
  @>>>
end
@fixture shorthand_beginend2d(x, y) = begin
  global state = "shorthand_beginend2d_$(x)_$(y)"
  @>>>
  global state = ""
end
@fixture shorthand_beginend2e(x::Integer, y::Integer) = begin
  global state = "shorthand_beginend2e_$(x)_$(y)"
  @>>>
  global state = ""
end


@fixture shorthand_brackets0a() = global state = "shorthand_brackets0a"
@fixture shorthand_brackets0b() = (
  global state = "shorthand_brackets0b";
)
@fixture shorthand_brackets0c() = (
  global state = "shorthand_brackets0c";
  @>>>
)
@fixture shorthand_brackets0d() = (
  global state = "shorthand_brackets0d";
  @>>>;
  global state = ""
)


@fixture shorthand_brackets1a(x) = global state = "shorthand_brackets1a_$x"
@fixture shorthand_brackets1b(x) = (
  global state = "shorthand_brackets1b_$x";
)
@fixture shorthand_brackets1c(x) = (
  global state = "shorthand_brackets1c_$x";
  @>>>
)
@fixture shorthand_brackets1d(x) = (
  global state = "shorthand_brackets1d_$x";
  @>>>;
  global state = ""
)
@fixture shorthand_brackets1e(x::Integer) = (
  global state = "shorthand_brackets1e_$x";
  @>>>;
  global state = ""
)


@fixture shorthand_brackets2a(x, y) = global state = "shorthand_brackets2a_$(x)_$(y)"
@fixture shorthand_brackets2b(x, y) = (
  global state = "shorthand_brackets2b_$(x)_$(y)";
)
@fixture shorthand_brackets2c(x, y) = (
  global state = "shorthand_brackets2c_$(x)_$(y)";
  @>>>
)
@fixture shorthand_brackets2d(x, y) = (
  global state = "shorthand_brackets2d_$(x)_$(y)";
  @>>>;
  global state = ""
)
@fixture shorthand_brackets2e(x::Integer, y::Integer) = (
  global state = "shorthand_brackets2e_$(x)_$(y)";
  @>>>;
  global state = ""
)


function0a = @fixture function()
  global state = "function0a"
end
function0b = @fixture function()
  global state = "function0b"
  @>>>
end
function0c = @fixture function()
  global state = "function0c"
  @>>>
  global state = ""
end


function1a = @fixture function(x)
  global state = "function1a_$x"
end
function1b = @fixture function(x)
  global state = "function1b_$x"
  @>>>
end
function1c = @fixture function(x)
  global state = "function1c_$x"
  @>>>
  global state = ""
end
function1d = @fixture function(x::Integer)
  global state = "function1d_$x"
  @>>>
  global state = ""
end


function2a = @fixture function(x, y)
  global state = "function2a_$(x)_$(y)"
end
function2b = @fixture function(x, y)
  global state = "function2b_$(x)_$(y)"
  @>>>
end
function2c = @fixture function(x, y)
  global state = "function2c_$(x)_$(y)"
  @>>>
  global state = ""
end
function2d = @fixture function(x::Integer, y::Integer)
  global state = "function2d_$(x)_$(y)"
  @>>>
  global state = ""
end


@fixture function method0a()
  global state = "method0a"
end
@fixture function method0b()
  global state = "method0b"
  @>>>
end
@fixture function method0c()
  global state = "method0c"
  @>>>
  global state = ""
end


@fixture function method1a(x)
  global state = "method1a_$x"
end
@fixture function method1b(x)
  global state = "method1b_$x"
  @>>>
end
@fixture function method1c(x)
  global state = "method1c_$x"
  @>>>
  global state = ""
end
@fixture function method1d(x::Integer)
  global state = "method1d_$x"
  @>>>
  global state = ""
end


@fixture function method2a(x, y)
  global state = "method2a_$(x)_$(y)"
end
@fixture function method2b(x, y)
  global state = "method2b_$(x)_$(y)"
  @>>>
end
@fixture function method2c(x, y)
  global state = "method2c_$(x)_$(y)"
  @>>>
  global state = ""
end
@fixture function method2d(x::Integer, y::Integer)
  global state = "method2d_$(x)_$(y)"
  @>>>
  global state = ""
end


lambda_beginend0a = @fixture () -> global state = "lambda_beginend0a"
lambda_beginend0b = @fixture () -> begin
  global state = "lambda_beginend0b"
end
lambda_beginend0c = @fixture () -> begin
  global state = "lambda_beginend0c"
  @>>>
end
lambda_beginend0d = @fixture () -> begin
  global state = "lambda_beginend0d"
  @>>>
  global state = ""
end


lambda_beginend1a = @fixture (x) -> global state = "lambda_beginend1a_$x"
lambda_beginend1b = @fixture (x) -> begin
  global state = "lambda_beginend1b_$x"
end
lambda_beginend1c = @fixture (x) -> begin
  global state = "lambda_beginend1c_$x"
  @>>>
end
lambda_beginend1d = @fixture (x) -> begin
  global state = "lambda_beginend1d_$x"
  @>>>
  global state = ""
end
lambda_beginend1e = @fixture (x::Integer) -> begin
  global state = "lambda_beginend1e_$x"
  @>>>
  global state = ""
end


lambda_beginend2a = @fixture (x, y) -> global state = "lambda_beginend2a_$(x)_$(y)"
lambda_beginend2b = @fixture (x, y) -> begin
  global state = "lambda_beginend2b_$(x)_$(y)"
end
lambda_beginend2c = @fixture (x, y) -> begin
  global state = "lambda_beginend2c_$(x)_$(y)"
  @>>>
end
lambda_beginend2d = @fixture (x, y) -> begin
  global state = "lambda_beginend2d_$(x)_$(y)"
  @>>>
  global state = ""
end
lambda_beginend2e = @fixture (x::Integer, y::Integer) -> begin
  global state = "lambda_beginend2e_$(x)_$(y)"
  @>>>
  global state = ""
end


lambda_brackets0a = @fixture () -> global state = "lambda_brackets0a"
lambda_brackets0b = @fixture () -> (
  global state = "lambda_brackets0b";
)
lambda_brackets0c = @fixture () -> (
  global state = "lambda_brackets0c";
  @>>>
)
lambda_brackets0d = @fixture () -> (
  global state = "lambda_brackets0d";
  @>>>;
  global state = ""
)


lambda_brackets1a = @fixture (x) -> global state = "lambda_brackets1a_$x"
lambda_brackets1b = @fixture (x) -> (
  global state = "lambda_brackets1b_$x";
)
lambda_brackets1c = @fixture (x) -> (
  global state = "lambda_brackets1c_$x";
  @>>>
)
lambda_brackets1d = @fixture (x) -> (
  global state = "lambda_brackets1d_$x";
  @>>>;
  global state = ""
)
lambda_brackets1e = @fixture (x::Integer) -> (
  global state = "lambda_brackets1e_$x";
  @>>>;
  global state = ""
)


lambda_brackets2a = @fixture (x, y) -> global state = "lambda_brackets2a_$(x)_$(y)"
lambda_brackets2b = @fixture (x, y) -> (
  global state = "lambda_brackets2b_$(x)_$(y)";
)
lambda_brackets2c = @fixture (x, y) -> (
  global state = "lambda_brackets2c_$(x)_$(y)";
  @>>>
)
lambda_brackets2d = @fixture (x, y) -> (
  global state = "lambda_brackets2d_$(x)_$(y)";
  @>>>;
  global state = ""
)
lambda_brackets2e = @fixture (x::Integer, y::Integer) -> (
  global state = "lambda_brackets2e_$(x)_$(y)";
  @>>>;
  global state = ""
)


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

  context("misplaced @>>> causes an error") do
    caught = false
    try
      eval(:(@>>>))
    catch
      caught = true
    end
    @fact caught=>true
  end
end

end