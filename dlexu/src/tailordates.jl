module tailordates

using Dates

# tries all data looking for values representing dates, converts dates to that
# given in the dlexu configuration TOML file
function convert_dates(invct::Vector{String}, dateprobs, dlexucfg)::Vector{String}

    outv::Vector{String} = []
    if length(dlexucfg.datefmt) > 0
        for s in invct
            strarray = split(s, dlexucfg.delimiter)
            idx = 0
            for column in strarray
                idx = idx + 1
                for i in eachindex(dateprobs)
                    try
                        df = DateFormat(dateprobs[i].date_template)
                        dt = Date(column, df)
                        strarray[idx] = Dates.format(dt, dlexucfg.datefmt)
                    catch
                        continue
                    end
                end
            end
            push!(outv, join(strarray,dlexucfg.delimiter))
        end
    end

    return outv
end

end # module
