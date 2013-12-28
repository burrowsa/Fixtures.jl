using Fixtures
using FactCheck


# Our fixture test suite
facts("Fixture tests") do

  context("A 1-part-function fixture") do
    global x = 0

    function changex()
      global x = 100
    end

    @fact x => 0
    fixture(changex) do
      @fact x => 100
    end
    @fact x => 100
  end

  context("A 2-part-function fixture") do
    global x = 0

    function changex()
      global x = 100
      produce()
      global x = 200
    end

    @fact x => 0
    fixture(changex) do
      @fact x => 100
    end
    @fact x => 200
  end

  context("A 3-part-function fixture") do
    global x = 0

    function changex()
      global x = 100
      produce()
      global x = 200
      produce()
      global x = 300
    end

    @fact x => 0
    @fact_throws fixture(changex) do
      @fact x => 100
    end
    @fact x => 200
  end

  context("combine two 2-part-function fixtures") do
    global x = 0
    global y = 0

    function changex()
      global x = 100
      produce()
      global x = 200
    end

    function changey()
      global y = 100
      produce()
      global y = 200
    end

    @fact x => 0
    @fact y => 0
    fixture(changex, changey) do
      @fact x => 100
      @fact y => 100
    end
    @fact x => 200
    @fact y => 200
  end

  context("combine two 2-part-function fixtures check order") do
    global x = ""

    function appenda()
      global x = x*"a"
      produce()
      global x = x*"A"
    end

    function appendb()
      global x = x*"b"
      produce()
      global x = x*"B"
    end

    @fact x => ""
    fixture(appenda, appendb) do
      @fact x => "ab"
    end
    @fact x => "abBA"
  end

  context("combine 1-part-function and 2-part-function fixtures") do
    global x = 0
    global y = 0

    function changex()
      global x = 100
    end

    function changey()
      global y = 100
      produce()
      global y = 200
    end

    @fact x => 0
    @fact y => 0
    fixture(changex, changey) do
      @fact x => 100
      @fact y => 100
    end
    @fact x => 100
    @fact y => 200
  end

  context("combine 2-part-function and 3-part-function fixtures") do
    global x = 0
    global y = 0

    function changex()
      global x = 100
      produce()
      global x = 200
      produce()
      global x = 300
    end

    function changey()
      global y = 100
      produce()
      global y = 200
    end

    @fact x => 0
    @fact y => 0
    @fact_throws fixture(changex, changey) do
      @fact x => 100
      @fact y => 100
    end
    @fact x => 200
    @fact y => 200
  end

end