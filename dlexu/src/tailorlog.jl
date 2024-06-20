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
            println("s WAS $(s)")            
            strarray =
                split(s, jlib.create_compound_delim(dlexucfg.inquote, dlexucfg.indelm))
            idx = 1    
            for strcol in strarray       
                for i in eachindex(enclprobs)
                    #println("strcol WAS $(strcol)")
                    st = findfirst(enclprobs[i].encl1,strcol)                    
                    #if st != nothing                    
                    #    println("at line $(line) $(enclprobs[i].encl1) st was $(st)")                        
                    #    before = strcol[1:st[1]-1]
                    #    println("before was $(before)")
                    #end    
                    nd = findlast(enclprobs[i].encl2,strcol)
                    #if nd != nothing                    
                    #    println("at line $(line) $(enclprobs[i].encl2) nd was $(nd)")                        
                    #    after = strcol[nd[1]+1:length(strcol)]
                    #    println("after was $(after)")
                    #end   
                    if st == nothing || nd == nothing
                        if idx < length(strarray)
                           strarray[idx] = strarray[idx] * dlexucfg.delimiter
                        end   
                        continue
                    else    
                       #middle = strcol[st[1]:nd[1]]
                       strcol = replace(strcol, enclprobs[i].encl1 => dlexucfg.delimiter)
                       strcol = replace(strcol, enclprobs[i].encl2 => dlexucfg.delimiter)
                       #println("strcol IS NOW $(strcol)")
                       #println("middle was $(middle)")
                    end   
                    #if length(before) > 0 && length(after) > 0
                    #    middle = strcol[st[1]:nd[1]]
                    #    println("middle was $(middle)")
                    #end                                     

                    #r1 = enclprobs[i].encl1
                    #println("r1 is $(r1)")
                    #r2 = enclprobs[i].encl2
                    #println("r2 is $(r2)")
                    #strcol = replace(strcol, r1 => dlexucfg.delimiter)
                    #strcol = replace(strcol, r2 => dlexucfg.delimiter)
                    #println("strcol is now $(strcol)")
                end    
                strarray[idx] = strcol
                #println("strarray[$(line)] IS NOW $(strarray[idx])")
                idx = idx + 1           
            end            
            line += 1
            s = join(strarray)
            println("s IS NOW $(s)")
        end
        close(lf)
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



end # module 
