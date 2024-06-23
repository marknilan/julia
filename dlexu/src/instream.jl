# part of the Startup module

# deals with instream operations for the log file being processed

include("../../jlib/jlib.jl")
include("./gui.jl")

#determines the test population to use for file sampling
function calc_test_population(logfile::String, maxobs::Int64)

    # check the file processing timing - how big is it, how many rows?
    @time jlib.guagefile(logfile)
    l, t = jlib.fcount(logfile)
    # create a test population ONLY IF the l (count) above is greater than the static
    # sample size (constant) set above in the mainline. Else just use the record count
    if l > maxobs
        tstpop = trunc(Int, l / (1 + (l * error_margin^2))) * 1000
        println("\n    Using sample population : $(tstpop)")
    else
        tstpop = l - 1
        println("\n    Using whole file as sample population : $(tstpop)")
    end

    return tstpop

end

