using Base.Test
using mock
using FactCheck

# This module has an example of most kinds of thing we can patch and is used by the tests
module testmodule1
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

# This module has an example of most kinds of thing we can patch plus it uses testmodule1
# it is used by the tests
module testmodule2
  using testmodule1
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
    List{T}(vs::Array{T,1}) = length(vs) > 1 ? List(vs[1], List(vs[2:])) : List(vs[1])
  end

  lst = List([40,30,20,10])
end

# A global (outside of a module) we can use for testing.
mylist = testmodule2.List(1, testmodule2.List(2, testmodule2.List(3, testmodule2.List(4))))

# This function checks that testmodule1 works as defined above, we run it before and after
# each test to show that the patching has worked
function checkmodule1()
  @fact testmodule1.test1variable => 7
  @fact testmodule1.test1constmethod(1) => 8
  @fact testmodule1.test1constmethod(1,10) => 18
  @fact testmodule1.test1nonconstmethod(1) => 8
  @fact testmodule1.test1nonconstmethod(1,10) => 18
  @fact testmodule1.test1function(1) => 8
  @fact testmodule1.test1lambda(1) => 8
end

# This function checks that testmodule2 works as defined above, we run it before and after
# each test to show that the patching has worked
function checkmodule2()
  @fact testmodule2.test1variable => 7
  @fact testmodule2.test1constmethod(1) => 8
  @fact testmodule2.test1constmethod(1,10) => 18
  @fact testmodule2.test1nonconstmethod(1) => 8
  @fact testmodule2.test1nonconstmethod(1,10) => 18
  @fact testmodule2.test1function(1) => 8
  @fact testmodule2.test1lambda(1) => 8

  @fact testmodule2.test2variable => 7
  @fact testmodule2.test2constmethod(1) => 8
  @fact testmodule2.test2constmethod(1,10) => 18
  @fact testmodule2.test2nonconstmethod(1) => 8
  @fact testmodule2.test2nonconstmethod(1,10) => 18
  @fact testmodule2.test2function(1) => 8
  @fact testmodule2.test2lambda(1) => 8
  @fact testmodule2.nestedmodule.value => 12
  @fact testmodule2.nestedmodule.func() => 200

  @fact testmodule2.lst.value => 40
  @fact testmodule2.lst.next.value => 30
  @fact testmodule2.lst.next.next.value => 20
  @fact testmodule2.lst.next.next.next.value => 10

  @fact typeof(testmodule2.List(100)) => testmodule2.List
  @fact typeof(testmodule2.List(100, testmodule2.List(200))) => testmodule2.List
  @fact typeof(testmodule2.List([1, 2, 3])) => testmodule2.List
  @fact_throws testmodule2.List(1,2,3)
end

# This function checks that testmodule1 and testmodule1 work as defined above, we run it
# before and after each test to show that the patching has worked
function checkmodules1and2()
  checkmodule1()
  checkmodule2()
end

# Checks that mylist is still as it was defined to be above, we run it before and after tests
# to show that the patching is working
function checkmylist()
  @fact mylist.value => 1
  @fact mylist.next.value => 2
  @fact mylist.next.next.value => 3
  @fact mylist.next.next.next.value => 4
end

# Runs the supplied check function before and after fn
function checkbeforeandafter(fn::Function, check::Function)
  return fixture(fn, Task() do
    check()
    produce()
    check()
  end)
end

# Our Patch test suite
facts("Patch tests") do

  context("patch test2variable with another value") do
    checkbeforeandafter(checkmodule2) do
      patch(testmodule2, :test2variable, 100) do
        @fact testmodule2.test2variable => 100
        @fact testmodule2.test2constmethod(1) => 101
        @fact testmodule2.test2constmethod(1,10) => 111
        @fact testmodule2.test2nonconstmethod(1) => 101
        @fact testmodule2.test2nonconstmethod(1,10) => 111
        @fact testmodule2.test2function(1) => 101
        @fact testmodule2.test2lambda(1) => 101
      end
    end
  end

  context("patch test1variable with another value") do
    checkbeforeandafter(checkmodules1and2) do
      patch(testmodule1, :test1variable, 100) do
        @fact testmodule2.test1variable => 100
        @fact testmodule2.test1constmethod(1) => 101
        @fact testmodule2.test1constmethod(1,10) => 111
        @fact testmodule2.test1nonconstmethod(1) => 101
        @fact testmodule2.test1nonconstmethod(1,10) => 111
        @fact testmodule2.test1function(1) => 101
        @fact testmodule2.test1lambda(1) => 101
      end
    end
  end

  # This test shows the importance of patching globals in the module in which
  # they are defined. At least we get a warning.
  context("patch test1variable with another value in wrong module") do
    checkbeforeandafter(checkmodules1and2) do
      patch(testmodule2, :test1variable, 100) do
        @fact testmodule2.test1variable => 100 # This is all we have acheived
        @fact testmodule2.test1constmethod(1) => 8
        @fact testmodule2.test1constmethod(1,10) => 18
        @fact testmodule2.test1nonconstmethod(1) => 8
        @fact testmodule2.test1nonconstmethod(1,10) => 18
        @fact testmodule2.test1function(1) => 8
        @fact testmodule2.test1lambda(1) => 8
        checkmodule1()
      end
    end
  end

  context("patch test2lambda with a lambda") do
    checkbeforeandafter(checkmodule2) do
      patch(testmodule2, :test2lambda, x->200) do
        @fact testmodule2.test2lambda(1) => 200
        @fact testmodule2.test2lambda(2) => 200
        @fact testmodule2.test2lambda(3) => 200
      end
    end
  end

  context("patch test1lambda with a lambda") do
    checkbeforeandafter(checkmodules1and2) do
      patch(testmodule1, :test1lambda, x->200) do
        @fact testmodule2.test1lambda(1) => 200
        @fact testmodule2.test1lambda(2) => 200
        @fact testmodule2.test1lambda(3) => 200
      end
    end
  end

  context("patch test2function with a lambda") do
    checkbeforeandafter(checkmodule2) do
      patch(testmodule2, :test2function, x->200) do
        @fact testmodule2.test2function(1) => 200
        @fact testmodule2.test2function(2) => 200
        @fact testmodule2.test2function(3) => 200
      end
    end
  end

  context("patch test1function with a lambda") do
    checkbeforeandafter(checkmodules1and2) do
      patch(testmodule1, :test1function, x->200) do
        @fact testmodule2.test1function(1) => 200
        @fact testmodule2.test1function(2) => 200
        @fact testmodule2.test1function(3) => 200
      end
    end
  end

  context("patch test2nonconstmethod with a lambda") do
    checkbeforeandafter(checkmodule2) do
      patch(testmodule2, :test2nonconstmethod, x->200) do
        @fact testmodule2.test2nonconstmethod(1) => 200
        @fact testmodule2.test2nonconstmethod(2) => 200
        @fact testmodule2.test2nonconstmethod(3) => 200
        @fact_throws testmodule2.test2nonconstmethod(1,10)
      end
    end
  end

  context("patch test1nonconstmethod with a lambda") do
    checkbeforeandafter(checkmodules1and2) do
      patch(testmodule1, :test1nonconstmethod, x->200) do
        @fact testmodule2.test1nonconstmethod(1) => 200
        @fact testmodule2.test1nonconstmethod(2) => 200
        @fact testmodule2.test1nonconstmethod(3) => 200
        @fact_throws testmodule2.test1nonconstmethod(1,10)
      end
    end
  end

  context("patch test2constmethod with a lambda") do
    checkbeforeandafter(checkmodule2) do
      patch(testmodule2, :test2constmethod, x->200) do
        @fact testmodule2.test2constmethod(1) => 200
        @fact testmodule2.test2constmethod(2) => 200
        @fact testmodule2.test2constmethod(3) => 200
        @fact_throws testmodule2.test2constmethod(1,10)
      end
    end
  end

  context("patch test1constmethod with a lambda") do
    checkbeforeandafter(checkmodules1and2) do
      patch(testmodule1, :test1constmethod, x->200) do
        @fact testmodule2.test1constmethod(1) => 200
        @fact testmodule2.test1constmethod(2) => 200
        @fact testmodule2.test1constmethod(3) => 200
        @fact_throws testmodule2.test1constmethod(1,10)
      end
    end
  end

  # a method we will patch in over other methods for testing
  testmethod(x) = 200
  testmethod(x,y) = 400

  context("patch test2lambda with a method") do
    checkbeforeandafter(checkmodule2) do
      patch(testmodule2, :test2lambda, testmethod) do
        @fact testmodule2.test2lambda(1) => 200
        @fact testmodule2.test2lambda(2) => 200
        @fact testmodule2.test2lambda(1,10) => 400
        @fact testmodule2.test2lambda(2,10) => 400
      end
    end
  end

  context("patch test1lambda with a method") do
    checkbeforeandafter(checkmodules1and2) do
      patch(testmodule2, :test1lambda, testmethod) do
        @fact testmodule2.test1lambda(1) => 200
        @fact testmodule2.test1lambda(2) => 200
        @fact testmodule2.test1lambda(1,10) => 400
        @fact testmodule2.test1lambda(2,10) => 400
      end
    end
  end

  context("patch test2function with a method") do
    checkbeforeandafter(checkmodule2) do
      patch(testmodule2, :test2function, testmethod) do
        @fact testmodule2.test2function(1) => 200
        @fact testmodule2.test2function(2) => 200
        @fact testmodule2.test2function(1,10) => 400
        @fact testmodule2.test2function(2,10) => 400
      end
    end
  end

  context("patch test2nonconstmethod with a method") do
    checkbeforeandafter(checkmodule2) do
      patch(testmodule2, :test2nonconstmethod, testmethod) do
        @fact testmodule2.test2nonconstmethod(1) => 200
        @fact testmodule2.test2nonconstmethod(2) => 200
        @fact testmodule2.test2nonconstmethod(1,10) => 400
        @fact testmodule2.test2nonconstmethod(2,10) => 400
      end
    end
  end

  context("patch test1nonconstmethod with a method") do
    checkbeforeandafter(checkmodules1and2) do
      patch(testmodule2, :test1nonconstmethod, testmethod) do
        @fact testmodule2.test1nonconstmethod(1) => 200
        @fact testmodule2.test1nonconstmethod(2) => 200
        @fact testmodule2.test1nonconstmethod(1,10) => 400
        @fact testmodule2.test1nonconstmethod(2,10) => 400
      end
    end
  end

  context("patch test2constmethod with a method") do
    checkbeforeandafter(checkmodule2) do
      patch(testmodule2, :test2constmethod, testmethod) do
        @fact testmodule2.test2constmethod(1) => 200
        @fact testmodule2.test2constmethod(2) => 200
        @fact testmodule2.test2constmethod(1,10) => 400
        @fact testmodule2.test2constmethod(2,10) => 400
      end
    end
  end

  context("patch test1constmethod with a method") do
    checkbeforeandafter(checkmodules1and2) do
      patch(testmodule1, :test1constmethod, testmethod) do
        @fact testmodule2.test1constmethod(1) => 200
        @fact testmodule2.test1constmethod(2) => 200
        @fact testmodule2.test1constmethod(1,10) => 400
        @fact testmodule2.test1constmethod(2,10) => 400
      end
    end
  end

  context("patch test2lambda with a value") do
    checkbeforeandafter(checkmodule2) do
      patch(testmodule2, :test2lambda, 200) do
        @fact testmodule2.test2lambda => 200
      end
    end
  end

  context("patch test2function with a value") do
    checkbeforeandafter(checkmodule2) do
      patch(testmodule2, :test2function, 200) do
        @fact testmodule2.test2function => 200
      end
    end
  end

  context("patch test2nonconstmethod with a value") do
    checkbeforeandafter(checkmodule2) do
      patch(testmodule2, :test2nonconstmethod, 200) do
        @fact testmodule2.test2nonconstmethod => 200
      end
    end
  end

  context("patching test2constmethod with a value throws an error") do
    checkbeforeandafter(checkmodule2) do
      @fact_throws patch(testmodule2, :test2constmethod, 200) do
      end
    end
  end

  context("Ensure that the return value of the wrapped fn is always returned") do
    checkbeforeandafter(checkmodule2) do
      @fact patch(()->123, testmodule2, :test2variable, 100) => 123
      @fact patch(()->456, testmodule2, :test2constmethod, testmethod) => 456
      @fact patch(()->789, testmodule2, :test2nonconstmethod, testmethod) => 789
      @fact patch(()->123, testmodule2, :test2function, testmethod) => 123
      @fact patch(()->456, testmodule2, :test2lambda, testmethod) => 456

      @fact patch(()->789, testmodule2, :test2nonconstmethod, ()->200) => 789
      @fact patch(()->123, testmodule2, :test2function, ()->200) => 123
      @fact patch(()->456, testmodule2, :test2lambda, ()->200) => 456

      @fact patch(()->789, testmodule2, :test2nonconstmethod, 200) => 789
      @fact patch(()->123, testmodule2, :test2function, 200) => 123
      @fact patch(()->456, testmodule2, :test2lambda, 200) => 456
    end
  end

  context("patch a value in a nested module") do
    checkbeforeandafter(checkmodule2) do
      patch(testmodule2.nestedmodule, :value, 4000) do
        @fact testmodule2.nestedmodule.value => 4000
      end
    end
  end

  context("patch a method in a nested module") do
    checkbeforeandafter(checkmodule2) do
      patch(testmodule2.nestedmodule, :func, ()->1234) do
        @fact testmodule2.nestedmodule.func() => 1234
      end
    end
  end

  context("patch first value") do
    checkbeforeandafter(checkmodule2) do
      patch(testmodule2.lst, :value, 100) do
        @fact testmodule2.lst.value => 100
        @fact testmodule2.lst.next.value => 30
        @fact testmodule2.lst.next.next.value => 20
        @fact testmodule2.lst.next.next.next.value => 10
      end
    end
  end

  context("patch second value") do
    checkbeforeandafter(checkmodule2) do
      patch(testmodule2.lst.next, :value, 100) do
        @fact testmodule2.lst.value => 40
        @fact testmodule2.lst.next.value => 100
        @fact testmodule2.lst.next.next.value => 20
        @fact testmodule2.lst.next.next.next.value => 10
      end
    end
  end

  context("patch third value") do
    checkbeforeandafter(checkmodule2) do
      patch(testmodule2.lst.next.next, :value, 100) do
        @fact testmodule2.lst.value => 40
        @fact testmodule2.lst.next.value => 30
        @fact testmodule2.lst.next.next.value => 100
        @fact testmodule2.lst.next.next.next.value => 10
      end
    end
  end

  context("patch fourth value") do
    checkbeforeandafter(checkmodule2) do
      patch(testmodule2.lst.next.next.next, :value, 100) do
        @fact testmodule2.lst.value => 40
        @fact testmodule2.lst.next.value => 30
        @fact testmodule2.lst.next.next.value => 20
        @fact testmodule2.lst.next.next.next.value => 100
      end
    end
  end

  context("patch first value of mylist") do
    checkbeforeandafter(checkmylist) do
      patch(mylist, :value, 100) do
        @fact mylist.value => 100
        @fact mylist.next.value => 2
        @fact mylist.next.next.value => 3
        @fact mylist.next.next.next.value => 4
      end
    end
  end

  context("patch second value of mylist") do
    checkbeforeandafter(checkmylist) do
      patch(mylist.next, :value, 100) do
        @fact mylist.value => 1
        @fact mylist.next.value => 100
        @fact mylist.next.next.value => 3
        @fact mylist.next.next.next.value => 4
      end
    end
  end

  context("patch third value of mylist") do
    checkbeforeandafter(checkmylist) do
      patch(mylist.next.next, :value, 100) do
        @fact mylist.value => 1
        @fact mylist.next.value => 2
        @fact mylist.next.next.value => 100
        @fact mylist.next.next.next.value => 4
      end
    end
  end

  context("patch fourth value of mylist") do
    checkbeforeandafter(checkmylist) do
      patch(mylist.next.next.next, :value, 100) do
        @fact mylist.value => 1
        @fact mylist.next.value => 2
        @fact mylist.next.next.value => 3
        @fact mylist.next.next.next.value => 100
      end
    end
  end

  # A different list to use in tests
  const myotherlist = testmodule2.List([4,3,2,1])

  context("patch global variable") do
    checkbeforeandafter(checkmylist) do
      @patch(mylist, myotherlist) do
        @fact mylist.value => 4
        @fact mylist.next.value => 3
        @fact mylist.next.next.value => 2
        @fact mylist.next.next.next.value => 1
      end
    end
  end

  context("patch global variable and check the return value") do
    checkbeforeandafter(checkmylist) do
      const result = @patch(mylist, myotherlist) do
        mylist
      end
      @fact result => myotherlist
    end
  end

  context("patch constructor with a lambda") do
    checkbeforeandafter(checkmodule2) do
      patch(testmodule2, :List, (x,y,z) -> 100) do
        @fact_throws testmodule2.List(100)
        @fact_throws testmodule2.List(100, testmodule2.List(200))
        @fact_throws testmodule2.List([1, 2, 3])
        @fact testmodule2.List(1,2,3) => 100
        @fact typeof(testmodule2.List(1,2,3)) => not(testmodule2.List)
      end
    end
  end

  # A method to patch in as the List constructor
  mynewconstructor(x,y,z) = 100

  context("patch constructor with a method") do
    checkbeforeandafter(checkmodule2) do
      patch(testmodule2, :List, mynewconstructor) do
        @fact_throws testmodule2.List(100)
        @fact_throws testmodule2.List(100, testmodule2.List(200))
        @fact_throws testmodule2.List([1, 2, 3])
        @fact testmodule2.List(1,2,3) => 100
      end
    end
  end

end