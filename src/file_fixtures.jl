export temp_filename, temp_file, temp_dir, cleanup_path

@fixture function temp_filename(;extension::Union(String, Nothing)=nothing, create::Union(String,Bool)=false)
  const filename = "$(tempname())$(extension!=nothing ? ("."*extension) : "")"
  if create==false
    # Do nothing
  elseif create==true
    touch(filename)
  else
    open(filename, "w") do f
      write(f, create)
    end
  end
  yield_fixture(filename)

  if isdir(filename)
    run(`rm -fr $filename`)
  elseif ispath(filename)
    rm(filename)
  end
end


function temp_file(fn::Function; extension::Union(String, Nothing)=nothing, content::Union(String,Nothing)=nothing, mode::String="w")
  if content!=nothing
    return temp_filename((filename) -> open(fn, filename, mode), extension=extension, create=content)
  else
    return temp_filename((filename) -> open(fn, filename, mode), extension=extension)
  end
end

temp_dir(fn::Function) = temp_filename() do filename
  mkdir(filename)
  fn(filename)
end

@fixture function cleanup_path(path::String; ignore_missing=false)
  yield_fixture()
  if isdir(path)
    run(`rm -rf $path`)
  elseif ignore_missing==false || ispath(path)
    rm(path)
  end
end