if begin
     try
       import FactCheck
       true
     catch
      false
     end
   end

  export using_fixtures, context, facts

  immutable ApplyFixturesFlag end
  using_fixtures = ApplyFixturesFlag()

  import FactCheck.facts
  facts(fn::Function, applyfixtures::ApplyFixturesFlag, otherfixtures::Function...) = facts(fn, nothing, applyfixtures, otherfixtures...)
  facts(fn::Function, desc, applyfixtures::ApplyFixturesFlag, otherfixtures::Function...) = apply_fixtures(()->facts(fn, desc), :facts, otherfixtures...)

  import FactCheck.context
  context(f::Function, applyfixtures::ApplyFixturesFlag, otherfixtures::Function...) = context(f, nothing, applyfixtures, otherfixtures...)
  context(fn::Function, desc, applyfixtures::ApplyFixturesFlag, otherfixtures::Function...) = apply_fixtures(()->context(fn, desc), :context, otherfixtures...)
end