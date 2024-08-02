# part of the Startup module

# deals with instream operations for the log file being processed

include("../../jlib/jlib.jl")
include("./ui.jl")
include("./structs.jl")

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

# displays configuration of the program at the command line level
function dispcfg(dlexucfg):Bool

    println("\n  Dlexu will...")
    println("   == Process Log File   : $(dlexucfg.logfile)")
    println("   ==     Of File Type   : $(dlexucfg.infiletype)")
    println(
        "       ==      Considering   : $(dlexucfg.indelm) as the incoming data delimiter",
    )
    println(
        "       ==    Expecting   : $(dlexucfg.inquote) quoted values in the incoming data rows",
    )
    println("       ==")
    println("\n  Dlexu will then...")
    println("       ==  Push Files To : $(dlexucfg.outdir) directory")
    println("       == With Delimiter : $(dlexucfg.delimiter)")
    println(
        "       ==      Quoted As : $(dlexucfg.quotes) values in the data columns output",
    )
    println("       ==    Date format : $(dlexucfg.datefmt) for any date column output")
    println("       ==")
    println("\n Dlexu now calculating enclosure probabilities on the incoming log file...")
    return true
end
