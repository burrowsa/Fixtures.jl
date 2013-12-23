export patch, @patch


function patch(fn::Function, mod::Module, name::Symbol, new::Function)
  const old = mod.eval(name)
  if isgeneric(old) && isconst(mod, name)
    if !isgeneric(new)
      return patch(old, :env, nothing) do
        patch(old, :fptr, new.fptr) do
          fixture(fn, Task(()->old.code=new.code))
        end
      end
    else
      return patch(old, :env, new.env) do
        patch(fn, old, :fptr, new.fptr)
      end
    end
  else
    return patchimpl(fn, mod, name, old, new)
  end
end

function patch(fn::Function, obj::Any, name::Symbol, new::Any)
  const old_expr = :($obj.$name)
  const old = eval(old_expr)
  return patchimpl(fn, Core, old_expr, old, new)
end

function patch(fn::Function, mod::Module, name::Symbol, new::Any)
  const old = mod.eval(name)
  return patchimpl(fn, mod, name, old, new)
end

ExprOrSymbol = Union(Expr,Symbol)

function patchimpl(fn::Function, mod::Module, name::ExprOrSymbol, old::Any, new::Any)
  return fixture(fn, Task() do
      mod.eval(:($name = $new))
      produce()
      mod.eval(:($name = $old))
    end)
end

macro patch(expr::Expr, name::Symbol, new::Any)
  quote
    const old = $(esc(name))
    try
      $(esc(name))=$(esc(new))
      $(esc(expr))()
    finally
      $(esc(name))=old
    end
  end
end
