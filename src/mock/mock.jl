import Base.reset
export mock, calls, reset, call

global _calls = Dict{Function, Vector}()

function mock(;return_value::Any=nothing, side_effect::Union(Function, Nothing)=nothing)
  function impl(args::Any...; kwargs...)
    _calls[impl] = vcat(calls(impl), [(args, kwargs)])
    if side_effect==nothing
      return return_value
    else
      return side_effect(args..., kwargs...)
    end
  end
  return impl
end

function calls(fn::Function)
  return get(_calls, fn, [])
end

function reset(fn::Function)
  _calls[fn] = []
  return
end

function call(args::Any...; kwargs...)
  return args, kwargs
end