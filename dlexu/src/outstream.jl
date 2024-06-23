module outstream

include("../../jlib/jlib.jl")

using CSV
using Tables
using Dates

function make_output(outv::Vector{String}, dlexucfg)::Bool

    outok = false
    # Create a filename with the timestamp
    fn = "$(dlexucfg.outdir)" * "$(jlib.determine_os())" * jlib.getfn(dlexucfg.logfile)
    ofile = "$(fn)_$(Dates.format(now(), "yyyy-mm-dd_HH-MM-SS")).csv"
    println("    Dlexu will write CSV output to $(ofile)")
    try
        CSV.write(
            ofile,
            Tables.table(outv),
            writeheader = false,
            delim = dlexucfg.delimiter,
        )
        println("    CSV file created successfully")
        outok = true
    catch e
        println("error : $(e) \n Unable to write to CSV file $(ofile)")
        exit(8)
    end

    return outok

end

end # module
