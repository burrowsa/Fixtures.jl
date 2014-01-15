export add_fixture, apply_fixtures

fixtures = Dict{Symbol, (Function...)}()

function add_fixture(scope::Symbol, fixture::Function, args...; kwargs...)
  const coroutine = () -> fixture(produce, args..., kwargs...)

  if haskey(fixtures, scope)
    fixtures[scope] = tuple(fixtures[scope]..., coroutine)
  else
    fixtures[scope] = (coroutine,)
  end
  return
end

function add_fixture(scope::Symbol, before::Function, after::Function)
  add_fixture(scope, function(fn::Function)
                before()
                try
                  return fn()
                finally
                  after()
                end
              end)
end

function apply_fixtures(fn::Function, scope::Symbol)
  # Convert all the fixtures to tasks
  const tsks = [Task(fn) for fn in get(fixtures, scope, ())]

  # fixtures can be befined within in nested scopes, create a new scope
  const old = fixtures
  global fixtures = copy(fixtures)

  # Begin all the tasks
  for tsk in tsks
    consume(tsk)
  end

  try
    return fn()
  finally
    # Complete the tasks in the opposite order we began them
    reverse!(tsks)
    for tsk in tsks
      consume(tsk)
    end

    # Reset our scope
    global fixtures = old
  end
end