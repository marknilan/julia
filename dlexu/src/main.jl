#generic julia code module
include("../../jlib/jlib.jl")
include("./config.jl")
include("./structs.jl")
include("./gui.jl")


using Mousetrap

main() do app::Application
    jlib.disptm("dlexu began at")
    if length(ARGS) < 1 
       window = gui.DlexUI(app)   
       present!(window)
    else
       println(ARGS[1])
       dlexuTOML = config.getTOML(ARGS[1])
       println("dlexuTOML is : $(dlexuTOML)")
    end 
end