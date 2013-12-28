if begin
     try
       import FactCheck
       true
     catch
      false
     end
   end

  export with_fixtures, context, facts

  immutable ApplyFixturesFlag end
  with_fixtures = ApplyFixturesFlag()

  import FactCheck.facts
  facts(f::Function, applyfixtures::ApplyFixturesFlag) = facts(f, nothing, applyfixtures)
  facts(fn::Function, desc, applyfixtures::ApplyFixturesFlag) = apply_fixtures(()->facts(fn, desc), :facts)

  facts(f::Function, fixtures::Function...) = facts(f, nothing, fixtures...)
  facts(fn::Function, desc, fixtures::Function...) = fixture(()->facts(fn, desc), fixtures...)

  import FactCheck.context
  context(f::Function, applyfixtures::ApplyFixturesFlag) = context(f, nothing, applyfixtures)
  context(fn::Function, desc, applyfixtures::ApplyFixturesFlag) = apply_fixtures(()->context(fn, desc), :context)

  context(f::Function, fixtures::Function...) = context(f, nothing, fixtures...)
  context(fn::Function, desc, fixtures::Function...) = fixture(()->context(fn, desc), fixtures...)
end