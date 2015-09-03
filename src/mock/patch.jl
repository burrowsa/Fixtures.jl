export patch, @patch, Patcher

type Patcher
  mod::Any
  name::Union(Expr,Symbol)
  new::Any

  Patcher(mod::Any, name::Symbol, new::Any) = new(mod, name, new)
end

function patch(fn::Function, patchers::Array{Patcher}; i=1)

  if i > length(patchers)
    fn()
  else
    patch(patchers[i].mod, patchers[i].name, patchers[i].new) do
      patch(fn, patchers, i=i+1)
    end
  end

end

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
      patchimp(fn, mod, name, new)
    end
  else
    return patchimpl(fn, mod, name, new)
  end
end


function patchimp(fn::Function, mod::Module, name::Symbol, new::Function)
  old = mod.eval(name)
  oldenv = old.env
  oldfptr = old.fptr
  old.env = new.env
  old.fptr = new.fptr
  try
    fn()
  finally
    old.env = oldenv
    old.fptr = oldfptr
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
