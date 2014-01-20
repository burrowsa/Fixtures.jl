export add_fixture, apply_fixtures, add_simple_fixture

SymbolOrNothing = Union(Symbol, Nothing)

immutable NamedFixture
  name::SymbolOrNothing
  fn::Function
  args::(Any...)
  kwargs::Array{Any,1}
end

fixtures = Dict{Symbol, (NamedFixture...)}()

get_name(nfs::(NamedFixture...)) = [nf.name for nf in nfs]
names() = Set([[ get_name(x) for x in values(Fixtures.fixtures) ]...]...)

function add_fixture(scope::Symbol, name::SymbolOrNothing, fixture::Function, args...; kwargs...)
  if name!=nothing && name in names()
    error("A fixture named $name is already defined.")
  end

  const nf = NamedFixture(name, fixture, args, kwargs)

  if haskey(fixtures, scope)
    fixtures[scope] = tuple(fixtures[scope]...,  nf)
  else
    fixtures[scope] = (nf,)
  end
  return
end

add_fixture(scope::Symbol, fixture::Function, args...; kwargs...) = add_fixture(scope, nothing, fixture, args...; kwargs...)

function add_simple_fixture(scope::Symbol, name::SymbolOrNothing, before::Function, after::Function)
  add_fixture(scope, @fixture function()
                const val = before()
                yield_fixture(val)
                after()
              end)
end

add_simple_fixture(scope::Symbol, before::Function, after::Function) = add_simple_fixture(scope, nothing, before, after)

list_map(args...) = [ map(args...)... ]

@fixture function apply_fixtures(scope::Symbol; fixture_values=false)
  # Convert all the fixtures to tasks
  const fv = Dict{Symbol, Any}()
  const tsks = list_map(get(fixtures, scope, ())) do nf::NamedFixture
    if fixture_values && nf.name!=nothing
      return Task() do
        nf.fn(nf.args..., nf.kwargs...) do values::Any...
          if length(values)==0
            fv[nf.name] = nothing
          elseif length(values)==1
            fv[nf.name] = values[1]
          else
            fv[nf.name] = values
          end
          produce()
        end
      end
    else
      return Task(() -> nf.fn(produce, nf.args..., nf.kwargs...))
    end
  end

  # fixtures can be defined within in nested scopes, create a new scope
  const old = fixtures
  global fixtures = copy(fixtures)

  # Begin all the tasks
  for tsk in tsks
    consume(tsk)
  end

  yield_fixture((fixture_values ? (fv,) : ())...)

  # Complete the tasks in the opposite order we began them
  reverse!(tsks)
  for tsk in tsks
    consume(tsk)
  end

  # Reset our scope
  global fixtures = old
end
