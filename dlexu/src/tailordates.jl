module tailordates

include("./structs.jl")
using Dates

function convert_dates(outv::Vector{String},dateprobs,dlexucfg)::Vector{String}

   df = DateFormat("y-m-d");

   dt = Date("2015-01-01",df)



   for value in outv
       println(value)
   end 

   return outv
end	


end # module