#generic julia code module
include("../../jlib/jlib.jl")
include("./config.jl")
include("./structs.jl")
include("./gui.jl")

 using Genie, Genie.Renderer, Genie.Renderer.Html, Genie.Renderer.Json


function main()
    jlib.disptm("dlexu began at")
    if length(ARGS) < 1 
      
 

     route("/hello.html") do
       html("Hello World")
     end

     route("/hello.json") do
       json("Hello World")
     end

     route("/hello.txt") do
       respond("Hello World", :text)
     end

     up(8001, async = false)   
    else
       println(ARGS[1])
       dlexuTOML = config.getTOML(ARGS[1])
       println("dlexuTOML is : $(dlexuTOML)")
    end 
end