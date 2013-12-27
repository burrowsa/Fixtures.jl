export fixture

function fixture(fn::Function, fns::Function...)
  const tsks = [Task(fn) for fn in fns]

  for tsk in tsks
    consume(tsk)
  end

  try
    return fn()
  finally
    reverse!(tsks)
    for tsk in tsks
      consume(tsk)
    end

    for tsk in tsks
      if !istaskdone(tsk)
        error("Fixture should be a two-parter")
      end
    end
  end
end

