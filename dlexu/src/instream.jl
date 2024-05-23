module instream
# deals with instream operations for the log file being processed

include("../../jlib/jlib.jl")
include("./structs.jl")

#determines the test population to use for file sampling
function calc_test_population(logfile::String, maxobs::Int64) 

    # check the file processing timing - how big is it, how many rows?
    @time jlib.guagefile(logfile) 
    l, t = jlib.fcount(logfile)
    # create a test population ONLY IF the l (count) above is greater than the static
    # sample size (constant) set above in the mainline. Else just use the record count
    if l > maxobs
        tstpop = trunc(Int, l / (1 + (l * error_margin^2))) * 1000
    else
        tstpop = l-1   
    end
    return tstpop

end


function score_proclivity(logfile::String, tstpop::Int64, match_margin::Float64, dlexuencl::Any)::Bool

    # create a cursor of log lines of the incoming file - or
    # if below the sample size threshold use the whole file
    testlines = collect(Iterators.take(eachline(logfile), tstpop))
    enclscores = count_encl_occurrence(testlines,dlexuencl)
    
    println("enclscores $(enclscores)")
    return true

end

# NEEDS HANDLING FOR BACKSLASH
function count_encl_occurrence(testlines,dlexuencl)::structs.EnclProbs

    #println("length of enclpairs is $(length(dlexuencl.enclpairs))")
    samplesize = length(testlines)
    if samplesize > 0       
       enclprobs = structs.EnclProbs()
       enclpaircnt = 0
       for i in eachindex(dlexuencl.enclpairs)
           encl1 = dlexuencl.enclpairs[i].encl1
           encl2 = dlexuencl.enclpairs[i].encl2
           enclpaircnt = enclpaircnt + div(length(findall(contains(encl1),testlines)) + 
                                       length(findall(contains(encl2),testlines)),2)
           enclscore = structs.EnclScore(encl1,encl2,enclpaircnt/samplesize)
           push!(enclprobs.enclscores,enclscore)        
       end
    else
       println("error : sample size is 0 observations - aborting propensity calculation")
       exit(8)   
    end
    return enclprobs           
end 

end # module
