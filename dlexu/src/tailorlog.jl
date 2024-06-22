module tailorlog

include("../../jlib/jlib.jl")

# read log apply changes tailor the string array (log lines)
function apply_log_chng(enclprobs, dlexucfg)::Vector{String}

    m = Dict()
    outv::Vector{String} = []
    for i in eachindex(enclprobs)
        m[enclprobs[i].encl1] = dlexucfg.delimiter
        m[enclprobs[i].encl2] = dlexucfg.delimiter
    end
    open(dlexucfg.logfile) do lf
        line = 0
        strcol = ""
        while !eof(lf)
            s = string(
                rstrip(
                    lstrip(strip(readline(lf)), collect(dlexucfg.inquote)),
                    collect(dlexucfg.inquote),
                ),
            )
            s = check_qte_delm(s, dlexucfg.quotes)
            s = check_qte_delm(s, dlexucfg.delimiter)
            println(s)
            strarray =
                split(s, jlib.create_compound_delim(dlexucfg.inquote, dlexucfg.indelm))
            idx = 1
            for strcol in strarray
                for i in eachindex(enclprobs)
                    st = findfirst(enclprobs[i].encl1, strcol)
                    nd = findlast(enclprobs[i].encl2, strcol)
                    if isnothing(st) || isnothing(nd)
                        if idx < length(strarray)
                            strarray[idx] = strarray[idx] * dlexucfg.delimiter
                        end
                        continue
                    else
                        strcol = replace(strcol, enclprobs[i].encl1 => dlexucfg.delimiter)
                        strcol = replace(strcol, enclprobs[i].encl2 => dlexucfg.delimiter)
                    end
                end
                if occursin(dlexucfg.delimiter) == true || idx == length(strarray)
                    strarray[idx] = strcol
                else
                    strarray[idx] = strcol * dlexucfg.delimiter
                end
                idx = idx + 1
            end
            line += 1
            push!(outv, join(strarray))
        end
        close(lf)
    end

    return outv
end

# removes multiple of the same char or string from a string

function check_qte_delm(s::String, srch::String)::String
    if occursin(srch, s) && length(srch) > 0 && !(srch == " ")
        s = replace(s, srch => "")
    end
    return s
end

end # module 
