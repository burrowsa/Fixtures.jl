export patch


# TODO:: implement some of the method/function stuff in terms of patches on the function properties
function patch(fn::Function, mod::Module, name::Symbol, new::Function)
  const old = mod.eval(name)

  if isgeneric(old) && isconst(mod, name)
    const old_fptr, old_env = mod.eval(:($name.fptr, $name.env))
    if !isgeneric(new)
      const setup = quote
        $name.fptr = $new.fptr
        $name.env = nothing
        $name.code = $new.code
      end
    else
      const setup = quote
        $name.fptr = $new.fptr
        $name.env = $new.env
      end
    end
    const teardown = quote
      $name.fptr = $old_fptr
      $name.env = $old_env
    end
    return _patch(fn, mod, setup, teardown)
  else
    return _patch(fn, mod, name, old, new)
  end
end

function patch(fn::Function, obj::Any, name::Symbol, new::Any)
  const old_expr = :($obj.$name)
  const old = eval(old_expr)
  return _patch(fn, Base, old_expr, old, new)
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
