export patch


function patch(fn::Function, mod::Module, name::Symbol, new::Function)
  const old = mod.eval(name)
  if isgeneric(old) && isconst(mod, name)
    if !isgeneric(new)
      return patch(old, :env, nothing) do
        patch(old, :fptr, new.fptr) do
          _patch(fn, mod, :($name.code = $new.code), :())
        end
      end
    else
      return patch(old, :env, new.env) do
        patch(fn, old, :fptr, new.fptr)
      end
    end
  else
    return _patch(fn, mod, name, old, new)
  end
end

function patch(fn::Function, obj::Any, name::Symbol, new::Any)
  const old_expr = :($obj.$name)
  const old = eval(old_expr)
  return _patch(fn, Core, old_expr, old, new)
end

function patch(fn::Function, mod::Module, name::Symbol, new::Any)
  const old = mod.eval(name)
  return _patch(fn, mod, name, old, new)
end

ExprOrSymbol = Union(Expr,Symbol)

function _patch(fn::Function, mod::Module, name::ExprOrSymbol, old::Any, new::Any)
  return _patch(fn, mod, :($name = $new), :($name = $old))
end

function _patch(fn::Function, mod::Module, setup::Expr, teardown::Expr)
  mod.eval(setup)
  try
    return fn()
  finally
    mod.eval(teardown)
  end
end
