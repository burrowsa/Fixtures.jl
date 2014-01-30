export @fixture
export yield_fixture

using Base.Meta

function yield_fixture(args...)
  error("yield_fixture must be in the top level of scope within @fixture function")
end

const EXTRA_ARG = MetaTools.ParsedArgument(:(ecbf47d557eb469c9fc755f8e07f11f7::Function))

macro fixture(ex::Expr)
  local pfunc = MetaTools.ParsedFunction(ex)
  pfunc.args = [EXTRA_ARG, pfunc.args...]
  if pfunc.body.head == :block
    const i = findfirst(v -> isexpr(v, :call) && v.args[1]==:yield_fixture, pfunc.body.args)
    if i>0
      # Copy the call so that we get any arguments
      const call_expr = copy(pfunc.body.args[i])
      call_expr.args[1] = :ecbf47d557eb469c9fc755f8e07f11f7

      pfunc.body.args = Any[pfunc.body.args[1:(i-1)]...,
                              quote
                                try
                                  return $call_expr
                                finally
                                  $(Expr(:block, pfunc.body.args[(i+1):end]...))
                                end
                              end
                           ]
    else
      pfunc.body.args = Any[pfunc.body.args..., :(ecbf47d557eb469c9fc755f8e07f11f7())]
    end
  else
    error("Expected a :block got a $(pfunc.body.head)")
  end

  return esc(MetaTools.emit(pfunc))
end
