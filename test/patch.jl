module PatchTests

using Fixtures
using FactCheck

# This module has an example of some kinds of thing we can patch and is used by the tests
module TestModuleOne
  export test1variable, test1constmethod, test1nonconstmethod, test1function, test1lambda
  test1variable = 7
  test1constmethod(x) = x + test1variable
  test1constmethod(x, y) = x + y + test1variable
  test1nonconstmethod = test1constmethod
  test1function = function(x)
    x + test1variable
  end
  test1lambda = x -> x + test1variable
end

# This module has an example of most kinds of thing we can patch plus it uses TestModuleOne
# it is used by the tests
module TestModuleTwo
  using PatchTests.TestModuleOne
  export test2variable, test2constmethod, test2nonconstmethod, test2function, test2lambda
  test2variable = 7
  test2constmethod(x) = x + test2variable
  test2constmethod(x, y) = x + y + test2variable
  test2nonconstmethod = test2constmethod
  test2function = function(x)
    x + test2variable
  end
  test2lambda = x -> x + test2variable

  module nestedmodule
    value = 12
    func() = 200
  end

  type List
    value::Any
    next::List
    List(v::Any) = new(v)
    List(v::Any, nxt::List) = new(v, nxt)
    List{T}(vs::Vector{T}) = length(vs) > 1 ? List(vs[1], List(vs[2:end])) : List(vs[1])
  end

  lst = List([40,30,20,10])
end

# A global (outside of a module) we can use for testing.
mylist = TestModuleTwo.List(1, TestModuleTwo.List(2, TestModuleTwo.List(3, TestModuleTwo.List(4))))

# This function checks that TestModuleOne and TestModuleOne work as defined above, we run it
# before and after each test context to show that the patching has worked
function checkmodules1and2()
  @fact TestModuleOne.test1variable => 7
  @fact TestModuleOne.test1constmethod(1) => 8
  @fact TestModuleOne.test1constmethod(1,10) => 18
  @fact TestModuleOne.test1nonconstmethod(1) => 8
  @fact TestModuleOne.test1nonconstmethod(1,10) => 18
  @fact TestModuleOne.test1function(1) => 8
  @fact TestModuleOne.test1lambda(1) => 8

  @fact TestModuleTwo.test1variable => 7
  @fact TestModuleTwo.test1constmethod(1) => 8
  @fact TestModuleTwo.test1constmethod(1,10) => 18
  @fact TestModuleTwo.test1nonconstmethod(1) => 8
  @fact TestModuleTwo.test1nonconstmethod(1,10) => 18
  @fact TestModuleTwo.test1function(1) => 8
  @fact TestModuleTwo.test1lambda(1) => 8

  @fact TestModuleTwo.test2variable => 7
  @fact TestModuleTwo.test2constmethod(1) => 8
  @fact TestModuleTwo.test2constmethod(1,10) => 18
  @fact TestModuleTwo.test2nonconstmethod(1) => 8
  @fact TestModuleTwo.test2nonconstmethod(1,10) => 18
  @fact TestModuleTwo.test2function(1) => 8
  @fact TestModuleTwo.test2lambda(1) => 8
  @fact TestModuleTwo.nestedmodule.value => 12
  @fact TestModuleTwo.nestedmodule.func() => 200

  @fact TestModuleTwo.lst.value => 40
  @fact TestModuleTwo.lst.next.value => 30
  @fact TestModuleTwo.lst.next.next.value => 20
  @fact TestModuleTwo.lst.next.next.next.value => 10

  @fact typeof(TestModuleTwo.List(100)) => TestModuleTwo.List
  @fact typeof(TestModuleTwo.List(100, TestModuleTwo.List(200))) => TestModuleTwo.List
  @fact typeof(TestModuleTwo.List([1, 2, 3])) => TestModuleTwo.List
  @fact_throws TestModuleTwo.List(1,2,3)
end

# Checks that mylist is still as it was defined to be above, we run it before and after tests
# to show that the patching is working
function checkmylist()
  @fact mylist.value => 1
  @fact mylist.next.value => 2
  @fact mylist.next.next.value => 3
  @fact mylist.next.next.next.value => 4
end


# Our Patch test suite
facts("Patch tests") do

  context("patch test2variable with another value") do
    patch(TestModuleTwo, :test2variable, 100) do
      @fact TestModuleTwo.test2variable => 100
      @fact TestModuleTwo.test2constmethod(1) => 101
      @fact TestModuleTwo.test2constmethod(1,10) => 111
      @fact TestModuleTwo.test2nonconstmethod(1) => 101
      @fact TestModuleTwo.test2nonconstmethod(1,10) => 111
      @fact TestModuleTwo.test2function(1) => 101
      @fact TestModuleTwo.test2lambda(1) => 101
    end
  end

  context("patch test1variable with another value") do
    patch(TestModuleOne, :test1variable, 100) do
      @fact TestModuleTwo.test1variable => 100
      @fact TestModuleTwo.test1constmethod(1) => 101
      @fact TestModuleTwo.test1constmethod(1,10) => 111
      @fact TestModuleTwo.test1nonconstmethod(1) => 101
      @fact TestModuleTwo.test1nonconstmethod(1,10) => 111
      @fact TestModuleTwo.test1function(1) => 101
      @fact TestModuleTwo.test1lambda(1) => 101
    end
  end

  # This test shows the importance of patching globals in the module in which
  # they are defined. At least we get a warning.
  context("patch test1variable with another value in wrong module") do
    patch(TestModuleTwo, :test1variable, 100) do
      @fact TestModuleTwo.test1variable => 100 # This is all we have acheived
      @fact TestModuleTwo.test1constmethod(1) => 8
      @fact TestModuleTwo.test1constmethod(1,10) => 18
      @fact TestModuleTwo.test1nonconstmethod(1) => 8
      @fact TestModuleTwo.test1nonconstmethod(1,10) => 18
      @fact TestModuleTwo.test1function(1) => 8
      @fact TestModuleTwo.test1lambda(1) => 8
    end
  end

  context("patch test2lambda with a lambda") do
    patch(TestModuleTwo, :test2lambda, x->200) do
      @fact TestModuleTwo.test2lambda(1) => 200
      @fact TestModuleTwo.test2lambda(2) => 200
      @fact TestModuleTwo.test2lambda(3) => 200
    end
  end

  context("patch test1lambda with a lambda") do
    patch(TestModuleOne, :test1lambda, x->200) do
      @fact TestModuleTwo.test1lambda(1) => 200
      @fact TestModuleTwo.test1lambda(2) => 200
      @fact TestModuleTwo.test1lambda(3) => 200
    end
  end

  context("patch test2function with a lambda") do
    patch(TestModuleTwo, :test2function, x->200) do
      @fact TestModuleTwo.test2function(1) => 200
      @fact TestModuleTwo.test2function(2) => 200
      @fact TestModuleTwo.test2function(3) => 200
    end
  end

  context("patch test1function with a lambda") do
    patch(TestModuleOne, :test1function, x->200) do
      @fact TestModuleTwo.test1function(1) => 200
      @fact TestModuleTwo.test1function(2) => 200
      @fact TestModuleTwo.test1function(3) => 200
    end
  end

  context("patch test2nonconstmethod with a lambda") do
    patch(TestModuleTwo, :test2nonconstmethod, x->200) do
      @fact TestModuleTwo.test2nonconstmethod(1) => 200
      @fact TestModuleTwo.test2nonconstmethod(2) => 200
      @fact TestModuleTwo.test2nonconstmethod(3) => 200
      @fact_throws TestModuleTwo.test2nonconstmethod(1,10)
    end
  end

  context("patch test1nonconstmethod with a lambda") do
    patch(TestModuleOne, :test1nonconstmethod, x->200) do
      @fact TestModuleTwo.test1nonconstmethod(1) => 200
      @fact TestModuleTwo.test1nonconstmethod(2) => 200
      @fact TestModuleTwo.test1nonconstmethod(3) => 200
      @fact_throws TestModuleTwo.test1nonconstmethod(1,10)
    end
  end

  context("patch test2constmethod with a lambda") do
    patch(TestModuleTwo, :test2constmethod, x->200) do
      @fact TestModuleTwo.test2constmethod(1) => 200
      @fact TestModuleTwo.test2constmethod(2) => 200
      @fact TestModuleTwo.test2constmethod(3) => 200
      @fact_throws TestModuleTwo.test2constmethod(1,10)
    end
  end

  context("patch test1constmethod with a lambda") do
    patch(TestModuleOne, :test1constmethod, x->200) do
      @fact TestModuleTwo.test1constmethod(1) => 200
      @fact TestModuleTwo.test1constmethod(2) => 200
      @fact TestModuleTwo.test1constmethod(3) => 200
      @fact_throws TestModuleTwo.test1constmethod(1,10)
    end
  end

  # a method we will patch in over other methods for testing
  testmethod(x) = 200
  testmethod(x,y) = 400

  context("patch test2lambda with a method") do
    patch(TestModuleTwo, :test2lambda, testmethod) do
      @fact TestModuleTwo.test2lambda(1) => 200
      @fact TestModuleTwo.test2lambda(2) => 200
      @fact TestModuleTwo.test2lambda(1,10) => 400
      @fact TestModuleTwo.test2lambda(2,10) => 400
    end
  end

  context("patch test1lambda with a method") do
    patch(TestModuleTwo, :test1lambda, testmethod) do
      @fact TestModuleTwo.test1lambda(1) => 200
      @fact TestModuleTwo.test1lambda(2) => 200
      @fact TestModuleTwo.test1lambda(1,10) => 400
      @fact TestModuleTwo.test1lambda(2,10) => 400
    end
  end

  context("patch test2function with a method") do
    patch(TestModuleTwo, :test2function, testmethod) do
      @fact TestModuleTwo.test2function(1) => 200
      @fact TestModuleTwo.test2function(2) => 200
      @fact TestModuleTwo.test2function(1,10) => 400
      @fact TestModuleTwo.test2function(2,10) => 400
    end
  end

  context("patch test2nonconstmethod with a method") do
    patch(TestModuleTwo, :test2nonconstmethod, testmethod) do
      @fact TestModuleTwo.test2nonconstmethod(1) => 200
      @fact TestModuleTwo.test2nonconstmethod(2) => 200
      @fact TestModuleTwo.test2nonconstmethod(1,10) => 400
      @fact TestModuleTwo.test2nonconstmethod(2,10) => 400
    end
  end

  context("patch test1nonconstmethod with a method") do
    patch(TestModuleTwo, :test1nonconstmethod, testmethod) do
      @fact TestModuleTwo.test1nonconstmethod(1) => 200
      @fact TestModuleTwo.test1nonconstmethod(2) => 200
      @fact TestModuleTwo.test1nonconstmethod(1,10) => 400
      @fact TestModuleTwo.test1nonconstmethod(2,10) => 400
    end
  end

  context("patch test2constmethod with a method") do
    patch(TestModuleTwo, :test2constmethod, testmethod) do
      @fact TestModuleTwo.test2constmethod(1) => 200
      @fact TestModuleTwo.test2constmethod(2) => 200
      @fact TestModuleTwo.test2constmethod(1,10) => 400
      @fact TestModuleTwo.test2constmethod(2,10) => 400
    end
  end

  context("patch test1constmethod with a method") do
    patch(TestModuleOne, :test1constmethod, testmethod) do
      @fact TestModuleTwo.test1constmethod(1) => 200
      @fact TestModuleTwo.test1constmethod(2) => 200
      @fact TestModuleTwo.test1constmethod(1,10) => 400
      @fact TestModuleTwo.test1constmethod(2,10) => 400
    end
  end

  context("patch test2lambda with a value") do
    patch(TestModuleTwo, :test2lambda, 200) do
      @fact TestModuleTwo.test2lambda => 200
    end
  end

  context("patch test2function with a value") do
    patch(TestModuleTwo, :test2function, 200) do
      @fact TestModuleTwo.test2function => 200
    end
  end

  context("patch test2nonconstmethod with a value") do
    patch(TestModuleTwo, :test2nonconstmethod, 200) do
      @fact TestModuleTwo.test2nonconstmethod => 200
    end
  end

  context("patching test2constmethod with a value throws an error") do
    @fact_throws patch(TestModuleTwo, :test2constmethod, 200) do
    end
  end

  context("Ensure that the return value of the wrapped fn is always returned") do
    @fact patch(()->123, TestModuleTwo, :test2variable, 100) => 123
    @fact patch(()->456, TestModuleTwo, :test2constmethod, testmethod) => 456
    @fact patch(()->789, TestModuleTwo, :test2nonconstmethod, testmethod) => 789
    @fact patch(()->123, TestModuleTwo, :test2function, testmethod) => 123
    @fact patch(()->456, TestModuleTwo, :test2lambda, testmethod) => 456

    @fact patch(()->789, TestModuleTwo, :test2nonconstmethod, ()->200) => 789
    @fact patch(()->123, TestModuleTwo, :test2function, ()->200) => 123
    @fact patch(()->456, TestModuleTwo, :test2lambda, ()->200) => 456

    @fact patch(()->789, TestModuleTwo, :test2nonconstmethod, 200) => 789
    @fact patch(()->123, TestModuleTwo, :test2function, 200) => 123
    @fact patch(()->456, TestModuleTwo, :test2lambda, 200) => 456
  end

  context("patch a value in a nested module") do
    patch(TestModuleTwo.nestedmodule, :value, 4000) do
      @fact TestModuleTwo.nestedmodule.value => 4000
    end
  end

  context("patch a method in a nested module") do
    patch(TestModuleTwo.nestedmodule, :func, ()->1234) do
      @fact TestModuleTwo.nestedmodule.func() => 1234
    end
  end

  context("patch first value") do
    patch(TestModuleTwo.lst, :value, 100) do
      @fact TestModuleTwo.lst.value => 100
      @fact TestModuleTwo.lst.next.value => 30
      @fact TestModuleTwo.lst.next.next.value => 20
      @fact TestModuleTwo.lst.next.next.next.value => 10
    end
  end

  context("patch second value") do
    patch(TestModuleTwo.lst.next, :value, 100) do
      @fact TestModuleTwo.lst.value => 40
      @fact TestModuleTwo.lst.next.value => 100
      @fact TestModuleTwo.lst.next.next.value => 20
      @fact TestModuleTwo.lst.next.next.next.value => 10
    end
  end

  context("patch third value") do
    patch(TestModuleTwo.lst.next.next, :value, 100) do
      @fact TestModuleTwo.lst.value => 40
      @fact TestModuleTwo.lst.next.value => 30
      @fact TestModuleTwo.lst.next.next.value => 100
      @fact TestModuleTwo.lst.next.next.next.value => 10
    end
  end

  context("patch fourth value") do
    patch(TestModuleTwo.lst.next.next.next, :value, 100) do
      @fact TestModuleTwo.lst.value => 40
      @fact TestModuleTwo.lst.next.value => 30
      @fact TestModuleTwo.lst.next.next.value => 20
      @fact TestModuleTwo.lst.next.next.next.value => 100
    end
  end

#  context("patch constructor with a lambda") do
#    patch(TestModuleTwo, :List, (x,y,z) -> 100) do
#      @fact_throws TestModuleTwo.List(100)
#      @fact_throws TestModuleTwo.List(100, TestModuleTwo.List(200))
#      @fact_throws TestModuleTwo.List([1, 2, 3])
#      @fact TestModuleTwo.List(1,2,3) => 100
#      @fact typeof(TestModuleTwo.List(1,2,3)) => not(TestModuleTwo.List)
#    end
#  end
#
#  # A method to patch in as the List constructor
#  mynewconstructor(x,y,z) = 100
#
#  context("patch constructor with a method") do
#    patch(TestModuleTwo, :List, mynewconstructor) do
#      @fact_throws TestModuleTwo.List(100)
#      @fact_throws TestModuleTwo.List(100, TestModuleTwo.List(200))
#      @fact_throws TestModuleTwo.List([1, 2, 3])
#      @fact TestModuleTwo.List(1,2,3) => 100
#    end
#  end

end

# Our Patch test suite
facts("Patch tests") do

  context("patch first value of mylist") do
    patch(mylist, :value, 100) do
      @fact mylist.value => 100
      @fact mylist.next.value => 2
      @fact mylist.next.next.value => 3
      @fact mylist.next.next.next.value => 4
    end
  end

  context("patch second value of mylist") do
    patch(mylist.next, :value, 100) do
      @fact mylist.value => 1
      @fact mylist.next.value => 100
      @fact mylist.next.next.value => 3
      @fact mylist.next.next.next.value => 4
    end
  end

  context("patch third value of mylist") do
    patch(mylist.next.next, :value, 100) do
      @fact mylist.value => 1
      @fact mylist.next.value => 2
      @fact mylist.next.next.value => 100
      @fact mylist.next.next.next.value => 4
    end
  end

  context("patch fourth value of mylist") do
    patch(mylist.next.next.next, :value, 100) do
      @fact mylist.value => 1
      @fact mylist.next.value => 2
      @fact mylist.next.next.value => 3
      @fact mylist.next.next.next.value => 100
    end
  end

  # A different list to use in tests
  const myotherlist = TestModuleTwo.List([4,3,2,1])

  context("patch global variable") do
    @patch(mylist, myotherlist) do
      @fact mylist.value => 4
      @fact mylist.next.value => 3
      @fact mylist.next.next.value => 2
      @fact mylist.next.next.next.value => 1
    end
  end

  context("patch global variable and check the return value") do
    const result = @patch(mylist, myotherlist) do
      mylist
    end
    @fact result => myotherlist
  end
end

module BrokenExample
  inner_method(x) = 12345
  outer_method(x) = inner_method(x)
end

facts("Broken stuff") do
  context("patch is nobbled by method caching/inlining GH265") do
    @fact BrokenExample.outer_method(100) => 12345

    # because outer_method(int64) has already been compiled
    # we can't patch it to use our implementation of inner_method
    # See https://github.com/JuliaLang/julia/issues/265
    patch(BrokenExample, :inner_method, x->54321) do
      @fact BrokenExample.outer_method(100) => not(54321) # :(
    end
    @fact BrokenExample.outer_method(100) => 12345

    # But if we change type then we are able to patch it
    patch(BrokenExample, :inner_method, x->987654) do
      @fact BrokenExample.outer_method(100.0) => 987654
    end

    # and it is all ok afterwards
    @fact BrokenExample.outer_method(100) => 12345
    @fact BrokenExample.outer_method(100.0) => 12345
  end
end

end
