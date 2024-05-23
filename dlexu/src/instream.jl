module instream

include("../../jlib/jlib.jl")
include("./structs.jl")

#determines the test population to use for file sampling

function calc_test_population(logfile::String, samplesize::Int64) 

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


function score_proclivity(logfile::String, tstpop::Int64, match_margin::Int64, dlexuencl)::Bool

    # create a cursor of lines of the incoming file 
    # or the whole file

    testlines = collect(Iterators.take(eachline(logfile), tstpop))
    enclscores = count_encl_occurrence(testlines,dlexuencl)
    
    println("enclscores $(enclscores)")
    return true

end

# NEEDS HANDLING FOR BACKSLASH
function count_encl_occurrence(testlines,dlexuencl)::structs.EnclScores

#1 . round bracket [()]
#2. square bracket [\[\]]

    #nonslashrx = ["<", ">", "(", ")", "{", "}", ":", "\$", ".", "?","*", "+"]
    #slashrx = ["[", "]", "/", "^", "\\", "|"]

    #println("length of enclpairs is $(length(dlexuencl.enclpairs))")
 
    enclscores = structs.EnclScores()
    
    enclpaircnt = 0
    for i in eachindex(dlexuencl.enclpairs)
        encl1 = dlexuencl.enclpairs[i].encl1
        encl2 = dlexuencl.enclpairs[i].encl2

       enclpaircnt = enclpaircnt + div(length(findall(contains(encl1),testlines)) + 
                                       length(findall(contains(encl2),testlines)),2)
       enclprob = structs.EnclProb(encl1,encl2,enclpaircnt/0.5)
       println("enclprob is $(enclprob)") 

       
    end
    return enclscores       
end 

end # module
