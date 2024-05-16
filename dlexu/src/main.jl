#generic julia code module
include("../../jlib/jlib.jl")
include("./config.jl")
include("./structs.jl")
include("./gui.jl")

function main()
    jlib.disptm("dlexu began at")
    println(ARGS[1])
    TomlParse = config.getTOML(ARGS[1])
    println("TomlParse is : $(TomlParse)")
    #t = gui.DlexUI()
end

main()
