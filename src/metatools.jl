module MetaTools

using Base.Meta

export ParsedArgument, ParsedFunction, emit, @commutative

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

    const kwdict = {k=>v for (k,v) in kwargs} # Julia 0.3 has a nicer way to do this
    if !haskey(kwdict, :varargs)
      out.varargs = false
    end
    if !haskey(kwdict, :typ)
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

    const kwdict = {k=>v for (k,v) in kwargs} # Julia 0.3 has a nicer way to do this
    if !haskey(kwdict, :args)
      out.args = []
    end
    if !haskey(kwdict, :body)
      out.body = quote end
    end
    return out
  end
end

parse_namespace(s::Symbol) = [ s ]

parse_namespace(q::QuoteNode) = [ q.value ]

function parse_namespace(ex::Expr)
  if ex.head!=:(.)
    error("Expected .")
  end

  return vcat(parse_namespace(ex.args[1]), parse_namespace(ex.args[2]))
end

parse_function_name(s::Symbol) = { :name => s }

parse_name(q::QuoteNode) = q.value

function parse_name(ex::Expr)
  if ex.head!=:quote
    error("Expected quote")
  end
  return ex.args[1]
end

parse_function_name(s::Symbol) = { :name => s }

function parse_function_name(ex::Expr)
  if isexpr(ex, :(.))
    out = { :name => parse_name(ex.args[2]) }
    out[:namespace] = parse_namespace(ex.args[1])
    return out
  elseif isexpr(ex, :curly)
    out = parse_function_name(ex.args[1])
    # TODO: is more syntax possible here? <:?
    out[:types] = Symbol[ex.args[2:]...]
    return out
  else
    error("Expected . or curly")
  end
end

parse_args(args::Vector) = ParsedArgument[map(ParsedArgument, args)...]

flatten_nested_block(x::Any) = Expr(:block, x)

function flatten_nested_block(ex::Expr)
  # TODO: is this deepcopy necessary?
  return flatten_nested_block_impl(deepcopy(ex))
end

flatten_nested_block_impl(s::Symbol) = s

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

function ParsedFunction(ex::Expr)
  if isexpr(ex, [:function, :(=)]) && isexpr(ex.args[1], :call)
    proto = parse_function_name(ex.args[1].args[1])
    if length(ex.args[1].args)>=2 && isexpr(ex.args[1].args[2], :parameters)
      proto[:args] = parse_args(ex.args[1].args[3:])
      proto[:kwargs] = parse_args(ex.args[1].args[2].args)
    else
      proto[:args] = parse_args(ex.args[1].args[2:])
    end
    proto[:body] = flatten_nested_block(ex.args[end])
    return ParsedFunction(;proto...)
  elseif isexpr(ex, :->) && (isa(ex.args[1], Symbol) || ex.args[1].head!=:tuple)
    return ParsedFunction(args=parse_args([ex.args[1]]),
                          body=flatten_nested_block(ex.args[end]))
  elseif isexpr(ex, [:function, :->]) && isexpr(ex.args[1], :tuple)
    return ParsedFunction(args=parse_args(ex.args[1].args),
                          body=flatten_nested_block(ex.args[end]))
  else
    error("ParsedFunction can only be applied to methods/functions/lambdas")
  end
end

function emit(arg::ParsedArgument)
  local out::Expr = Expr(:(::), arg.name, arg.typ)
  if arg.varargs
    out = Expr(:(...), out)
  end
  if isdefined(arg, :default)
    out = Expr(:kw, out, arg.default)
  end
  return out
end

emit(args::Vector{ParsedArgument}) = map(emit, args)

function emit_args(func::ParsedFunction)
  if isdefined(func, :kwargs)
    return [Expr(:parameters, emit(func.kwargs)...), emit(func.args)...]
  else
    return emit(func.args)
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
  if !isdefined(func, :name)
    return []
  elseif isdefined(func, :types)
    if isdefined(func, :namespace)
      return [Expr(:curly, emit_name(func.namespace, func.name), func.types...)]
    else
      return [Expr(:curly, func.name, func.types...)]
    end
  elseif isdefined(func, :namespace)
    return [emit_name(func.namespace, func.name)]
  else
    return [func.name]
  end
end

function emit(func::ParsedFunction)
  const head = isdefined(func, :name) ? :call : :tuple # :call for a method else :tuple
  return Expr(:function, Expr(head, emit_name(func)..., emit_args(func)...), func.body)
end

macro commutative(ex::Expr)
  # Parse the function
  pfunc = ParsedFunction(ex)

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