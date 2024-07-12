module outstream

include("../../jlib/jlib.jl")

using CSV
#using DataFrames
using Tables
#using DelimitedFiles
using Dates

function make_output(outv::Vector{String}, dlexucfg)::Bool

    outok = false
    # Create a filename with the timestamp
    fn = "$(dlexucfg.outdir)" * "$(jlib.determine_os())" * jlib.getfn(dlexucfg.logfile)
    ofile = "$(fn)_$(Dates.format(now(), "yyyy-mm-dd_HH-MM-SS")).csv"
    println("    Dlexu will write CSV output to $(ofile)")
    csvout = open(ofile, "w")
    #       writedlm(io, outarray,only(dlexucfg.delimiter),"'")
    #end
    for line in outv
        outarray = split(line,dlexucfg.delimiter)
        println("size of outarray is $(size(outarray))")
        for (i, col) in enumerate(outarray)
            if i == size(outarray)[1]
               outstr = dlexucfg.quotes * col * dlexucfg.quotes
            else
               outstr = dlexucfg.quotes * col * dlexucfg.quotes * dlexucfg.delimiter
            end   
            print(csvout,outstr)
        end
        print(csvout,"\n")    

    end    
    close(csvout)
    #t = Tables.table(outv)
    #rows = Tables.rows(t)
    #outarray = []
    #for line in outv
    #    a = split(line,dlexucfg.delimiter)
    #       df = Tables.table(a)
     #      CSV.write(ofile,rows,
      #           writeheader=false,
       #          append=true,
        ##        quotechar=only(dlexucfg.quotes),
          #       quotestrings=true,
          # )
        #for value in a
        #   b = split(value,dlexucfg.delimiter)
        #   push!(outarray,b)
        
        #end    
    #end 

    #open(ofile, "w") do io
    #       writedlm(io, outarray,only(dlexucfg.delimiter),"'")
    #end
    println("    CSV file created successfully")
    outok = true
    #catch e
    #    println("error : $(e) \n Unable to write to CSV file $(ofile)")
    #    exit(8)
    #end

    return outok

end

function writerow(f,line,dlexucfg,colcnt)::Bool

     
     for (colnum, colval) in enumerate(line)
         if colnum == 1
            valstr = dlexucfg.quotes * colval * dlexucfg.quotes * dlexucfg.delimiter
         elseif colnum == colcnt
            valstr = dlexucfg.quotes * colval * dlexucfg.quotes
         else
            valstr = dlexucfg.delimiter * dlexucfg.quotes * colval * dlexucfg.quotes
         end             
         try
             write(f,valstr)
             return true
         catch
             println("error : Column write error $(colnum) to CSV file $(ofile)")
             return false
         end
     end    
end    

end # module
