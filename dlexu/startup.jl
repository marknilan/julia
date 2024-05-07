module startup

    include("../jlib/jlib.jl")
    include("./rlexustructs.jl")
    include("./gui.jl")


    using .jlib
    using .gui
    using .rlexustructs
    
    using ArgParse    
    using Printf
    using JSON3    
    using StructTypes
    using DataFrames
    using CSV
    using LAJuliaUtils


#generic does some mad stuff to the structs for JSON3
StructTypes.StructType(::Type{rlexustructs.RlexuCfg}) = StructTypes.Mutable()
StructTypes.StructType(::Type{rlexustructs.Enclosures}) = StructTypes.Mutable()

# ------------------------------------------------------------------------------------
# reads the commandline ARG string, returns a string vector of args passed to program
  # ------------------------------------------------------------------------------------
    # reads the commandline ARG string, returns a string vector of args passed to program

function parse_commandline()
    s = ArgParseSettings()
    @add_arg_table s begin
        "--config", "-c"
        help = "E01 ERROR rlexu program call must include -c with a TOML filename containing parameters eg. dlexu --config dlexuconfig.toml"
        required = true   
        action = :store_arg                  
    end
        
    if isempty()
        println(
            "E02 ERROR - the dlexu configuration TOML file must be provided with the -c parameter",
        )
        exit(2)
    end
    println(ARGS[2]);

    return parse_args(s)

end


end #module
