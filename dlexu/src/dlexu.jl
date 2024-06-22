#generic julia code module
include("../../jlib/jlib.jl")
include("./config.jl")
include("./instream.jl")
include("./structs.jl")
include("./datefmt.jl")
include("./gui.jl")
include("./tailorlog.jl")
include("./tailordates.jl")



const error_margin = 0.15
const maxobs = 5000
const match_margin = 0.15

# mainline here
function dlexu()
    jlib.disptm("    dlexu started")
    # configuration
    dlexucfg, dlexudates, dlexuencl = config.getTOML(ARGS[1])
    # check - do we need to sample the file based on the maximum observations?
    tstpop = instream.calc_test_population(dlexucfg.logfile, maxobs)
    enclprobs = instream.score_proclivity(dlexucfg.logfile, tstpop, match_margin, dlexuencl)
    #println("enclprobs is $(enclprobs)")
    datelookup = datefmt.make_datelookup(dlexudates)
    #println("datelookup is $(datelookup) ")
    dateprobs = datefmt.date_proclivity(dlexucfg.logfile,tstpop,match_margin,datelookup)
    #println("dateprobs is $(dateprobs)")
    # process log tailoring output to CSV
    outv = tailorlog.apply_log_chng(enclprobs,dlexucfg)
    outv = tailordates.convert_dates(outv,dateprobs,dlexucfg) 

    for value in outv
       println(value)
    end    

    #t = gui.DlexUI()
    jlib.disptm("    dlexu ended")
end
#call it
dlexu()
