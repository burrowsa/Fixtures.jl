export patch, @patch


function patch(fn::Function, mod::Module, name::Symbol, new::Function)
  const old = mod.eval(name)
  if isgeneric(old) && isconst(mod, name)
    if !isgeneric(new)
      patch(old, :env, nothing) do
        patch(old, :fptr, new.fptr) do
          old.code=new.code
          return fn()
        end
      end
    else
      patch(old, :env, new.env) do
        return patch(fn, old, :fptr, new.fptr)
      end
    end
  else
    return patchimpl(fn, mod, name, new)
  end
end

patch(fn::Function, obj::Any, name::Symbol, new::Any) = patchimpl(fn, Core, :($obj.$name), new)

patch(fn::Function, mod::Module, name::Symbol, new::Any) = patchimpl(fn, mod, name, new)

function patchimpl(fn::Function, mod::Module, name::Union(Expr,Symbol), new::Any)
  const old = mod.eval(name)
  mod.eval(:($name = $new))
  try
    fn()
  finally
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
