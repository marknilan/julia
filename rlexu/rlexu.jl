# this is the mainline program of rlexu

#generic julia code module
include("../jlib/jlib.jl")

#rlexu modules
include("./rlexustructs/rlexustructs.jl")
include("./config/config.jl")
include("./gui/gui.jl")
include("./instream/instream.jl")
include("./outstream/outstream.jl")
include("./propensity/propensity.jl")
#include("./dateproc/dateproc.jl")

using .config
using .rlexustructs
using .jlib
using .instream
using .outstream
using .propensity

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

    # create the UI for further display


    gui.startUI()

    jlib.disptm("rlexu began at")

    # ---------------------------- CONFIGURATION of RLXEU -------------------------------

    # reads the command line call to rlexu passes back a string of args
    parsed_args = config.parse_commandline()
    gui.dispcmdline(parsed_args)
    
    #this struct is the configuration used throughout this rlexu session
    cfghold = config.checkconfig(parsed_args["config"],parsed_args["datefmt"])    
    println("\n typeof(cfghold): ", typeof(cfghold))    
    
    # read the date formats file contains date data used for determining date propensities
    date_format_list = config.makedatefmts(parsed_args["datefmt"])
    #for (key, value) in date_format_list
    #    println("$value \n")
    #end

    #read the enclosures file getting the enclosuyres list to use in this rlexu session
    encl_list = config.getenclosures(enclosuresfile)

    # ---------------------------- DETERMINE PROPENSITIES -------------------------------

    if uppercase(cfghold.infiletype) in ("CSV", "DLM", "LOG")

        #get the line count of the incoming log file

        lincnt = jlib.countlines(cfghold.logfile)        

        #check - do we need to sample the file? based on the constant samplesize
        tstpop = instream.get_tstpop(cfghold.logfile, samplesize, error_margin, lincnt) 

    # determine propensity of list of common file data formats, data structures and data hierarchies
    # using the calculated test population above

        propensityscores = propensity.determine_record_landscape(cfghold, tstpop, match_margin, encl_list) 
    else        
        println("E02 ERROR Invalid File Type Provided : $(cfghold.infiletype) must use CSV, LOG, JSON or '' ")
        exit(2)
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
    else 
        println("not yet developed - hard MOFO")        
        
        stream = instream.read_log_file(cfghold,propensityscores,match_margin)
    end    
  
end # mainline

# ------------------------------------------------------------------------------------

# invoke rlexu
main()
