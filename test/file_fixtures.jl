module FileFixturesTests

using Fixtures
using FactCheck


const TEMPDIR = tempdir()
const TEMPDIR_LEN = length(TEMPDIR)


facts("FileFixtures tests") do
  context("temporary filename") do
    temp_filename() do filename
      @fact filename[1:TEMPDIR_LEN] => TEMPDIR
      @fact ispath(filename) => false
      touch(filename)
      @fact isfile(filename) => true
      global remembered_filename = filename
    end
    @fact ispath(remembered_filename) => false
  end

  context("temporary filename turned into directory") do
    temp_filename() do filename
      @fact filename[1:TEMPDIR_LEN] => TEMPDIR
      @fact ispath(filename) => false
      mkdir(filename)
      @fact isdir(filename) => true
      global remembered_filename = filename
    end
    @fact ispath(remembered_filename) => false
  end

  context("temporary filename never created") do
    temp_filename() do filename
      @fact filename[1:TEMPDIR_LEN] => TEMPDIR
      @fact ispath(filename) => false
    end
    @fact ispath(remembered_filename) => false
  end

  context("temporary filename with extension") do
    temp_filename(extension="csv") do filename
      @fact filename[1:TEMPDIR_LEN] => TEMPDIR
      @fact filename[end-2:] => "csv"
      @fact ispath(filename) => false
      touch(filename)
      @fact isfile(filename) => true
      global remembered_filename = filename
    end
    @fact ispath(remembered_filename) => false
  end

  context("temporary filename with create") do
    temp_filename(create=true) do filename
      @fact filename[1:TEMPDIR_LEN] => TEMPDIR
      @fact isfile(filename) => true
      open(filename) do f
        @fact readlines(f) => []
      end
      global remembered_filename = filename
    end
    @fact ispath(remembered_filename) => false
  end

  context("temporary filename with create from content") do
    const mycontent = "Hello World"
    temp_filename(create=mycontent) do filename
      @fact filename[1:TEMPDIR_LEN] => TEMPDIR
      @fact isfile(filename) => true
      open(filename) do f
        @fact readlines(f) => [mycontent]
      end
      global remembered_filename = filename
    end
    @fact ispath(remembered_filename) => false
  end

  context("temporary file for output") do
    temp_file() do file
      write(file, "hello world")
      const filename = file.name[7:end-1]
      @fact filename[1:TEMPDIR_LEN] => TEMPDIR
      @fact isfile(filename) => true
      global remembered_filename = filename
    end
    @fact ispath(remembered_filename) => false
  end

  context("temporary file for input") do
    const mycontent = "Hello World"
    temp_file(content=mycontent, mode="r") do file
      @fact readlines(file) => [mycontent]
      const filename = file.name[7:end-1]
      @fact filename[1:TEMPDIR_LEN] => TEMPDIR
      @fact isfile(filename) => true
      global remembered_filename = filename
    end
    @fact ispath(remembered_filename) => false
  end

  context("temporary directory") do
    temp_dir() do dirname
      @fact dirname[1:TEMPDIR_LEN] => TEMPDIR
      @fact isdir(dirname) => true
      global remembered_dirname = dirname
    end
    @fact ispath(remembered_dirname) => false
  end


  context("cleanup_path file") do
    const filename = tempname()
    cleanup_path(filename) do
      @fact ispath(filename) => false
      touch(filename)
      @fact isfile(filename) => true
    end
    @fact ispath(filename) => false
  end

  context("cleanup_path directory") do
    const filename = tempname()
    cleanup_path(filename) do
      @fact ispath(filename) => false
      mkdir(filename)
      @fact isdir(filename) => true
    end
    @fact ispath(filename) => false
  end

  context("cleanup_path missing (ignored)") do
    const filename = tempname()
    cleanup_path(filename, ignore_missing=true) do
      @fact ispath(filename) => false
    end
    @fact ispath(filename) => false
  end

  context("cleanup_path missing (not ignored)") do
    const filename = tempname()
    @fact_throws cleanup_path(filename) do
      @fact ispath(filename) => false
    end
  end
end

end