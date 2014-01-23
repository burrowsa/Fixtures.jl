# TODO: test body
# TODO: repeat for shorthand, annoymous and lambdas

module MetaTests

using Fixtures.Meta
using FactCheck


facts("Meta.parse_function tests") do
  context("Empty function with no args") do
    func = parse_function(:(function hello() end))
    @fact func.name => :hello
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty function with one untyped arg") do
    func = parse_function(:(function hello(x) end))
    @fact func.name => :hello
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty function with two untyped args") do
    func = parse_function(:(function hello(x,y) end))
    @fact func.name => :hello
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 2
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
    @fact func.args[2].name => :y
    @fact func.args[2].typ => :Any
    @fact func.args[2].varargs => false
    @fact isdefined(func.args[2], :default) => false
  end

  context("Empty function with one typed arg") do
    func = parse_function(:(function hello(x::Integer) end))
    @fact func.name => :hello
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty function with two typed args") do
    func = parse_function(:(function hello(x::Integer, y::FloatingPoint) end))
    @fact func.name => :hello
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 2
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
    @fact func.args[2].name => :y
    @fact func.args[2].typ => :FloatingPoint
    @fact func.args[2].varargs => false
    @fact isdefined(func.args[2], :default) => false
  end

  context("Empty function with one union typed arg") do
    func = parse_function(:(function hello(x::Union(Integer,FloatingPoint)) end))
    @fact func.name => :hello
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :(Union(Integer, FloatingPoint))
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty function with one untyped default arg") do
    func = parse_function(:(function hello(x=100) end))
    @fact func.name => :hello
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => false
    @fact func.args[1].default => 100
  end

  context("Empty function with two untyped default args") do
    func = parse_function(:(function hello(x=100,y=200) end))
    @fact func.name => :hello
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 2
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => false
    @fact func.args[1].default => 100
    @fact func.args[2].name => :y
    @fact func.args[2].typ => :Any
    @fact func.args[2].varargs => false
    @fact func.args[2].default => 200
  end

  context("Empty function with one typed default arg") do
    func = parse_function(:(function hello(x::Integer=100) end))
    @fact func.name => :hello
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => false
    @fact func.args[1].default => 100
  end

  context("Empty function with two typed default args") do
    func = parse_function(:(function hello(x::Integer=100, y::FloatingPoint=200.0) end))
    @fact func.name => :hello
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 2
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => false
    @fact func.args[1].default => 100
    @fact func.args[2].name => :y
    @fact func.args[2].typ => :FloatingPoint
    @fact func.args[2].varargs => false
    @fact func.args[2].default => 200.0
  end

  context("Empty function with one untyped vararg") do
    func = parse_function(:(function hello(x...) end))
    @fact func.name => :hello
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => true
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty function with one typed vararg") do
    func = parse_function(:(function hello(x::Integer...) end))
    @fact func.name => :hello
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => true
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty function with one untyped default vararg") do
    func = parse_function(:(function hello(x...=100) end))
    @fact func.name => :hello
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => true
    @fact func.args[1].default => 100
  end

  context("Empty function with one typed default vararg") do
    func = parse_function(:(function hello(x::Integer...=100) end))
    @fact func.name => :hello
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => true
    @fact func.args[1].default => 100
  end

  context("Empty function with one untyped kwarg") do
    func = parse_function(:(function hello(;x=100) end))
    @fact func.name => :hello
    @fact isdefined(func, :types) => false
    @fact func.args => []
    @fact func.body => quote end

    @fact length(func.kwargs) => 1
    @fact func.kwargs[1].name => :x
    @fact func.kwargs[1].typ => :Any
    @fact func.kwargs[1].varargs => false
    @fact func.kwargs[1].default => 100
  end

  context("Empty function with two untyped kwargs") do
    func = parse_function(:(function hello(;x=100,y=200) end))
    @fact func.name => :hello
    @fact isdefined(func, :types) => false
    @fact func.args => []
    @fact func.body => quote end

    @fact length(func.kwargs) => 2
    @fact func.kwargs[1].name => :x
    @fact func.kwargs[1].typ => :Any
    @fact func.kwargs[1].varargs => false
    @fact func.kwargs[1].default => 100
    @fact func.kwargs[2].name => :y
    @fact func.kwargs[2].typ => :Any
    @fact func.kwargs[2].varargs => false
    @fact func.kwargs[2].default => 200
  end

  context("Empty function with one typed kwarg") do
    func = parse_function(:(function hello(;x::Integer=100) end))
    @fact func.name => :hello
    @fact isdefined(func, :types) => false
    @fact func.args => []
    @fact func.body => quote end

    @fact length(func.kwargs) => 1
    @fact func.kwargs[1].name => :x
    @fact func.kwargs[1].typ => :Integer
    @fact func.kwargs[1].varargs => false
    @fact func.kwargs[1].default => 100
  end

  context("Empty function with two typed kwargs") do
    func = parse_function(:(function hello(;x::Integer=100, y::FloatingPoint=200.0) end))
    @fact func.name => :hello
    @fact isdefined(func, :types) => false
    @fact func.args => []
    @fact func.body => quote end

    @fact length(func.kwargs) => 2
    @fact func.kwargs[1].name => :x
    @fact func.kwargs[1].typ => :Integer
    @fact func.kwargs[1].varargs => false
    @fact func.kwargs[1].default => 100
    @fact func.kwargs[2].name => :y
    @fact func.kwargs[2].typ => :FloatingPoint
    @fact func.kwargs[2].varargs => false
    @fact func.kwargs[2].default => 200.0
  end

  context("Empty function with one union typed kwarg") do
    func = parse_function(:(function hello(;x::Union(Integer, FloatingPoint)=100) end))
    @fact func.name => :hello
    @fact isdefined(func, :types) => false
    @fact func.args => []
    @fact func.body => quote end

    @fact length(func.kwargs) => 1
    @fact func.kwargs[1].name => :x
    @fact func.kwargs[1].typ => :(Union(Integer, FloatingPoint))
    @fact func.kwargs[1].varargs => false
    @fact func.kwargs[1].default => 100
  end

  context("Empty function with one untyped varkwarg") do
    func = parse_function(:(function hello(;x...) end))
    @fact func.name => :hello
    @fact isdefined(func, :types) => false
    @fact func.args => []
    @fact func.body => quote end

    @fact length(func.kwargs) => 1
    @fact func.kwargs[1].name => :x
    @fact func.kwargs[1].typ => :Any
    @fact func.kwargs[1].varargs => true
    @fact isdefined(func.kwargs[1], :default) => false
  end

  context("Empty function with one typed varkwarg") do
    func = parse_function(:(function hello(;x::Integer...) end))
    @fact func.name => :hello
    @fact isdefined(func, :types) => false
    @fact func.args => []
    @fact func.body => quote end

    @fact length(func.kwargs) => 1
    @fact func.kwargs[1].name => :x
    @fact func.kwargs[1].typ => :Integer
    @fact func.kwargs[1].varargs => true
    @fact isdefined(func.kwargs[1], :default) => false
  end

  context("Empty function with a mix of args and kwargs") do
    func = parse_function(:(function hello(x,y::Integer,z=99,rest...;a::Integer=100,b=200,c...) end))
    @fact func.name => :hello
    @fact isdefined(func, :types) => false
    @fact func.body => quote end

    @fact length(func.args) => 4
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
    @fact func.args[2].name => :y
    @fact func.args[2].typ => :Integer
    @fact func.args[2].varargs => false
    @fact isdefined(func.args[2], :default) => false
    @fact func.args[3].name => :z
    @fact func.args[3].typ => :Any
    @fact func.args[3].varargs => false
    @fact func.args[3].default => 99
    @fact func.args[4].name => :rest
    @fact func.args[4].typ => :Any
    @fact func.args[4].varargs => true
    @fact isdefined(func.args[4], :default) => false

    @fact length(func.kwargs) => 3
    @fact func.kwargs[1].name => :a
    @fact func.kwargs[1].typ => :Integer
    @fact func.kwargs[1].varargs => false
    @fact func.kwargs[1].default => 100
    @fact func.kwargs[2].name => :b
    @fact func.kwargs[2].typ => :Any
    @fact func.kwargs[2].varargs => false
    @fact func.kwargs[2].default => 200
    @fact func.kwargs[3].name => :c
    @fact func.kwargs[3].typ => :Any
    @fact func.kwargs[3].varargs => true
    @fact isdefined(func.kwargs[3], :default) => false
  end

  context("Empty function with no type parameter") do
    func = parse_function(:(function hello() end))
    @fact func.name => :hello
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty function with one type parameter") do
    func = parse_function(:(function hello{T}() end))
    @fact func.name => :hello
    @fact func.types => [:T]
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty function with two type parameters") do
    func = parse_function(:(function hello{T1, T2}() end))
    @fact func.name => :hello
    @fact func.types => [:T1, :T2]
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end
end

end