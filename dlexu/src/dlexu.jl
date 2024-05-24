#generic julia code module
include("../../jlib/jlib.jl")
include("./config.jl")
include("./instream.jl")
include("./structs.jl")
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
    sl = instream.score_proclivity(dlexucfg.logfile, tstpop, match_margin, dlexuencl)
    println("sl is $(sl)")
    #println("dlexuencl is $(dlexuencl)")
    #println("dlexucfg logfile is $(dlexucfg)") 
    #println("dlexudates is $(dlexudates) ")
    #t = gui.DlexUI()
end
#call it
dlexu()
