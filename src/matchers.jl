export ANYTHING, anything_of_type, anything_in, anything_containing, Matcher

immutable Matcher
  predicate::Function
  description::String
end

Base.isequal(lhs::Matcher, rhs::Matcher) = error("Can not compare 2 Matchers")
Base.isequal(matcher::Matcher, value::WeakRef) = matcher.predicate(value)
Base.isequal(matcher::Matcher, value::Any) = matcher.predicate(value)
Base.isequal(value::WeakRef, matcher::Matcher) = matcher.predicate(value)
Base.isequal(value::Any, matcher::Matcher) = matcher.predicate(value)

Base.show(io::IO, matcher::Matcher) = print(io, matcher.description)


(&)(matcher1::Matcher, matcher2::Matcher) = Matcher(x->(matcher1.predicate(x) && matcher2.predicate(x)), "($(matcher1.description) && $(matcher2.description))")


(|)(matcher1::Matcher, matcher2::Matcher) = Matcher(x->(matcher1.predicate(x) || matcher2.predicate(x)), "($(matcher1.description) || $(matcher2.description))")


(!)(matcher::Matcher) = Matcher(x->(!matcher.predicate(x)), "(not $(matcher.description))")

anything_of_type(T::Type) = Matcher(v -> isa(v, T), "anything_of_type($T)")
anything_in(value::Any) = Matcher(v -> v in value, "anything_in($value)")
anything_containing(value::Any) = Matcher(v -> value in v, "anything_containing($value)")

const ANYTHING = anything_of_type(Any)