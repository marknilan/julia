#generic julia code module
include("../../jlib/jlib.jl")
include("./config.jl")
include("./structs.jl")
include("./gui.jl")

function main()
    #jlib.disptm("dlexu began at")
    #println(ARGS[1])
    #dlexuTOML = config.getTOML(ARGS[1])
    #println("dlexuTOML is : $(dlexuTOML)")
    t = gui.DlexUI()
end

main()
