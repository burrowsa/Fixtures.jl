module MatchersTests

using Fixtures
using FactCheck


const JULIA_0_2 = (VERSION == v"0.2.0")


facts("Matchers tests") do
  for (value, matcher, expected) in [
                (10, ANYTHING, true),
                (12.3456, ANYTHING, true),
                ("hello world", ANYTHING, true),
                (10, anything_of_type(Number), true),
                (12.3456, anything_of_type(Number), true),
                ("hello world", anything_of_type(Number), false),
                (10, anything_of_type(Integer), true),
                (12.3456, anything_of_type(Integer), false),
                ("hello world", anything_of_type(Integer), false),
                # =========================================
                (10, anything_in(10), true),
                (10, anything_in(11), false),
                (10, anything_in([10, 19, 36]), true),
                (10, anything_in([11, 19, 36]), false),
                (10, anything_in((10, 19, 36)), true),
                (10, anything_in((11, 19, 36)), false),
                (10, anything_in([10, "19", 36.0]), true),
                (10, anything_in([11, "19", 36.0]), false),
                (10, anything_in((10, "19", 36.0)), true),
                (10, anything_in((11, "19", 36.0)), false),
                (10, anything_in(["10", 19, 36]), false),
                (10, anything_in(("10", 19, 36)), false),
                (10, anything_in([10.0, 19, 36]), !JULIA_0_2),
                (10, anything_in((10.0, 19, 36)), !JULIA_0_2),
                (10, anything_in([(10,), 19, 36]), false),
                (10, anything_in(((10,), 19, 36)), false),
                (10, anything_in([[10,], 19, 36]), true),
                (10, anything_in(([10,], 19, 36)), false),
                (10, anything_in(1:10), true),
                (10, anything_in(1:9), false),
                (10, anything_in([]), false),
                (10, anything_in(()), false),
                # =========================================
                (10, anything_containing(10), true),
                (11, anything_containing(10), false),
                ([10, 19, 36], anything_containing(10), true),
                ([11, 19, 36], anything_containing(10), false),
                ((10, 19, 36), anything_containing(10), true),
                ((11, 19, 36), anything_containing(10), false),
                ([10, "19", 36.0], anything_containing(10), true),
                ([11, "19", 36.0], anything_containing(10), false),
                ((10, "19", 36.0), anything_containing(10), true),
                ((11, "19", 36.0), anything_containing(10), false),
                (["10", 19, 36], anything_containing(10), false),
                (("10", 19, 36), anything_containing(10), false),
                ([10.0, 19, 36], anything_containing(10), !JULIA_0_2),
                ((10.0, 19, 36), anything_containing(10), !JULIA_0_2),
                ([(10,), 19, 36], anything_containing(10), false),
                (((10,), 19, 36), anything_containing(10), false),
                ([[10,], 19, 36], anything_containing(10), true),
                (([10,], 19, 36), anything_containing(10), false),
                (1:10, anything_containing(10), true),
                (1:9, anything_containing(10), false),
                ([], anything_containing(10), false),
                ((), anything_containing(10), false),
                ]
    context("$value == $matcher => $expected") do
      @fact (value==matcher) => expected
      @fact (value!=matcher) => not(expected)
      @fact (matcher==value) => expected
      @fact (matcher!=value) => not(expected)
    end
  end

  context("Can't compare 2 Matchers") do
    @fact_throws ANYTHING==ANYTHING
  end

  const ANYTHING_LESS_THAN_SEVEN = Matcher(x->x<7, "Anything less than seven")
  const ANY_INTEGER = anything_of_type(Integer)

  context("A custom Matcher") do
    @fact (-1234==ANYTHING_LESS_THAN_SEVEN) => true
    @fact (6==ANYTHING_LESS_THAN_SEVEN) => true
    @fact (7==ANYTHING_LESS_THAN_SEVEN) => false
    @fact (-1234.56==ANYTHING_LESS_THAN_SEVEN) => true
    @fact (6.54321==ANYTHING_LESS_THAN_SEVEN) => true
    @fact (7.89==ANYTHING_LESS_THAN_SEVEN) => false
  end

  context("Composite matchers: and") do
    const ANY_INTEGER_LESS_THAN_SEVEN = ANYTHING_LESS_THAN_SEVEN & ANY_INTEGER

    @fact (-1234==ANY_INTEGER_LESS_THAN_SEVEN) => true
    @fact (6==ANY_INTEGER_LESS_THAN_SEVEN) => true
    @fact (7==ANY_INTEGER_LESS_THAN_SEVEN) => false
    @fact (-1234.56==ANY_INTEGER_LESS_THAN_SEVEN) => false
    @fact (6.54321==ANY_INTEGER_LESS_THAN_SEVEN) => false
    @fact (7.89==ANY_INTEGER_LESS_THAN_SEVEN) => false
  end

  context("Composite matchers: or") do
    const ANY_INTEGER_OR_ANYTHING_LESS_THAN_SEVEN = ANYTHING_LESS_THAN_SEVEN | ANY_INTEGER

    @fact (-1234==ANY_INTEGER_OR_ANYTHING_LESS_THAN_SEVEN) => true
    @fact (6==ANY_INTEGER_OR_ANYTHING_LESS_THAN_SEVEN) => true
    @fact (7==ANY_INTEGER_OR_ANYTHING_LESS_THAN_SEVEN) => true
    @fact (1234==ANY_INTEGER_OR_ANYTHING_LESS_THAN_SEVEN) => true
    @fact (-1234.56==ANY_INTEGER_OR_ANYTHING_LESS_THAN_SEVEN) => true
    @fact (6.54321==ANY_INTEGER_OR_ANYTHING_LESS_THAN_SEVEN) => true
    @fact (7.89==ANY_INTEGER_OR_ANYTHING_LESS_THAN_SEVEN) => false
  end

  context("Composite matchers: not") do
    const ANYTHING_GREATER_THAN_OR_EQUAL_TO_SEVEN = !ANYTHING_LESS_THAN_SEVEN
    @fact (-1234==ANYTHING_LESS_THAN_SEVEN) => true
    @fact (6==ANYTHING_LESS_THAN_SEVEN) => true
    @fact (7==ANYTHING_LESS_THAN_SEVEN) => false
    @fact (-1234.56==ANYTHING_LESS_THAN_SEVEN) => true
    @fact (6.54321==ANYTHING_LESS_THAN_SEVEN) => true
    @fact (7.89==ANYTHING_LESS_THAN_SEVEN) => false
  end

  context("Redescribe a composite matcher") do
    const composite1 = ANYTHING_LESS_THAN_SEVEN | ANY_INTEGER

    @fact composite1.description => "(Anything less than seven || anything_of_type(Integer))"

    const composite2 = redescribe(composite1, "A lovely description of our matcher")

    @fact composite2.description => "A lovely description of our matcher"

    @fact (-1234==composite2) => true
    @fact (6==composite2) => true
    @fact (7==composite2) => true
    @fact (1234==composite2) => true
    @fact (-1234.56==composite2) => true
    @fact (6.54321==composite2) => true
    @fact (7.89==composite2) => false
  end
end

end