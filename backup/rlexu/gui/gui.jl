module gui



#    using Base:read_sub
#    include("../../jlib/jlib.jl")
#    using .lib
#    using StructTypes
#    using ArgParse
#    using Printf
#    using DataFrames
#    using LAJuliaUtils
#    # import Pkg; Pkg.add("JSON3")
#    using JSON3    
#    using CSV


 
# ------------------------------------------------------------------------------------
# displays the rlexu session configuration to the output device

function dispcfg(cfghold)

    println("rlexu will...")
    println(" == Process File   : $(cfghold.logfile)")
    println(" == Of File Type   : $(cfghold.infiletype)")
    println(" ==  Considering   : $(cfghold.indelm) as a possible? incoming data delimiter")
    println(" ==    Expecting   : $(cfghold.inhead) header at top of file")
    println(" ==")
    println("rlexu will then...")
    println(" ==")
    println(" ==  Push Files To : $(cfghold.outdir) directory")
    println(" == With Delimiter : $(cfghold.delimiter)")
    println(" ==      Quoted As : $(cfghold.quotes) values in the data columns output")
    println(" == Using Header ? : $(cfghold.header) at top of files in the output")
    println(" ==")
    println("rlexu now checking input file...")

end


function dispcmdline(parsed_args::Dict{String, Any})

    #println("typeof(parsed_args): ", typeof(parsed_args))
    println("Rlexu invoked with the following parameters:")                            
    for (arg, val) in parsed_args
       println("  $arg  =>  $val")                                                    
    end              

end

end #module
