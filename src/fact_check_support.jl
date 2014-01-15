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
  facts(fn::Function, applyfixtures::ApplyFixturesFlag) = facts(fn, nothing, applyfixtures)
  facts(fn::Function, desc, applyfixtures::ApplyFixturesFlag) = apply_fixtures(()->facts(fn, desc), :facts)

  import FactCheck.context
  context(f::Function, applyfixtures::ApplyFixturesFlag) = context(f, nothing, applyfixtures)
  context(fn::Function, desc, applyfixtures::ApplyFixturesFlag) = apply_fixtures(()->context(fn, desc), :context)
end