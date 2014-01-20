if begin
     try
       import FactCheck
       true
     catch
      false
     end
   end

  export using_fixtures

  immutable ApplyFixturesFlag end
  const using_fixtures = ApplyFixturesFlag()

  import FactCheck.facts
  facts(fn::Function, applyfixtures::ApplyFixturesFlag; fixture_values=false) = facts(fn, nothing, applyfixtures, fixture_values=fixture_values)
  facts(fn::Function, desc, applyfixtures::ApplyFixturesFlag; fixture_values=false) = apply_fixtures((args::Any...)->facts(( () -> fn(args...) ), desc), :facts, fixture_values=fixture_values)

  import FactCheck.context
  context(f::Function, applyfixtures::ApplyFixturesFlag; fixture_values=false) = context(f, nothing, applyfixtures, fixture_values=fixture_values)
  context(fn::Function, desc, applyfixtures::ApplyFixturesFlag; fixture_values=false) = apply_fixtures((args::Any...)->context(( () -> fn(args...) ), desc), :context, fixture_values=fixture_values)
end