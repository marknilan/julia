module outstream

include("../../jlib/jlib.jl")

using .jlib
using CSV

#using DataFrames

#    using Base:read_sub


#    using StructTypes
#    using ArgParse
#    using Printf

#    using LAJuliaUtils
#    # import Pkg; Pkg.add("JSON3")
#    using JSON3    



# ------------------------------------------------------------------------------------
# writes a line (string) to file, with its source file line number it was read from 
# ln contains the line number, line is the source line that was READ from an original file

function write_line_to_file(line::String, fn::String, ln::Integer, cfghold::Main.config.rlexustructs.RlexuCfg)

    delimiter = cfghold.delimiter
    header = cfghold.header
    quotes = cfghold.quotes


    if isfile(fn)
        io = open(fn, "a")
    else
        touch(fn)
        io = open(fn, "w")
        if !(header === "")
            try
                write(
                    io,
                    quotes *
                    "Line_Number" *
                    quotes *
                    delimiter *
                    quotes *
                    "Line" *
                    quotes *
                    "\n",
                )
            catch err
                println("E05 ERROR writing output to delimited Bad record file $fn")
                return false
            end
        end
    end
    try
        write(io, quotes * string(ln) * quotes * delimiter * quotes * line * quotes * "\n")
        close(io)
    catch err
        println("E06 ERROR writing output to delimited Bad record file $fn")
        return false
    end

    return true
end

# ------------------------------------------------------------------------------------
# sends a dataframe to CSV file using supplied parameters in a configuration struct

function df_to_csv(vs, cfghold::Main.config.rlexustructs.RlexuCfg)

    #vars required from config
    logfile = cfghold.logfile
    outdir = cfghold.outdir
    delimiter = cfghold.delimiter
    header = cfghold.header
    quotes = cfghold.quotes

    # get the OS configuration directory delimiter

    d = jlib.determine_os()
    
    # adjust the filename and path based on the OS
    filn = jlib.getfn(logfile)

    fn = outdir * d * filn * ".csv"
    
    # header is assumed y or <any char other than y or Y> or "" nothing in the config

    if uppercase(header) == "Y"
        hdr = true
    else
        hdr = false
    end

    # if the user has indicated "" nothing in the quotes field then set the option to false

    if !(quotes == "")
        qtstr = true
        qtchr = only(quotes)
    else
        qtstr = false
        qtchr = Char(0)
    end

    # write the CSV file from the DataFrame using the config parms

    try
        CSV.write(
            fn,
            vs;
            delim = delimiter,
            header = hdr,
            quotestrings = qtstr,
            quotechar = qtchr,
        )
    catch err
        println("E07 ERROR writing output to delimited file $fn")
        return false
        exit(2)
    end

    return true

end



end #module
