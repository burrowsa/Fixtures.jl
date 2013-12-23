export patch, @patch

# TODO: find a nice way to combine coroutines

function patch(mod::Module, name::Symbol, new::Function)
  const old = mod.eval(name)
  if isgeneric(old) && isconst(mod, name)
    if !isgeneric(new)
      return function()
        patch(old, :env, nothing) do
          patch(old, :fptr, new.fptr) do
            fixture(produce, Task(()->old.code=new.code))
          end
        end
      end
    else
      return function()
        patch(old, :env, new.env) do
          patch(produce, old, :fptr, new.fptr)
        end
      end
    end
  else
    return patchimpl(mod, name, new)
  end
end

patch(obj::Any, name::Symbol, new::Any) = patchimpl(Core, :($obj.$name), new)

patch(mod::Module, name::Symbol, new::Any) = patchimpl(mod, name, new)

patch(fn::Function, what::Any, name::Symbol, new::Any) = fixture(fn, Task(patch(what, name, new)))

ExprOrSymbol = Union(Expr,Symbol)

function patchimpl(mod::Module, name::ExprOrSymbol, new::Any)
  return function()
    const old = mod.eval(name)
    mod.eval(:($name = $new))
    produce()
    mod.eval(:($name = $old))
  end
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
