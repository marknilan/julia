module tailorlog

include("../../jlib/jlib.jl")
include("./structs.jl")

     # read log apply changes tailor the string array (log lines)
     function apply_log_chng(enclprobs, dlexucfg)::Bool

         println(enclprobs)
         open(dlexucfg.logfile) do f
            line = 0  
            while ! eof(f)   
               s = readline(f)          
               line += 1
               println("$line . $s")
               for i in eachindex(enclprobs)
                   println(enclprobs[i].encl1)
               end
            end
            close(f)
         end

          
         return true
     end 
end