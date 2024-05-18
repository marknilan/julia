module instream

include("../../jlib/jlib.jl")
include("../propensity/propensity.jl")
include("../outstream/outstream.jl")

using .jlib
using .propensity
using .outstream

using Printf
using DataFrames
using JSON3    
using CSV

#    using Base:read_sub


#    using StructTypes
#    using ArgParse


#    using LAJuliaUtils
#    # import Pkg; Pkg.add("JSON3")




# ------------------------------------------------------------------------------------
# will read JSON file of varying lengths (some fields can be missing) in SINGLE LINE JSON FORMULATION
# checks JSON is correct { <content> } function (checkjsonln) and if finding an invalid line 
# writes out to a bad data area 

function read_varying_JSON(cfghold::Main.config.rlexustructs.RlexuCfg)

    #vars required from config

    logfile = cfghold.logfile
    outdir = cfghold.outdir
    delimiter = cfghold.delimiter
    header = cfghold.header
    quotes = cfghold.quotes


    # which OS are we on? Set the delimiter

    d = jlib.determine_os()
    jsonstream = DataFrame()
    allowmissing!(jsonstream)
    cols::Symbol = :union
    promote::Bool = (cols in [:union, :subset])
    global ln = 0
    open(logfile, "r") do f
        while !eof(f)
            ln += 1
            s = readline(f)

            # check its valid JSON, if not write the line to bad JSON file
            if !(checkjsonln(s, outdir))
                filn = jlib.getfn(logfile)

                fn = outdir * d * filn * "_badJSONread.csv"
                outstream.write_line_to_file(s, fn, ln, cfghold)
            else

                # ok its a good JSON line, append the line to the dataframe
                # j ::AbstractDataFrame = DataFrame(JSON3.parse(s))
                j::AbstractDataFrame = DataFrame(JSON3.read(s))
                append!(jsonstream, j; cols, promote)
            end
        end
    end

    return jsonstream
end

# ------------------------------------------------------------------------------------
# checks a JSON line for correct formation "{" and "}" in ONE LINE 

function checkjsonln(s::String, outdir::String)

    # interim flag used between "before" and "after" syntax checks

    jsonok::Bool = true

    # check first that the line being read is in fact a JSON line must have "{ }"  

    if (!(findfirst("{", s) === nothing)) && (!(findlast("}", s) === nothing))

        # the "before" test for data BEFORE the JSON line

        firstcurly = findfirst("{", s)

        if (SubString(s, 1, firstcurly[1] - 1) == "")

            # nothing before the first brace {

            jsonok = true
        else

            # ok we see something BEFORE the first brace, check its just not spaces
            # spaces are OK in the standard JSON reader being used

            if !(isempty(strip(SubString(s, 1, firstcurly[1] - 1))))
                # ok there is a character string or more than one non blank chars before the JSON
                jsonok = false
            else

                # ok there are only spaces before the JSON

                jsonok = true
            end
        end

        # test for data AFTER the JSON line

        if jsonok == true
            lastcurly = findlast("}", s)
            if (SubString(s, lastcurly[1] + 1, length(s)) == "")

                # nothing after the last brace {

                jsonok = true
            else

                # ok we see something AFTER the last brace, check its just not spaces and LF
                # spaces are OK in the JSON reader used.

                if !(isempty(strip(SubString(s, lastcurly + 1, length(s)))))

                    # ok there is a character string or more than one non blank chars after the JSON

                    jsonok = false
                else

                    # ok there are only spaces and a line feed after the JSON

                    jsonok = true
                end
            end
        end
    else

        # there are no JSON lines here {between brackets} 

        jsonok = false
    end

    return jsonok
end

#reads a delimted file

function read_delimited_file(cfghold::Main.config.rlexustructs.RlexuCfg, scores::Vector{Array}, match_margin::Float64)
    
    #get input file parms from the config struct 
    
    logfile = cfghold.logfile
    indelm = cfghold.indelm
    infiletype = cfghold.infiletype
    
    vs = DataFrame()

    #test the incoming header specified in config is actually a number if not sets to 'false' which is
    #also legal syntax in the CSV read to dataframe apparently... nasty

    inhead = 1 #safety for the try
    try
        inhead = parse(Int64, cfghold.inhead)
    catch
        inhead = false    
    end

    # it is just normal delimited file, and type of file is specified and there's a delimiter then just read it  
    
    if (size(scores)[1] == 1) && (uppercase(first(scores[size(scores)[1]])) == "INDELM")    
        if !(indelm == "")        
           vs = CSV.read(logfile, DataFrame; delim = indelm, header = inhead, silencewarnings = true)       
        else
           println("E17 ERROR reading delimited file with config INDELM = $indelm NOT set for file $logfile")
           exit(2)
        end    
    else
        # break up the line by the delimiter given
    end    

    return vs
end

#determines the test population to use for file sampling

function get_tstpop(logfile::String, samplesize::Int64, error_margin::Float64) 

    # check the file processing timing - how big is it, how many rows?

    @time jlib.guagefile(logfile) 
    l, t = jlib.fcount(logfile)

    # create a test population ONLY IF the l (count) above is greater than the static
    # sample size (constant) set above in the mainline. Else just use the record count

    if l > samplesize
        tstpop = trunc(Int, l / (1 + (l * error_margin^2))) * 1000
    else
        tstpop = l-1   
    end
    println("\n Test population to use will be $tstpop")

    return tstpop

end

end # module
