module Meta

export ParsedParsedArgument, ParsedFunction, parse_function

function parse_arg(s::Symbol)
  return s, :Any, false
end

function parse_arg(ex::Expr)
  if ex.head==:(...)
    return tuple(parse_arg(ex.args[1])[1:2]..., true)
  elseif ex.head==:(::)
    return ex.args[1], ex.args[2], false
  else
    error("Parse error")
  end
end

immutable ParsedArgument
  name::Symbol
  typ::Union(Symbol, Expr)
  varargs::Bool
  default::Any
  ParsedArgument(name::Symbol) = new(name, :Any, false)
  function ParsedArgument(ex::Expr)
    if ex.head == :kw
      const parsed = parse_arg(ex.args[1])
      return new(parsed[1], parsed[2], parsed[3], ex.args[2])
    else
      const parsed = parse_arg(ex)
      return new(parsed[1], parsed[2], parsed[3])
    end
  end
end

type ParsedFunction
  name::Symbol
  types::Array{Symbol, 1}
  args::Array{ParsedArgument, 1}
  kwargs::Array{ParsedArgument, 1}
  body::Expr
  ParsedFunction() = new()
end

function parse_function_name!(out::ParsedFunction, s::Symbol)
  out.name = s
end

function parse_function_name!(out::ParsedFunction, ex::Expr)
  if ex.head!=:curly
    error("Expected curly")
  end
  out.name = ex.args[1]
  # TODO: is more syntax possible here? <:?
  out.types = Symbol[ex.args[2:]...]
end

function parse_function_args!(out::ParsedFunction, args::Array{Any,1 })
  out.args = map(ParsedArgument, args)
end

function parse_function_keyword_args!(out::ParsedFunction, args::Array{Any,1 })
  out.kwargs = map(ParsedArgument, args)
end

function flatten_nested_block(x::Any)
  return Expr(:block, x)
end

function flatten_nested_block(ex::Expr)
  # TODO: is this copy necessary?
  return flatten_nested_block_impl(copy(ex))
end

function flatten_nested_block_impl(s::Symbol)
  return s
end

function flatten_nested_block_impl(ex::Expr)
  # TODO: Does this need to flatten more deeply?
  if ex.head==:block && length(ex.args)==1 && ex.args[1].head==:block
    return flatten_nested_block_impl(ex.args[1])
  elseif ex.head==:block && length(ex.args)==2 && isa(ex.args[1], Expr) && isa(ex.args[2], Expr) && ex.args[1].head==:line && ex.args[2].head==:block
    return flatten_nested_block_impl(ex.args[2])
  elseif ex.head==:block && length(ex.args)==2 && isa(ex.args[2], Expr) && ex.args[2].head==:block
    return flatten_nested_block_impl(Expr(:block, ex.args[1], ex.args[2].args...))
  else
    return ex
  end
end

function parse_function(ex::Expr)
  const retval = ParsedFunction()

  if (ex.head == :function || ex.head == :(=)) && ex.args[1].head == :call
    parse_function_name!(retval, ex.args[1].args[1])
    if length(ex.args[1].args)>=2 && isa(ex.args[1].args[2],Expr) && ex.args[1].args[2].head==:parameters
      parse_function_args!(retval, ex.args[1].args[3:])
      parse_function_keyword_args!(retval, ex.args[1].args[2].args)
    else
      parse_function_args!(retval, ex.args[1].args[2:])
    end
  elseif ex.head == :-> && isa(ex.args[1], Symbol) || ex.args[1].head!=:tuple
    parse_function_args!(retval, Any[ex.args[1]])
  elseif (ex.head == :function || ex.head == :->) && ex.args[1].head == :tuple
    parse_function_args!(retval, ex.args[1].args)
  else
    error("parse_function can only be applied to methods/functions/lambdas")
  end

  retval.body = flatten_nested_block(ex.args[end])

  return retval
end

end