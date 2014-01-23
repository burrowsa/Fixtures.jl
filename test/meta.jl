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