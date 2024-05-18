#generic julia code module
include("../../jlib/jlib.jl")
include("./config.jl")
include("./instream.jl")
include("./structs.jl")
include("./gui.jl")


const error_margin = 0.15
const samplesize = 5000
const match_margin = 0.15

# mainline here
function dlexu()
    jlib.disptm("dlexu began at")
    println(ARGS[1])
    # configuration
    dlexucfg,dlexudates,dlexuencl = config.getTOML(ARGS[1])
    # check - do we need to sample the file? based on the constant samplesize
    tstpop = instream.get_tstpop(dlexucfg.logfile, samplesize, error_margin) 
    println("tstpop is $(tstpop)")
    sl = instream.snifflines(dlexucfg.logfile,tstpop)
    println("sl is $(sl)")
    #println("dlexuencl is $(dlexuencl)")
    #println("dlexucfg logfile is $(dlexucfg)") 
    #println("dlexudates is $(dlexudates) ")
    #t = gui.DlexUI()
end

dlexu()
