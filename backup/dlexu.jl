# this is the mainline program of rlexu

#generic julia code module
include("../jlib/jlib.jl")

#rlexu modules
include("./rlexustructs.jl")
include("./config.jl")
include("./gui.jl")

using .config
using .rlexustructs
using .jlib
using mousetrap 

using StructTypes
using ArgParse
using Printf
using DataFrames
using Match
using JSON3
using StringDistances
using Blink
using mousetrap

#Package examples dont delete
#    # import Pkg; Pkg.add("JSON3")
#    Pkg.add(url="https://github.com/sylvaticus/LAJuliaUtils.jl.git")    
#maintenance
#using Pkg
#Pkg.update()
#Pkg.status()
#Pkg.rm("PackageName")
#cleanup
#Pkg.gc()


#---------------------------------------- MAINLINE --------------------------------------

#acknowledging this link for dates https://en.wikipedia.org/wiki/Date_format_by_country

#rlexu constants
const error_margin = 0.15
const samplesize = 5000
const match_margin = 0.15
const enclosuresfile = "rlexuenclosures.json"

function main() do app::Application
<<<<<<< Updated upstream:backup/dlexu.jl
    window = Window(app)
    set_child!(window, Label("Hello World!"))
    present!(window)
=======
       window = Window(app)
       set_child!(window, Label("Hello World!"))
       present!(window)
       end
>>>>>>> Stashed changes:dlexu/dlexu.jl

    jlib.disptm("rlexu began at")

    # ---------------------------- CONFIGURATION of RLXEU -------------------------------

    # reads the command line call expects dlexu [file in TOML format and its path]
    println(ARGS[2])
    dlexuTOML = config.getTOML(ARGS[2])
    println("dlexuTOML is : $(dlexuTOML)")


end # mainline

# ------------------------------------------------------------------------------------

# invoke rlexu
main()
