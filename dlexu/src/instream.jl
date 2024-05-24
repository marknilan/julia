module instream
# deals with instream operations for the log file being processed

include("../../jlib/jlib.jl")
include("./structs.jl")
include("./gui.jl")


#determines the test population to use for file sampling
function calc_test_population(logfile::String, maxobs::Int64)

    # check the file processing timing - how big is it, how many rows?
    @time jlib.guagefile(logfile)
    l, t = jlib.fcount(logfile)
    # create a test population ONLY IF the l (count) above is greater than the static
    # sample size (constant) set above in the mainline. Else just use the record count
    if l > maxobs
        tstpop = trunc(Int, l / (1 + (l * error_margin^2))) * 1000
        println("\n    Using sample population : $(tstpop)")
    else
        tstpop = l - 1
        println("\n    Using whole file as sample population : $(tstpop)")
    end

    return tstpop

end

#Determines the probabilities of enclosure pairs found in the log
#sample population
function score_proclivity(logfile::String,tstpop::Int64,
                          match_margin::Float64,dlexuencl::Any)::Bool
    # create a cursor of log lines of the incoming file - or
    # if below the sample size threshold use the whole file to determin propensity
    samplepopulation = collect(Iterators.take(eachline(logfile), tstpop))
    enclprobs = count_encl_occurrence(samplepopulation, dlexuencl)
    #println("\n    Enclosure probabilities found in sample population is : \n $(enclprobs)")
    println(" \n   Enclosures probability results are : ")
    for (index, value) in enumerate(enclprobs.enclscores)
           println("    encl pair $index  $value.encl1 $value.encl2  probability=$value.prob")
    end 
    resp = gui.display_message("Do you wish to continue?")  
    return true

end

#NEEDS HANDLING FOR BACKSLASH
# counts the enclosure pair's occurrences across the log sample population
function count_encl_occurrence(samplepopulation, dlexuencl)::structs.EnclProbs

    samplesize = length(samplepopulation)
    if samplesize > 0
        enclprobs = structs.EnclProbs()
        enclpaircnt = 0
        for i in eachindex(dlexuencl.enclpairs)
            enclpaircnt =
                enclpaircnt + div(
                    length(
                        findall(contains(dlexuencl.enclpairs[i].encl1), samplepopulation),
                    ) + length(
                        findall(contains(dlexuencl.enclpairs[i].encl2), samplepopulation),
                    ),
                    2,
                )
            enclscore = structs.EnclScore(
                dlexuencl.enclpairs[i].encl1,
                dlexuencl.enclpairs[i].encl2,
                enclpaircnt / samplesize,
            )
            push!(enclprobs.enclscores, enclscore)
        end
    else
        println("error : sample size is 0 observations - aborting propensity calculation")
        exit(8)
    end
    return enclprobs
end

end # module
