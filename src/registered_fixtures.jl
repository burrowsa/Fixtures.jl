export add_fixture, apply_fixtures

fixtures = Dict{Symbol, (Function...)}()

function add_fixture(fixture::Function, scope::Symbol=:default)
  if haskey(fixtures, scope)
    fixtures[scope] = tuple(fixtures[scope]..., fixture)
  else
    fixtures[scope] = (fixture,)
  end
end

function add_fixture(before::Function, after::Function, scope::Symbol=:default)
  add_fixture(function()
                before()
                produce()
                after()
              end, scope)
end

function apply_fixtures(fn::Function, scope::Symbol=:default)
  function scope_fixtures()
    # Allows fixtures to de defined within in nested scopes
    const old = fixtures
    global fixtures = copy(fixtures)
    produce()
    global fixtures = old
  end

  if haskey(fixtures, scope)
    fixture(fn, scope_fixtures, fixtures[scope]...)
  else
    fixture(fn, scope_fixtures)
  end
end