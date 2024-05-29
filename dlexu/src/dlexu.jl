#generic julia code module
include("../../jlib/jlib.jl")
include("./config.jl")
include("./instream.jl")
include("./structs.jl")
include("./datefmt.jl")
include("./gui.jl")


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
    println("enclprobs is $(enclprobs)")
    datelookup = datefmt.make_datelookup(dlexudates)
    #println("datelookup is $(datelookup) ")
    dateprobs = datefmt.date_proclivity(dlexucfg.logfile,tstpop,match_margin,datelookup)
    println("dateprobs is $(dateprobs)")
    #t = gui.DlexUI()
end
#call it
dlexu()
