# Fixtures

Fixtures and patching to improve your test life with Julia

[![Build Status](https://travis-ci.org/burrowsa/Fixtures.jl.png?branch=master)](https://travis-ci.org/burrowsa/Fixtures.jl)

Using Fixtures.jl you can define a fixture such that some setup code is called before your test code and some teardown code is called afterwards. Here is the simplest example:

    using Fixtures

    function demo()
        println("before")
        produce()
        println("after")
    end
    
    fixture(demo) do
        println("hello world")
    end
    
and it produces this output:

    before
    hello world
    after

you can use more than one fixture at a time:

    function another()
        println("avant")
        produce()
        println("après")
    end
    
    fixture(demo, another) do
        println("hello world")
    end

often you want to resuse the same fixture several times, for example you might want the same setup and teardown code to run before and after each database test. Using Fixtures.jl you can add fixtures to a named scope then repeatedly use that named scope:

    function testdb()
        # setup database
        produce()
        # teardown database
    end

    add_fixture(testdb, :databasetests)
    
    apply_fixtures(:databasetests) do
        # some test that uses the database
    end
    
    apply_fixtures(:databasetests) do
        # another test that uses the database
    end

You can define multiple fixtures for a named scope and they will all be used.

    add_fixture(fixture1, :myscope)
    add_fixture(fixture2, :myscope)
    add_fixture(fixture3, :myscope)

You can also nest scopes. If a fixture is added to a nested scope then it will be removed at the end of the parent scope. An example should make this clearer:

    add_fixture(demo, :childscope)
    
    apply_fixtures(:parentscope) do
        add_fixture(another, :childscope)
        apply_fixtures(:childscope) do
            println("hello world")
        end
    end
    
    println(">>>>>>>>>>")
    
    apply_fixtures(:childscope) do
        println("Bonjour tout le monde")
    end

using `demo()` and `another()` as defined above, the output is:

    before
    avant
    hello world
    après
    after
    >>>>>>>>>>
    before
    Bonjour tout le monde
    after

There is also a handy `add_fixture` method that lets you define the setup and teardown functions separately:

    function add_fixture(before::Function, after::Function, scope::Symbol)

For users of FactCheck.jl methods are provided to make it simple to use Fixtures.jl, here is an example using the two packages together:

    using FactCheck
    using Fixtures
    
    add_fixture(demo, :facts)
    add_fixture(another, :context)
     
    facts("FactCheck support tests", using_fixtures) do
        context("Example with fixtures set on a context level", using_fixtures) do
            @fact 100 => 100
        end
    end

A common type of fixture is to patch a function, method or value within a module or object. This is most often done in unit testing to isolate the function under test from the rest of the system. Fixtures.jl provides a patch fixture to do this. For example if we wanted to test this function:

    function firstline(filename)
        open(filename) do f
            return chomp(readlines(f)[1])
        end
    end

we might want to isolate it from the real filesystem. We can do this by patching Base.open with our own implementation, just for the duration of the test:

    function fake_open(fn, filename)
        return fn(IOBuffer("Hello Julia\nGoodbye Julia"))
    end
    
    patch(Base, :open, fake_open) do
        @test firstline("foobar.txt") == "Hello Julia"
    end

You can use `patch()` as above or you can use it with `fixture()`, `add_fixture()`, `apply_fixtures()` etc.

    add_fixture(patch(Base, :open, fake_open), :mock_io)
    
    apply_fixtures(:mock_io) do
        @test firstline("foobar.txt") == "Hello Julia"
    end
