module instream

include("../../jlib/jlib.jl")
include("./structs.jl")

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
    #println("\n Test population to use will be $tstpop")

    return tstpop

end


function snifflines(logfile::String, tstpop::Int64,dlexuencl)::Bool

    # create a cursor (dataframe) of lines of the incoming file to checking
    # based on the size of the file

    testlines = collect(Iterators.take(eachline(logfile), tstpop))
    
    for i in eachindex(testlines)
        #println(testlines[i])
        b = count_encl_occurrence(testlines[i],dlexuencl)
    end
    
    #println("testlines is $(testlines)")
    return true

end

function count_encl_occurrence(logline,dlexuencl)::Bool

#1 . round bracket [()]
#2. square bracket [\[\]]

    nonslashrx = ["<", ">", "(", ")", "{", "}", ":", "\$", ".", "?","*", "+"]
    slashrx = ["[", "]", "/", "^", "\\", "|"]

    #println("length of enclpairs is $(length(dlexuencl.enclpairs))")
    rxstr = ""    
    for i in eachindex(dlexuencl.enclpairs)
        if isodd(i)
           prt = false
           if dlexuencl.enclpairs[i].encl1 in nonslashrx
              rxstr = "["*dlexuencl.enclpairs[i].encl1   
           elseif dlexuencl.enclpairs[i].encl1 in slashrx
              rxstr = "[\\"*dlexuencl.enclpairs[i].encl1
               else
                  rxstr = "["*dlexuencl.enclpairs[i].encl1
           end
           println("rxstr 1 = $(rxstr)")
        else 
           if dlexuencl.enclpairs[i].encl2 in nonslashrx
              rxstr = rxstr*" "*dlexuencl.enclpairs[i].encl2*"]"
              elseif dlexuencl.enclpairs[i].encl2 in slashrx
                   rxstr = rxstr*" "*"\\"*dlexuencl.enclpairs[i].encl2*"]"
                  else
                      rxstr = rxstr*" "*dlexuencl.enclpairs[i].encl2*"]"
           end
           prt = true
        end                     
        #println(" ===> $(dlexuencl.enclpairs[i].encl1)")
        #println(" ===> $(dlexuencl.enclpairs[i].encl2)")
        
    end    

    return true
end


end # module
