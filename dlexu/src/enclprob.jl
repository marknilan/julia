# part of the Probability Module

include("./structs.jl")

#Determines the probabilities of enclosure pairs found in the log
#sample population
function encl_proclivity(
    logfile::String,
    tstpop::Int64,
    match_margin::Float64,
    dlexuencl::Any,
)
    # create a cursor of log lines of the incoming file - or
    # if below the sample size threshold use the whole file to determine propensity
    samplepopulation = collect(Iterators.take(eachline(logfile), tstpop))
    enclprobs = count_encl_occurrence(samplepopulation, dlexuencl)
    println(" \n   Enclosures probability results are : ")
    # delete index map
    darr = [] 
    for (index, value) in enumerate(enclprobs.enclscores)
        if value.prob >= match_margin
            println("$(value.encl1)   $(value.encl2) =  $(value.prob) <=== USE")
        else
            println("$(value.encl1)   $(value.encl2) =  $(value.prob) <=== REJECT")
            push!(darr, index)
        end
    end
    # return only those (with high probability) that exceed the match 
    # margin threshold constant - uses delete map above
    return deleteat!(enclprobs.enclscores, darr)

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
        println("error : sample size is 0 observations - aborting enclosure propensity calculation")
        exit(8)
    end
    return enclprobs
end