export ANYTHING, anything_of_type, anything_in, anything_containing

immutable Matcher
  matches::Function
  description::String
end

Base.isequal(lhs::Matcher, rhs::Matcher) = error("Can not compare 2 Matchers")
Base.isequal(matcher::Matcher, value::WeakRef) = matcher.matches(value)
Base.isequal(matcher::Matcher, value::Any) = matcher.matches(value)
Base.isequal(value::WeakRef, matcher::Matcher) = matcher.matches(value)
Base.isequal(value::Any, matcher::Matcher) = matcher.matches(value)

Base.show(io::IO, matcher::Matcher) = print(io, matcher.description)

anything_of_type(T::Type) = Matcher(v -> isa(v, T), "anything_of_type($T)")
anything_in(value::Any) = Matcher(v -> v in value, "anything_in($value)")
anything_containing(value::Any) = Matcher(v -> value in v, "anything_containing($value)")

const ANYTHING = anything_of_type(Any)