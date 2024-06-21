module tailordates

include("./structs.jl")
using Dates

function convert_dates(outv::Vector{String},dateprobs,dlexucfg)::Vector{String}

   df = DateFormat("y-m-d");

   dt = Date("2015-01-01",df)

   for s in outv
       strarray = split(s, dlexucfg.delimiter)
       for column in strarray    
          for i in eachindex(dateprobs) 
              println("date template is $(dateprobs[i].date_template)")
              df = DateFormat("$(dateprobs[i].date_template)");
              try 
                 dt = Date(column,df)
                 println("dt is $(dt)")
              catch
                 continue 
              end
             
              
          end
       end     
   end   
    

   for value in outv
       println(value)
   end 

   return outv
end	


end # module