export patch, @patch


function patch(mod::Module, name::Symbol, new::Function)
  const old = mod.eval(name)
  if isgeneric(old) && isconst(mod, name)
    if !isgeneric(new)
      return function()
        fixture(produce, patch(old, :env, nothing),
                         patch(old, :fptr, new.fptr),
                         ()->old.code=new.code)
      end
    else
      return function()
        fixture(produce, patch(old, :env, new.env),
                         patch(old, :fptr, new.fptr))
      end
    end
  else
    return patchimpl(mod, name, new)
  end
end

patch(obj::Any, name::Symbol, new::Any) = patchimpl(Core, :($obj.$name), new)

patch(mod::Module, name::Symbol, new::Any) = patchimpl(mod, name, new)

patch(fn::Function, what::Any, name::Symbol, new::Any) = fixture(fn, patch(what, name, new))

function patchimpl(mod::Module, name::Union(Expr,Symbol), new::Any)
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
