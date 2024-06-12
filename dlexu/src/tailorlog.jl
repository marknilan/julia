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
            while ! eof(f)   
               s = readline(f)
               println("Line  Before $line . $s")   
               #result = join!([m[c] for c in s])
               #result = join([compliments[c] for c in str])
               #println("Result is $result")
               for (key, value) in m
                   s = replace(s,key=>value) 
               end
               line += 1
               println("Line  After $line . $s")
            end
            close(f)
         end

         return true
     end 
end