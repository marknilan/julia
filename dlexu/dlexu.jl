# this is the mainline program of rlexu

#generic julia code module
include("../jlib/jlib.jl")

#rlexu modules
include("./rlexustructs.jl")
include("./config.jl")

using .config
using .rlexustructs
using .jlib

using StructTypes
using ArgParse
using Printf
using DataFrames
using Match
using JSON3
using StringDistances
using Blink

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

function main()

    jlib.disptm("rlexu began at")

    # ---------------------------- CONFIGURATION of RLXEU -------------------------------

    # reads the command line call to rlexu passes back a string of args
    parsed_args = config.parse_commandline()  
    #this struct is the configuration used throughout this rlexu session
    cfghold = config.checkconfig(parsed_args["config"],parsed_args["datefmt"])    
    println("\n typeof(cfghold): ", typeof(cfghold))        
    # read the date formats file contains date data used for determining date propensities
    date_format_list = config.makedatefmts(parsed_args["datefmt"])
    for (key, value) in date_format_list
        println("$value \n")
    end

    #read the enclosures file getting the enclosuyres list to use in this rlexu session
    encl_list = config.getenclosures(enclosuresfile)     
  
end # mainline

# ------------------------------------------------------------------------------------

# invoke rlexu
main()
