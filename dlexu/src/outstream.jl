module outstream

include("../../jlib/jlib.jl")

using Dates

# creates the output stream from the program
function make_output(outv::Vector{String}, dlexucfg)::Bool

    # Create a filename with the timestamp
    fn = "$(dlexucfg.outdir)" * "$(jlib.determine_os())" * jlib.getfn(dlexucfg.logfile)
    ofile = "$(fn)_$(Dates.format(now(), "yyyy-mm-dd_HH-MM-SS")).csv"
    println("    Dlexu will write CSV output to $(ofile)")
    csvout::Any = nothing
    try
        csvout = open(ofile, "w")
    catch e
        println("error : $(e) \n Unable to write to open CSV file $(ofile) for output")
        exit(8)
    end
    if export_csv(csvout, dlexucfg, outv) == true
        close(csvout)
    else
        println("error : $(e) \n Unable to write to open CSV file $(ofile) for output")
        exit(8)
    end
    println("    CSV file created successfully")

    return true

end

# writes out modified log file to CSV
function export_csv(csvout, dlexucfg, outv)::Bool
    for line in outv
        outarray = split(line, dlexucfg.delimiter)
        for (i, col) in enumerate(outarray)
            if i == size(outarray)[1]
                outstr = dlexucfg.quotes * col * dlexucfg.quotes
            else
                outstr = dlexucfg.quotes * col * dlexucfg.quotes * dlexucfg.delimiter
            end
            print(csvout, outstr)
        end
        print(csvout, "\n")
    end
    return true
end

end # module
