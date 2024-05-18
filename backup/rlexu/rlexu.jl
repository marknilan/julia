# this is the mainline program of rlexu

#generic julia code module

include("./rlexustructs/rlexustructs.jl")
include("./config/config.jl")
include("./gui/gui.jl")
include("../jlib/jlib.jl")
include("./instream/instream.jl")
include("./outstream/outstream.jl")
include("./propensity/propensity.jl")

#rlexu modules

#include("./dateproc/dateproc.jl")





using .config
using .rlexustructs
using .jlib
using .instream
using .outstream
using .propensity

using ArgParse
using Printf
using DataFrames
using Match
using JSON3


using StringDistances

#acknowledging this link for dates https://en.wikipedia.org/wiki/Date_format_by_country

# import Pkg; Pkg.add("JSON3")
# import Pkg; Pkg.add("StructTypes")
# Pkg.add(url="https://github.com/sylvaticus/LAJuliaUtils.jl.git")

using StructTypes

const error_margin = 0.15
const samplesize = 5000
const match_margin = 0.15

function main()

    jlib.disptm("rlexu began at")

    # ---------------------------- CONFIGURATION of RLXEU -------------------------------

    # reads the command line call to rlexu passes back a string of args
    parsed_args = config.parse_commandline()
    gui.dispcmdline(parsed_args)
    
    #this struct is the configuration used throughout this rlexu session
    cfghold = config.checkconfig(parsed_args["config"],parsed_args["datefmt"])    
    #println("\n typeof(cfghold): ", typeof(cfghold))    
    
    # read the date formats file contains date data used for determining date propensities
    date_format_list = config.makedatefmts(parsed_args["datefmt"])
    #for (key, value) in date_format_list
    #    println("$value \n")
    #end

    # ---------------------------- DETERMINE PROPENSITIES -------------------------------

    if uppercase(cfghold.infiletype) in ("CSV", "DLM", "")

        #check - do we need to sample the file? based on the constant samplesize
        tstpop = instream.get_tstpop(cfghold.logfile, samplesize, error_margin) 

    # determine propensity of list of common file data formats, data structures and data hierarchies
    # using the calculated test population above

        propensityscores = propensity.determine_record_landscape(cfghold, tstpop, match_margin) 
        println("\n typeof(propensityscores): ", typeof(propensityscores))
    end


    #-------------------------------- PARSE LOG FILE -------------------------------------

    if uppercase(cfghold.infiletype) in ("CSV", "DLM", "JSON")
       if uppercase(cfghold.infiletype) == "JSON"
          stream = instream.read_varying_JSON(cfghold)
       else
          stream = instream.read_delimited_file(cfghold,propensityscores,match_margin)
       end          
       if outstream.df_to_csv(stream, cfghold)
          println("file is written") 
       else           
          exit(2)                        
       end        
    elseif uppercase(cfghold.infiletype) in ("", "LOG")   
        println("not yet developed - hard MOFO")
    else        
        println("E02 ERROR Invalid File Type Provided : $(cfghold.infiletype) must use CSV, LOG, JSON or '' ")
        exit(2)
    end                
   

  
end # main

# ------------------------------------------------------------------------------------

# invoke rlexu
main()
