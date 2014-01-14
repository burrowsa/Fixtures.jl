module MatchersTests

using Fixtures
using FactCheck


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
                (10, anything_in([10.0, 19, 36]), false),
                (10, anything_in((10.0, 19, 36)), false),
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
                ([10.0, 19, 36], anything_containing(10), false),
                ((10.0, 19, 36), anything_containing(10), false),
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
end

end