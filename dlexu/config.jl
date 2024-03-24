module config

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
        help = "E03 ERROR rlexu program call must include --config or -c with a filename containing parameters eg. rlexu --config rlexuparms.cfg"
        required = true   
        action = :store_arg                  
    end
        
    @add_arg_table s begin
        "--datefmt", "-d"
                help = "E04 ERROR rlexu program call must include --datefmt or -d with a filename containing date formats eg. rlexu --config rlexuparms.cfg --datefmt dateloader.cfg "
                required = true   
                action = :store_arg    
    end
        
    return parse_args(s)

end

# ------------------------------------------------------------------------------------
# given the configuration filename, opens the JSON file and instatiates the configuration Struct 

function getcfg(config::String, cfghold)
        
    open(config) do fh
        while !eof(fh)
            # gets the configuration line from the file
            json_string = readline(fh)
            println("\n rlexu - this session configuration stream is: $json_string")
            
            # decodes the configuration line from the file
            JSON3.read!(json_string, cfghold)

        
        end

    end    

    return cfghold # returns the struct containing the config details for session

end

# ------------------------------------------------------------------------------------
#checks the incoming argument list for proper rlexu invocation

function checkconfig(config::String, datefmtfile::String)

    # should report (1) line only, time is redundant but common macro used

    l, t = jlib.fcount(config)
    @printf("%c linecount is : %d processed in : %.2f seconds", config, l, t)

    # not (1) line? then error, must be (1) line of JSON

    if (l != 1)
        println(
            "E01 ERROR - the rlexu configuration file must be a 1 line file. Leaving rlexu...",
        )
        exit(2)
    end

    # create an empty struct containing fields used for the configuration of rlexu for this session

    cfghold = rlexustructs.RlexuCfg()

    #println("\n typeof(cfghold): ", typeof(cfghold))
    
    # instantiate the struct. This then becomes the configuration used throughout this rlexu session

    cfghold = getcfg(config, cfghold)

    # display it to current output

    gui.dispcfg(cfghold)

    return cfghold

end


# ------------------------------------------------------------------------------------
#returns a data dictionary of date examples used to validate dates

function makedatefmts(datefmt::String)

    #read the incoming dates lookup file supplied in program call
    df = CSV.read(datefmt, DataFrame; header = 1,delim=";")

    # created the data dictionary
    date_format_list = toDict(df, [:date_template, :date_desc, :date_key, :date_example], :julia_regex)
    
    println("\n There were ", nrow(df), " rows read from the $datefmt file")

    return date_format_list

end

# ------------------------------------------------------------------------------------
# given the enclosures filename, opens the JSON file and instatiates the enclosure Struct 

function getenclosures(enclfile::String)
        
    # create an empty struct containing fields used for the configuration of rlexu for this session

    encl_list = []

    enclosures = rlexustructs.Enclosures()

    #println("\n typeof(enclosures): ", typeof(enclosures))
    
    # instantiate the struct. This then becomes the enclosures list used throughout this rlexu session

    open(enclfile) do fh
        while !eof(fh)
            # gets the enclosure line from the file
            json_string = readline(fh)
            println("\n rlexu - this session enclosures for checking are: $json_string")
            
            #JSON3.@generatetypes json_string
            #encl_list = JSON3.read(json_string, enclosures)
            #@show encl_list
            
            # decodes the configuration line from the file
            JSON3.read!(json_string, enclosures)            
            @show enclosures
            push!(encl_list,enclosures)
        end

    end    
    #println("\n typeof(encl_list): ", typeof(encl_list))
    @show encl_list
    return encl_list # returns the array of structs containing the enclosures used for the session

end

# ------------------------------------------------------------------------------------
#checks the incoming argument list for proper rlexu invocation

function checkconfig(config::String, datefmtfile::String)

    # should report (1) line only, time is redundant but common macro used

    l, t = jlib.fcount(config)
    @printf("%c linecount is : %d processed in : %.2f seconds", config, l, t)

    # not (1) line? then error, must be (1) line of JSON

    if (l != 1)
        println(
            "E01 ERROR - the rlexu configuration file must be a 1 line file. Leaving rlexu...",
        )
        exit(2)
    end

    # create an empty struct containing fields used for the configuration of rlexu for this session

    cfghold = rlexustructs.RlexuCfg()

    #println("\n typeof(cfghold): ", typeof(cfghold))
    
    # instantiate the struct. This then becomes the configuration used throughout this rlexu session

    cfghold = getcfg(config, cfghold)

    # display it to current output

    gui.dispcfg(cfghold)

    return cfghold

end

end #module
