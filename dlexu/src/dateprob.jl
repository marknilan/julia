# part of the Probability Module

include("./structs.jl")

function date_proclivity(
    logfile::String,
    tstpop::Int64,
    match_margin::Float64,
    datelookup 
)
    
    # create a cursor of log lines of the incoming file - or
    # if below the sample size threshold use the whole file to determine propensity
    samplepopulation = collect(Iterators.take(eachline(logfile), tstpop))
    dateprobs = calc_date_probability(samplepopulation, datelookup)
    darr = []
    for (index, value) in enumerate(dateprobs.datescores)
        if value.prob > 0.0
           if value.prob >= match_margin
              println("$(value.date_template)  =  $(value.prob) <=== USE")
           else
              println("$(value.date_template)  =  $(value.prob) <=== REJECT")
              push!(darr, index)
           end
        end
    end
    # return only those (with high probability) that exceed the match 
    # margin threshold constant - uses delete map above

    return deleteat!(dateprobs.datescores, darr)
end

function calc_date_probability(samplepopulation, datelookup)::structs.DateProbs

    datescore = structs.DateScore()
    dateprobs = structs.DateProbs()
    samplesize = length(samplepopulation)
    if samplesize > 0
       dateprobs = structs.DateProbs()
       for i in eachindex(datelookup.dlexudates)
          datecount = 0
          rx = Regex(datelookup.dlexudates[i].julia_regex)
          for logline in enumerate(samplepopulation)
              datecount = datecount + length(collect(eachmatch(rx,logline[2])))          
          end
          if datecount > 0
             datescore.date_template = datelookup.dlexudates[i].date_template
             datescore.julia_regex = datelookup.dlexudates[i].julia_regex
             datescore.prob = Float64(datecount / samplesize) 
          end 
          push!(dateprobs.datescores, datescore)
       end     
    else
        println("error : sample size is 0 observations - aborting date propensity calculation")
        exit(8)
    end   
    
    return dateprobs
end    