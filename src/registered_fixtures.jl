export add_fixture, apply_fixtures, add_simple_fixture

SymbolOrNothing = Union(Symbol, Nothing)

immutable NamedFixture
  name::SymbolOrNothing
  fn::Function
  args::Any
  kwargs::Vector
end

fixtures = Dict{Symbol, Array{NamedFixture}}()

get_name(nfs::Array{NamedFixture}) = Set( [nf.name for nf in nfs] )

function is_name_good(name::SymbolOrNothing)
  result = false

  if name != nothing
    for fixtures in values(Fixtures.fixtures)
      if name in get_name(fixtures)
        result = true
      end
    end
  end

  return result
end

function add_fixture(scope::Symbol, name::SymbolOrNothing, fixture::Function, args...; kwargs...)

  if is_name_good(name)
    error("A fixture named $name is already defined.")
  end

  const nf = NamedFixture(name, fixture, args, kwargs)

  if haskey(fixtures, scope)
    append!(fixtures[scope], [nf])
  else
    fixtures[scope] = Array(NamedFixture, 1)
    fixtures[scope][1] = nf
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

@fixture function apply_fixtures(scope::Symbol; fixture_values::Bool=false)
  # Convert all the fixtures to tasks

  const fv = Dict{Symbol, Any}()

  temp = get(fixtures, scope, ())

  const tsks = list_map(temp) do nf
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
