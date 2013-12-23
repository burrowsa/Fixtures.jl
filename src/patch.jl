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
    return patchimpl(fn, mod, name, new)
  end
end

patch(fn::Function, obj::Any, name::Symbol, new::Any) = patchimpl(fn, Core, :($obj.$name), new)

patch(fn::Function, mod::Module, name::Symbol, new::Any) = patchimpl(fn, mod, name, new)

ExprOrSymbol = Union(Expr,Symbol)

function patchimpl(fn::Function, mod::Module, name::ExprOrSymbol, new::Any)
  const old = mod.eval(name)
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
