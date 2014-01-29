module Meta

using Base.Meta.isexpr
using Base.Meta.quot

export ParsedArgument, ParsedFunction, parse_function, emit, @commutative

type ParsedArgument
  name::Symbol
  typ::Union(Symbol, Expr)
  varargs::Bool
  default::Any
  function ParsedArgument(;kwargs...)
    const out::ParsedArgument = new()
    for (kwname, kwvalue) in kwargs
      setfield(out, kwname, kwvalue)
    end

    const kwdict = Dict(collect(zip(kwargs...))...)
    if !(:varargs in keys(kwdict))
      out.varargs = false
    end
    if !(:typ in keys(kwdict))
      out.typ = :Any
    end
    return out
  end
end

ParsedArgument(name::Symbol; kw...) = ParsedArgument(name=name; kw...)

function ParsedArgument(ex::Expr; kw...)
  if isexpr(ex, [:kw, :(=)])
    return ParsedArgument(ex.args[1], default=ex.args[2]; kw...)
  elseif isexpr(ex, :tuple, 1)
    return ParsedArgument(ex.args[1]; kw...)
  elseif isexpr(ex, :(...))
    return ParsedArgument(ex.args[1], varargs=true; kw...)
  elseif isexpr(ex, :(::))
    return ParsedArgument(name=ex.args[1], typ=ex.args[2]; kw...)
  else
    error("Parse error")
  end
end

type ParsedFunction
  name::Symbol
  namespace::Vector{Symbol}
  types::Vector{Symbol}
  args::Vector{ParsedArgument}
  kwargs::Vector{ParsedArgument}
  body::Expr
  function ParsedFunction(;kwargs...)
    const out::ParsedFunction = new()
    for (kwname, kwvalue) in kwargs
      setfield(out, kwname, kwvalue)
    end
    if !isdefined(out, :args)
      out.args = []
    end
    if !isdefined(out, :body)
      out.body = quote end
    end
    return out
  end
end

function parse_function_name!(out::ParsedFunction, s::Symbol)
  out.name = s
end

parse_namespace(s::Symbol) = [ s ]

parse_namespace(q::QuoteNode) = [ q.value ]

parse_name(q::QuoteNode) = q.value

function parse_name(ex::Expr)
  if ex.head!=:quote
    error("Expected quote")
  end
  return ex.args[1]
end

function parse_namespace(ex::Expr)
  if ex.head!=:(.)
    error("Expected .")
  end

  return vcat(parse_namespace(ex.args[1]), parse_namespace(ex.args[2]))
end

function parse_function_name!(out::ParsedFunction, ex::Expr)
  if isexpr(ex, :(.))
    out.namespace = parse_namespace(ex.args[1])
    out.name = parse_name(ex.args[2])
  elseif isexpr(ex, :curly)
    parse_function_name!(out, ex.args[1])
    # TODO: is more syntax possible here? <:?
    out.types = Symbol[ex.args[2:]...]
  else
    error("Expected . or curly")
  end
end

function parse_function_args!(out::ParsedFunction, args::Vector)
  out.args = map(ParsedArgument, args)
end

function parse_function_keyword_args!(out::ParsedFunction, args::Vector)
  out.kwargs = map(ParsedArgument, args)
end

function flatten_nested_block(x::Any)
  return Expr(:block, x)
end

function flatten_nested_block(ex::Expr)
  # TODO: is this deepcopy necessary?
  return flatten_nested_block_impl(deepcopy(ex))
end

function flatten_nested_block_impl(s::Symbol)
  return s
end

function flatten_nested_block_impl(ex::Expr)
  # TODO: Does this need to flatten more deeply?
  if isexpr(ex, :block, 1) && isexpr(ex.args[1], :block)
    return flatten_nested_block_impl(ex.args[1])
  elseif isexpr(ex, :block, 2) && isexpr(ex.args[1], :line) && isexpr(ex.args[2], :block)
    return flatten_nested_block_impl(ex.args[2])
  elseif isexpr(ex, :block, 2) && isexpr(ex.args[2], :block)
    return flatten_nested_block_impl(Expr(:block, ex.args[1], ex.args[2].args...))
  else
    return ex
  end
end

function parse_function(ex::Expr)
  const retval = ParsedFunction()

  if isexpr(ex, [:function, :(=)]) && isexpr(ex.args[1], :call)
    parse_function_name!(retval, ex.args[1].args[1])
    if length(ex.args[1].args)>=2 && isexpr(ex.args[1].args[2], :parameters)
      parse_function_args!(retval, ex.args[1].args[3:])
      parse_function_keyword_args!(retval, ex.args[1].args[2].args)
    else
      parse_function_args!(retval, ex.args[1].args[2:])
    end
  elseif isexpr(ex, :->) && (isa(ex.args[1], Symbol) || ex.args[1].head!=:tuple)
    parse_function_args!(retval, Any[ex.args[1]])
  elseif isexpr(ex, [:function, :->]) && isexpr(ex.args[1], :tuple)
    parse_function_args!(retval, ex.args[1].args)
  else
    error("parse_function can only be applied to methods/functions/lambdas")
  end

  retval.body = flatten_nested_block(ex.args[end])

  return retval
end

function emit_arg(arg::ParsedArgument)
  local out::Expr = Expr(:(::), arg.name, arg.typ)
  if arg.varargs
    out = Expr(:(...), out)
  end
  if isdefined(arg, :default)
    out = Expr(:kw, out, arg.default)
  end
  return out
end

emit_args(args::Vector{ParsedArgument}) = map(emit_arg, args)

function emit_args(func::ParsedFunction)
  if isdefined(func, :kwargs)
    return [Expr(:parameters, emit_args(func.kwargs)...), emit_args(func.args)...]
  else
    return emit_args(func.args)
  end
end

make_quotenode(s::Symbol) = eval(quot(quot(s)))

function emit_name(namespace::Vector{Symbol}, name::Symbol)
  if length(namespace)>0
    return Expr(:(.), emit_name(namespace[1:end-1], namespace[end]), make_quotenode(name))
  else
    return name
  end
end

function emit_name(func::ParsedFunction)
  if isdefined(func, :types)
    if isdefined(func, :namespace)
      return Expr(:curly, emit_name(func.namespace, func.name), func.types...)
    else
      return Expr(:curly, func.name, func.types...)
    end
  elseif isdefined(func, :namespace)
    return emit_name(func.namespace, func.name)
  else
    return func.name
  end
end

function emit(func::ParsedFunction)
  if isdefined(func, :name)
    # Method
    return Expr(:function, Expr(:call, emit_name(func), emit_args(func)...), func.body)
  else
    # Anonymous function
    return Expr(:function, Expr(:tuple, emit_args(func.args)...), func.body)
  end
end

macro commutative(ex::Expr)
  # Parse the function
  pfunc = parse_function(ex)

  if (!isdefined(pfunc, :name) ||
      length(pfunc.args) != 2 ||
      pfunc.args[1].varargs || pfunc.args[2].varargs ||
      isdefined(pfunc.args[1], :default) || isdefined(pfunc.args[2], :default) ||
      (isdefined(pfunc, :kwargs) && length(pfunc.kwargs) != 0))
    error("Expected a method of 2 simple arguments only")
  end

  if pfunc.args[1].typ == pfunc.args[2].typ
    error("Arguments must be of different types")
  end

  # commutative so we can just swap the arguments
  reverse!(pfunc.args)

  if pfunc.args[1].typ == :Any || pfunc.args[2].typ == :Any
    # If one of the arguments is nothing we'll get warning unless we
    # define a method with symetric types first
    pfunc2 = deepcopy(pfunc)
    if pfunc2.args[1].typ == :Any
      pfunc2.args[1].typ = pfunc2.args[2].typ
    else
      pfunc2.args[2].typ = pfunc2.args[1].typ
    end
    # produce three forms of the method
    return esc(quote
      $(emit(pfunc2))
      $ex
      $(emit(pfunc))
    end)
  else
    # produce two forms of the method
    return esc(quote
      $ex
      $(emit(pfunc))
    end)
  end
end

end