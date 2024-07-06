module outstream

include("../../jlib/jlib.jl")

using CSV
using DataFrames
#using Tables
#using DelimitedFiles
using Dates

function make_output(outv::Vector{String}, dlexucfg)::Bool

    outok = false
    # Create a filename with the timestamp
    fn = "$(dlexucfg.outdir)" * "$(jlib.determine_os())" * jlib.getfn(dlexucfg.logfile)
    ofile = "$(fn)_$(Dates.format(now(), "yyyy-mm-dd_HH-MM-SS")).csv"
    println("    Dlexu will write CSV output to $(ofile)")
    for line in outv
        try  
           out_array = split(line,";")
           println(out_array)
           CSV.write(
                 ofile,out_array,
                 writeheader=false,
                 append=true,
                 delim=dlexucfg.delimiter,
                 quotechar=only(dlexucfg.quotes),
                 quotestrings=true,
           )
        catch e
            println("error : $(e) \n Unable to write to CSV file $(ofile)")
            exit(8)
        end    
    end     
    #try
        #writedlm(ofile, outv, only(dlexucfg.delimiter))
    #    CSV.write(ofile, DataFrame(outv), delim=only(dlexucfg.delimiter))
    #    CSV.write(
    #        ofile,outv,
    #        #Tables.table(outv),
    ##        writeheader = false,
    #        append=true
     #       delim = dlexucfg.delimiter,
    #        quotechar = only(dlexucfg.quotes),
    #    )
        println("    CSV file created successfully")
        outok = true
    #catch e
    #    println("error : $(e) \n Unable to write to CSV file $(ofile)")
    #    exit(8)
    #end

    return outok

end

end # module
