module structs

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

#An enclosure pair, a pair of strings with data held within its
#boundaries on a log line 
export Encl
Base.@kwdef mutable struct Encl
    encl1::String = " "
    encl2::String = " "
end

#A list of enclosure pairs to use in this Dlexu program execution
export DlexuEncl
Base.@kwdef mutable struct DlexuEncl
    enclpairs::Vector{Encl} = []
end

#An enclosure pair score, that is the count of pairs found across a 
#log file population sample divided by the sample size 
export EnclScore
Base.@kwdef mutable struct EnclScore
    encl1::String = " "
    encl2::String = " "
    prob::Float64 = 0.0
end

#A list of enclosure pair scores which will be used to determine
#whether the enclosure is found in the log population given the probabilty
#is greater than the match margin 
export EnclProbs
Base.@kwdef mutable struct EnclProbs
    enclscores::Vector{EnclScore} = []
end

end #module
