module MockTests

using Fixtures
using FactCheck


facts("Mock tests") do
  context("Can make, call and inspect and reset a mock") do
    my_mock = mock()

    @fact calls(my_mock) => []

    result = my_mock()

    @fact result => nothing

    @fact calls(my_mock) => [call()]

    reset(my_mock)

    @fact calls(my_mock) => []
  end

  context("Multiple calls") do
    my_mock = mock()

    @fact calls(my_mock) => []

    result = my_mock()

    @fact result => nothing

    @fact calls(my_mock) => [call()]

    result = my_mock()

    @fact result => nothing

    @fact calls(my_mock) => [call(), call()]

    result = my_mock()

    @fact result => nothing

    @fact calls(my_mock) => [call(), call(), call()]

    reset(my_mock)

    @fact calls(my_mock) => []
  end

  context("Can specify a return value") do
    my_mock = mock(return_value=12)
    @fact my_mock() => 12
  end

  context("Can specify a side effect") do
    my_mock = mock(side_effect=() -> 123456)
    @fact my_mock() => 123456
  end

  context("If you specify a side effect and a return value the side effect wins") do
    my_mock = mock(return_value=12, side_effect=() -> 123456)
    @fact my_mock() => 123456
  end

  context("Passing an argument to a mock") do
    my_mock = mock()

    @fact calls(my_mock) => []

    result = my_mock(100)

    @fact result => nothing

    @fact calls(my_mock) => [call(100)]

    result = my_mock(200)

    @fact result => nothing

    @fact calls(my_mock) => [call(100), call(200)]

    reset(my_mock)

    @fact calls(my_mock) => []
  end

  context("Passing a named argument to a mock") do
    my_mock = mock()

    @fact calls(my_mock) => []

    result = my_mock(thingy=100)

    @fact result => nothing

    @fact calls(my_mock) => [call(thingy=100)]

    result = my_mock(whatnot=200)

    @fact result => nothing

    @fact calls(my_mock) => [call(thingy=100), call(whatnot=200)]

    reset(my_mock)

    @fact calls(my_mock) => []
  end

  context("Passing named and unnamed arguments to a mock") do
    my_mock = mock()

    @fact calls(my_mock) => []

    result = my_mock(1,2,3,thingy=100)

    @fact result => nothing

    @fact calls(my_mock) => [call(1,2,3,thingy=100)]

    result = my_mock(4,6, whatnot=200, doodah=300)

    @fact result => nothing

    @fact calls(my_mock) => [call(1,2,3,thingy=100), call(4,6, whatnot=200, doodah=300)]

    reset(my_mock)

    @fact calls(my_mock) => []
  end

  context("Order of named arguments matters") do
    @fact call(foo=1, bar=2) => not(call(bar=2, foo=1))

    # But the position of the unamed arguments reletive to the named ones does not
    @fact call(0, foo=1, bar=2) => call(foo=1, 0, bar=2)
    @fact call(0, foo=1, bar=2) => call(foo=1, bar=2, 0)
  end

  context("Calling one mock doesn't effect the other(s)") do
    mock1 = mock()
    mock2 = mock()
    mock3 = mock()

    @fact calls(mock1) => []
    @fact calls(mock2) => []
    @fact calls(mock3) => []

    @fact mock1(100) => nothing

    @fact calls(mock1) => [call(100)]
    @fact calls(mock2) => []
    @fact calls(mock3) => []

    @fact mock1(200) => nothing

    @fact calls(mock1) => [call(100), call(200)]
    @fact calls(mock2) => []
    @fact calls(mock3) => []
  end

  context("Resetting one mock doesn't effect the other(s)") do
    mock1 = mock()
    mock2 = mock()
    mock3 = mock()

    @fact calls(mock1) => []
    @fact calls(mock2) => []
    @fact calls(mock3) => []

    @fact mock1(100) => nothing
    @fact mock2(200) => nothing
    @fact mock3(300) => nothing

    @fact mock1(400) => nothing
    @fact mock2(500) => nothing
    @fact mock3(600) => nothing

    @fact calls(mock1) => [call(100), call(400)]
    @fact calls(mock2) => [call(200), call(500)]
    @fact calls(mock3) => [call(300), call(600)]

    reset(mock1)

    @fact calls(mock1) => []
    @fact calls(mock2) => [call(200), call(500)]
    @fact calls(mock3) => [call(300), call(600)]
  end

  context("ANY matches anything") do
    @fact ANY => ANY
    @fact 100 => ANY
    @fact ANY => 100
    @fact "hello" => ANY
    @fact ANY => "hello"
    @fact [] => ANY
    @fact ANY => []
    @fact [100] => ANY
    @fact ANY => [100]
  end

  context("Using ANY with a mock") do
    my_mock = mock()
    @fact my_mock(100) => nothing
    @fact calls(my_mock) => [call(ANY)]
  end
end

end