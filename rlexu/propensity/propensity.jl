module propensity

include("../../jlib/jlib.jl")

using .jlib

using DataFrames
using Printf

#    using Base:read_sub
#    include("../../jlib/jlib.jl")
#    using .lib
#    using StructTypes
#    using ArgParse

#    using DataFrames
#    using LAJuliaUtils
#    # import Pkg; Pkg.add("JSON3")
#    using JSON3    
#    using CSV


# ------------------------------------------------------------------------------------
# loads a tuple containing a score name and the propensity of the data into a vector

function loadpropensity(propensity, scorename, record_landscape)
    propensity = round(propensity, digits = 5)
    t = (proptype = scorename, propensity)
    push!(record_landscape, t)
    return record_landscape
end


# ------------------------------------------------------------------------------------
# reads a file into array of strings depending on trycount (depth to read)
# returns an array of strings and propensities

function snifflines(logfile::String, tstpop::Int64, indelm::String)

    # create a cursor (dataframe) of lines of the incoming file to checking
    # based on the size of the file


    testlines = collect(Iterators.take(eachline(logfile), tstpop))

    # assumption here is that if the data is delimited then inside those
    # delimiters any bracketed data is required for it's brackets values ONLY
    # to be extracted, WITHOUT brackets themselves

    record_landscape = Vector{NamedTuple}()

    # checking the file is indeed delimited based on the flag given by the user

    if length(indelm) > 0
        rx = getdlmregex(indelm)
        propensity = jlib.char_propensity(testlines, Regex(rx))
        @printf(" Indelm Propensity : %.5f \n", propensity)
        record_landscape = loadpropensity(propensity, "indelm", record_landscape)
    end

    # square brackets
    rx = "\\[(.*?)\\]"
    propensity = jlib.char_propensity(testlines, Regex(rx))
    record_landscape = loadpropensity(propensity, "sqbckt", record_landscape)

    # round brackets
    rx = "\\((.*?)\\)"
    propensity = jlib.char_propensity(testlines, Regex(rx))
    record_landscape = loadpropensity(propensity, "rndbckt", record_landscape)

    # curly braces
    rx = "{(.*?)}"
    propensity = jlib.char_propensity(testlines, Regex(rx))
    record_landscape = loadpropensity(propensity, "curlbrace", record_landscape)

    # parameter bracketing
    rx = "<(.*?)>"
    propensity = jlib.char_propensity(testlines, Regex(rx))
    record_landscape = loadpropensity(propensity, "parmbrkt", record_landscape)

    # @printf("      Propensity : %.5f \n",propensity)

    return record_landscape # return the vector of propensities of the file sample
end


# ------------------------------------------------------------------------------------
# given an incoming file delimiter, creates regex suitable for searching the file
# propensity of the delimiter

function getdlmregex(indelm::String)
    # "[\"( ]$indelm[\") ]" 
    "[" * indelm * "]+"
end

# ------------------------------------------------------------------------------------
# ticks or crosses scores according to match_margin constant of rlexu

function score_proclivity(record_landscape::Vector{NamedTuple}, match_margin::Float64)

    scores = Array[]
    for item in record_landscape    
            a = Array[[item[1], item[2]]]
            if item[2] > match_margin
               scores = append!(a, scores)
            end   
        
    end

    return scores
end

# ------------------------------------------------------------------------------------
#checks the incoming log file for delimiters and enclosures returns propensity scores

function determine_record_landscape(cfghold::Main.config.rlexustructs.RlexuCfg,tstpop::Int64,match_margin::Float64, encl_list)

    println("\n length of encl_array is $(length(encl_list))")
    
    logfile = cfghold.logfile
    indelm = cfghold.indelm
    indelm = cfghold.infiletype

    #take a look at the file, determine whats in it based on delimiters and enclosures
    record_landscape = snifflines(logfile, tstpop, indelm)

    #calculate the propensity from the counts taken from the logfile landscape
    propensityscores = score_proclivity(record_landscape,match_margin)
    display(propensityscores)
    return propensityscores

end    

end #module
