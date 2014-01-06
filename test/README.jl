module ReadmeTests

println("Running code from README.md")

include_string(open("README.md") do f
  join(filter(readlines(f)) do line
    (length(line)>0 && line[1]=='\t') || (length(line)>3 && line[1:4]=="    ")
  end, '\n')
end)

println("Done")

end