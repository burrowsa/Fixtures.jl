export fixture

function fixture(fn::Function, setup::Expr, teardown::Expr)
  return fixture(fn, Core, setup, teardown)
end

function fixture(fn::Function, mod::Module, setup::Expr, teardown::Expr)
  mod.eval(setup)
  try
    return fn()
  finally
    mod.eval(teardown)
  end
end
