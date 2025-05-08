using CSV, DataFrames

function readCV(filename::AbstractString)
    lines = readlines(filename)
    curveindex = Int64[]
    curves = DataFrame[]
    for l in eachindex(lines)
        if length(lines[l]) < 5 continue end
        if lines[l][1:5]=="CURVE"
            push!(curveindex, l)
        end
        if lines[l]==last(lines)
            push!(curveindex, l+1)
        end
    end

    for l in eachindex(curveindex)
        line = curveindex[l]
        if line==last(curveindex) break end
        next = curveindex[l+1]
        push!(
              curves,
              CSV.read(
                       filename,
                       header=line+1,
                       skipto=line+3,
                       limit=(next-1) - (line+3),
                       delim='\t',
                       ignorerepeated=true,
                       DataFrame
                      )
             )
    end
    return(curves)
end
