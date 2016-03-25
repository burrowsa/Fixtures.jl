export ANYTHING, anything_of_type, anything_in, anything_containing, Matcher, redescribe

import Base: ==, &, |, !

immutable Matcher
  predicate::Function
  description::String
end

==(matcher1::Matcher, matcher2::Matcher) = error("Can not compare 2 Matchers")
==(value::WeakRef, matcher::Matcher) = matcher == value.value
==(value::Any, matcher::Matcher) = matcher == value
==(matcher::Matcher, value::WeakRef) = matcher.predicate(value.value)
==(matcher::Matcher, value::Any) = matcher.predicate(value)

Base.show(io::IO, matcher::Matcher) = print(io, matcher.description)


(&)(matcher1::Matcher, matcher2::Matcher) = Matcher(x->(matcher1.predicate(x) && matcher2.predicate(x)), "($(matcher1.description) && $(matcher2.description))")


(|)(matcher1::Matcher, matcher2::Matcher) = Matcher(x->(matcher1.predicate(x) || matcher2.predicate(x)), "($(matcher1.description) || $(matcher2.description))")


(!)(matcher::Matcher) = Matcher(x->(!matcher.predicate(x)), "(not $(matcher.description))")

redescribe(matcher::Matcher, description::String) = Matcher(matcher.predicate, description)


anything_of_type(T::Type) = Matcher(v -> isa(v, T), "anything_of_type($T)")
anything_in(value::WeakRef) = anything_in(value.value)
anything_in(value::Any) = Matcher(v -> v in value, "anything_in($value)")
anything_containing(value::WeakRef) = anything_containing(value.value)
anything_containing(value::Any) = Matcher(v -> value in v, "anything_containing($value)")

const ANYTHING = anything_of_type(Any)