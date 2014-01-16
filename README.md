# Fixtures

Fixtures, mocks and patching to improve your test life with Julia.

[![Build Status](https://travis-ci.org/burrowsa/Fixtures.jl.png?branch=master)](https://travis-ci.org/burrowsa/Fixtures.jl)

Using Fixtures.jl you can define a fixture such that some setup code is called before your test code and some teardown code is called afterwards. Here is the simplest example:

    using Fixtures

    function demo(fn::Function)
        println("before")
        try
            return fn()
        finally
            println("after")
        end
    end
    
    demo() do
        println("hello world")
    end
    
and it produces this output:

> before  
hello world  
after

you can use more than one fixture at a time:

    function another(fn::Function)
        println("avant")
        try
            return fn()
        finally
            println("après")
        end
    end
    
    demo() do
        another() do
            println("hello world")
        end
    end

The good thing about defining fixtures of this form is that other functions like them already exist in the Julia Standard Library and other libraries, for example `Base.cd()` and they can be used with Fixture.jl too.

To simplify creating fixture functions Fixtures.jl provides the `@fixture` macro. The `demo()` fixture above can be written:

    @fixture function demo()
        println("before")
        @>>>
        println("after")
    end
    
    demo() do
        println("hello world")
    end

The `@>>>` symbol divides the setup code from the teardown code. Of course, fixtures like this can take arguments too:

    @fixture function personal_greeting(name)
        println("Hello $name")
        @>>>
        println("Good bye $name")
    end
    
    personal_greeting("John") do
      println("...")
    end

often you want to resuse the same fixture several times, for example you might want the same setup and teardown code to run before and after each database test. Using Fixtures.jl you can add fixtures to a named scope then repeatedly use that named scope:

    @fixture function testdb()
        # setup database
        @>>>
        # teardown database
    end

    add_fixture(:databasetests, testdb)
    
    apply_fixtures(:databasetests) do
        # some test that uses the database
    end
    
    apply_fixtures(:databasetests) do
        # another test that uses the database
    end

You can define multiple fixtures for a named scope and they will all be used.

    @fixture function fixture1()
      # ...
    end
    
    @fixture function fixture2()
      # ...
    end
    
    @fixture function fixture3()
      # ...
    end

    add_fixture(:myscope, fixture1)
    add_fixture(:myscope, fixture2)
    add_fixture(:myscope, fixture3)

You can also nest scopes. If a fixture is added to a nested scope then it will be removed at the end of the parent scope. An example should make this clearer:

    add_fixture(:childscope, demo)
    
    apply_fixtures(:parentscope) do
        add_fixture(:childscope, another)
        apply_fixtures(:childscope) do
            println("hello world")
        end
    end
    
    apply_fixtures(:childscope) do
        println("Bonjour tout le monde")
    end

using `demo()` and `another()` as defined above, the output is:

> before  
avant  
hello world  
après  
after  
before  
Bonjour tout le monde  
after

There is also a handy `add_fixture` method that lets you define the setup and teardown functions separately:

`function add_fixture(scope::Symbol, before::Function, after::Function)`

For users of FactCheck.jl methods are provided to make it simple to use Fixtures.jl, here is an example using the two packages together:

    using FactCheck
    using Fixtures
    
    add_fixture(:facts, demo)
    add_fixture(:context, another)
     
    facts("FactCheck support tests", using_fixtures) do
        context("Example with fixtures set on a context level", using_fixtures) do
            @fact 100 => 100
        end
    end

A common type of fixture is to patch a function, method or value within a module or object. This is most often done in unit testing to isolate the function under test from the rest of the system. Fixtures.jl provides a patch fixture to do this. For example if we wanted to test this function:

    function firstline(filename)
        f = open(filename)
        try
            return chomp(readlines(f)[1])
        finally
            close(f)
        end
    end

we might want to isolate it from the real filesystem. We can do this by patching `Base.open` with our own implementation, just for the duration of the test:

    function fake_open(filename)
        return IOBuffer("Hello Julia\nGoodbye Julia")
    end
    
    patch(Base, :open, fake_open) do
        @Test.test firstline("foobar.txt") == "Hello Julia"
    end

You can use `patch()` as above or you can use it with `add_fixture()` and `apply_fixtures()`.

    add_fixture(:mock_io, patch, Base, :open, fake_open)
    
    apply_fixtures(:mock_io) do
        @Test.test firstline("foobar.txt") == "Hello Julia"
    end
    
> **Note:** Due to a current [issue](https://github.com/JuliaLang/julia/issues/265) in Julia your ability to patch a function may be limited if the code calling that function has already been called.

But Fixtures.jl also provides mocks so we can patch `open` with a mock, this also allows us to verify it was called:
    
    function firstline(filename)
        f = open(filename)
        try
            return chomp(readlines(f)[1])
        finally
            close(f)
        end
    end

    mock_open = mock(return_value=IOBuffer("Hello Julia\nGoodbye Julia"))

    patch(Base, :open, mock_open) do
      @Test.test firstline("foobar.txt") == "Hello Julia"
    end

    @Test.test calls(mock_open) == [call("foobar.txt")]
    
Mocks are just generated functions that record their arguments everytime they are called. You can access the call history using `calls(mock)` as shown above and clear it with `reset(mock)`. When creating a mock you can (optionally) specify its return value or an implementation for the mock:

    mock1 = mock(return_value=200)
    @Test.test mock1(100) == 200
    
    mock2 = mock(side_effect=x->x+200)
    @Test.test mock2(100) == 300
    
    mock3 = mock()
    @Test.test mock3(100) == nothing
    
The `call()` function makes it easy to express and test the expected calls to a mock (see above). And you can ignore any given argument by using `ANYTHING`

    mock1 = mock()
    mock1(rand(), 200)
    
    @Test.test calls(mock1) == [ call(ANYTHING, 200) ]
    
`ANYTHING` is just one example of a matcher, a kind of wildcard that can be used when verifying mock calls. Fixtures.jl provides the following matchers (and it is possible to define your own):

* `anything_of_type(T::Type)`
* `anything_in(value::Any)`
* `anything_containing(value::Any)`

So we could be a bit stricter in our previous example:

    mock1 = mock()
    mock1(rand(), 200)
    
    @Test.test calls(mock1) == [ call(anything_of_type(Number), 200) ]