module structs

# ------------------------------------------------------------------------------------
#configuration TOML of the program. Fed from dlexu command line configuration parameter
#example dlexu <path to file><delimiter><rlexu config file name>

export DlexuCfg
Base.@kwdef mutable struct DlexuCfg
    logfile::String = " "
    infiletype::String = " "
    indelm::String = " "
    inquote::String = " "
    outdir::String = " "
    delimiter::String = " "
    quotes::String = " "
    datefmt::String = " "
end

# ------------------------------------------------------------------------------------
#date formats lookup CSV of the program. Fed from [date] section of the dlexu TOML
#configuration file. data is held in the "dateformats" TOML key as a filename and path
#of a specifically formatted CSV file (note must be ";" semicolon delimited ONLY)

export DateLookup
Base.@kwdef mutable struct DateLookup
    date_template::String = " "
    date_desc::String = " "
    date_key::String = " "
    date_example::String = " "
end

export Encl
Base.@kwdef mutable struct Encl
    encl1::String = " "
    encl2::String = " "
end

export DlexuEncl
Base.@kwdef mutable struct DlexuEncl
    enclpairs::Vector{Encl} = []
end

export EnclProb
Base.@kwdef mutable struct EnclProb
    encl1::String = " "
    encl2::String = " "
    prob::Float64 = 0.0
end

export EnclScores
Base.@kwdef mutable struct EnclScores
    enclscores::Vector{EnclProb} = []
end

end #module
