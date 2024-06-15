module tailorlog

include("../../jlib/jlib.jl")
include("./structs.jl")

# read log apply changes tailor the string array (log lines)
function apply_log_chng(enclprobs, dlexucfg)::Bool

    m = Dict()
    for i in eachindex(enclprobs)
        m[enclprobs[i].encl1] = dlexucfg.delimiter
        m[enclprobs[i].encl2] = dlexucfg.delimiter
    end
    open(dlexucfg.logfile) do f
        line = 0
        while !eof(f)
            s = string(
                rstrip(
                    lstrip(strip(readline(f)), collect(dlexucfg.inquote)),
                    collect(dlexucfg.inquote),
                ),
            )
            s = check_qte_delm(s, dlexucfg.quotes)
            s = check_qte_delm(s, dlexucfg.delimiter)
            strarray =
                split(s, jlib.create_compound_delim(dlexucfg.inquote, dlexucfg.indelm))
            for strcol in strarray
                holda = []
                for i in eachindex(enclprobs)
                    arr = delimited_array(
                        string(strcol),
                        enclprobs[i].encl1,
                        enclprobs[i].encl2,
                    )
                    if length(arr) > 0
                        println("length was $(length(arr)) arr was $(arr)")
                        push!(holda, arr)
                        strcol = replace(strcol, r"""$arr""" => "")
                        
                    end
                end
                println("holda is now $(holda)")
        
            end
      
            line += 1
        end
        close(f)
    end

    return true
end

# removes multiple of the same char or string from a string

function check_qte_delm(s::String, srch::String)::String
    if occursin(srch, s) && length(srch) > 0 && !(srch == " ")
        s = replace(s, srch => "")
    end
    return s
end

#returns an array of strings with enclosures removed

function delimited_array(str::String, encl1::String, encl2::String)::String

    arr = []
    occ = 1
    while true
        f = findnext(encl1, str, occ)
        l = findnext(encl2, str, occ)
        ds = ""
        if !(f == nothing) && !(l == nothing)
            ds = string(SubString(str, f[1] + 1, l[1] - 1))
            occ = l[1] + 1
            if length(ds) > 0
                push!(arr, ds)
            end
        else
            break
        end
    end

    if length(arr) > 0
       return arr[1]
    else
       return ""
    end      

end

end # module 
