export fixture

function fixture(fn::Function, tsk::Task)
  consume(tsk)
  try
    return fn()
  finally
    consume(tsk)
  end
end
