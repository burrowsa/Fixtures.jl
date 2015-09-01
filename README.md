# Fixtures

Fixtures.jl provides fixtures, mocks, matchers and patching to improve your test life with Julia.

[![Build Status](https://travis-ci.org/burrowsa/Fixtures.jl.png?branch=master)](https://travis-ci.org/burrowsa/Fixtures.jl)[![codecov.io](http://codecov.io/github/invenia/Fixtures.jl/coverage.svg?branch=master)](http://codecov.io/github/invenia/Fixtures.jl?branch=master)

## An introduction to fixtures in Julia##

According to [wikipedia.org](http://en.wikipedia.org/wiki/Test_fixture#Software "wikipedia.org"):

>In software testing, a test fixture is a fixed state of the software under test used as a baseline for running tests; also known as the test context. It may also refer to the actions performed in order to bring the system into such a state.
>
Examples of fixtures:
- Loading a database with a specific, known set of data
- Erasing a hard disk and installing a known clean operating system installation
- Copying a specific known set of files
- Preparation of input data and set-up/creation of fake or mock objects

Practically, a test fixture is composed of one or more setup steps run before the test(s) and corresponding teardown step(s) performed afterwards. This kind of thing can be expressed rather nicely in Julia using the `do` syntax. Given a function like:

    function example_fixture(fn::Function)
        # Setup code goes here
        try
            return fn()
        finally
            # Teardown code goes here
        end
    end

You can write your tests like:

    example_fixture() do
        # Test code goes here
    end

There are a number of handy functions of this form, that we may wish to use as test fixtures, already defined in the Julia standard library, for example `Base.cd`.

## @fixture macro ##

Defining a fixture this way does involve a certain amount of boilerplate code so Fixtures.jl provides the `@fixture` macro to streamline fixture writing in Julia. The example above could be written, using `@fixture`, as:

    using Fixtures
    
    @fixture function example_fixture()
        # Setup code goes here
        yield_fixture()
    # Teardown code goes here
    end

and the calling code remains unchanged:

    example_fixture() do
        # Test code goes here
    end

## Fixture arguments and return values ##

It is very common for fixtures to take one or more arguments, for example:

    @fixture function greetings(who::String)
        println("Hello $who")
        yield_fixture()
        println("Good bye $who")
    end
    
    greetings("Bob") do
        println("Test code here")
    end

would produce the output:

> Hello Bob  
Test code here  
Good bye Bob  

`@fixture` supports all argument types, including default arguments, keyword arguments and varargs.

It is also rather common for fixtures to produce a value that needs to be used in the tests. For example a database fixture might  setup a test database then want to pass a connection object to the tests. This can easily be done by calling `yield_fixture` with the values to be returned to the test code. For example:


    @fixture function greetings(who::String)
        println("Hello $who")
        yield_fixture("Secret message for $who")
        println("Good bye $who")
    end
    
    greetings("Bob") do message
        println(message)
    end

would produce the output:

> Hello Bob  
Secret message for Bob  
Good bye Bob  

You can pass any number of values to the test code, however keyword arguments are not supported by `do` blocks so you can't use those.

## Fixture reuse ##

Often you want to resuse the same fixture several times, for example you might want the same setup and teardown code to run before and after each database test. Using Fixtures.jl you can add fixtures to a named scope then repeatedly use that named scope:

    @fixture function testdb()
        # setup database
        yield_fixture()
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

    function demo(fn::Function)
        println("before")
        try
            return fn()
        finally
            println("after")
        end
    end

    function another(fn::Function)
        println("avant")
        try
            return fn()
        finally
            println("après")
        end
    end

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

the output is:

> before  
avant  
hello world  
après  
after  
before  
Bonjour tout le monde  
after

You can add fixtures that take arguments by specifying the arguments in the call to `add_fixture`:

    add_fixture(:some_scope, greetings, "Bob")

positional, default, vararg and keyword arguments are supported. Also if you want to capture the values produced by the fixture you must give it a name:

    add_fixture(:some_scope, :greet_bob, greetings, "Bob")

and then setting `fixture_values=true` when calling `apply_fixtures` makes all the fixture outputs available to the test code via a `Dict` passed to the `do` which is indexed by fixture name:

    apply_fixtures(:some_scope, fixture_values=true) do values
        println(values[:greet_bob])
    end

Output is still:

> Hello Bob  
Secret message for Bob  
Good bye Bob  

## Simple Fixtures ##

Fixtures.jl has a handy `add_simple_fixture` method that lets you define the setup and teardown functions separately:

`function add_fixture(scope::Symbol, before::Function, after::Function)`

## FactCheck.jl support ##

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

All the features listed in the sections above are available when using FactCheck.jl

## File fixtures ##

Fixtures.jl comes with a number of fixtures for using files in your tests:

- `temp_filename([extension=<filename extension>],[create=<true, false or string content>])`
- `temp_file([mode=<file mode, default is "w">],[extension=<filename extension>],[content=<string content>])`
- `temp_dir()`
- `cleanup_path(<path>[, ignore_missing=true|false])`

## Patching ##

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

## Mocks ##

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

## Matchers ##
    
`ANYTHING` is just one example of a matcher, a kind of wildcard that can be used when verifying mock calls. Fixtures.jl provides the following matchers (and it is possible to define your own):

* `anything_of_type(T::Type)`
* `anything_in(value::Any)`
* `anything_containing(value::Any)`

So we could be a bit stricter in our previous example:

    mock1 = mock()
    mock1(rand(), 200)
    
    @Test.test calls(mock1) == [ call(anything_of_type(Number), 200) ]
