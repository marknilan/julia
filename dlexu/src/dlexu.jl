#generic julia code module
include("../../jlib/jlib.jl")
include("./config.jl")
include("./structs.jl")
include("./gui.jl")


# mainline here
function dlexu()
    jlib.disptm("dlexu began at")
    println(ARGS[1])
    dlexucfg,dlexudates,dlexuencl = config.getTOML(ARGS[1])
    println("dlexuencl is $(dlexuencl)")
    println("dlexucfg logfile is $(dlexucfg)") 
    println("dlexudates is $(dlexudates) ")
    #t = gui.DlexUI()
end

dlexu()
