#generic julia code module
include("../../jlib/jlib.jl")

include("./structs.jl")
include("./startup.jl")
include("./probability.jl")
include("./gui.jl")
include("./tailor.jl")
include("./outstream.jl")

const error_margin = 0.15
const maxobs = 5000
const match_margin = 0.15

# mainline here
function dlexu()
     
    #gui.display_message("DLEXU the Devops Log eXtract Utility")
    jlib.disptm("    dlexu started")
    # configuration
    dlexucfg, dlexudates, dlexuencl = Startup.getTOML(ARGS[1])
    datelookup = Startup.make_datelookup(dlexudates)
    gui.DlexUI(dlexucfg)
    # check - do we need to sample the file based on the maximum observations?
    tstpop = Startup.calc_test_population(dlexucfg.logfile, maxobs)
    enclprobs = Probability.encl_proclivity(dlexucfg.logfile, tstpop, match_margin, dlexuencl)
    #println("enclprobs is $(enclprobs)")
    dateprobs = Probability.date_proclivity(dlexucfg.logfile, tstpop, match_margin, datelookup)
    #println("dateprobs is $(dateprobs)")
    # process log tailoring output to CSV
    outv = Tailor.apply_log_chng(enclprobs, dlexucfg)
    outv = Tailor.convert_dates(outv, dateprobs, dlexucfg)
    # output to logfile name timestamped CSV file in outdir directory
    outstream.make_output(outv, dlexucfg)
    jlib.disptm("    dlexu ended")
end
#call it
dlexu()
