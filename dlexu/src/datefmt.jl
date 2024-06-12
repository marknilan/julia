module datefmt

using CSV

include("./structs.jl")

# reads the supplied date formats CSV file which must be in the form as follows
# "date_template";"date_desc";"date_key";"date_example";"julia_regex"
# which is header=yes, values quoted with '"' and delimited by ";"
# returns a date formatting struct used read and match date data candidates and
# validate the date format specified by the user for outputting dates
function make_datelookup(dlexudates::String)::structs.DateLookup

    println("dlexudates is $(dlexudates)")
    datelookup = structs.DateLookup()
    dlmdata = Any
    try
        dlmdata = CSV.File(dlexudates, quoted = true, quotechar = '"', delim = ';')
    catch e
        println("error : Date Format file processing error $(e)")
        exit(8)
    end
    for dlmrow in dlmdata
        dlexudate = structs.DlexuDate(
            dlmrow.date_template,
            dlmrow.date_desc,
            dlmrow.date_key,
            dlmrow.date_example,
            dlmrow.julia_regex,
        )
        push!(datelookup.dlexudates, dlexudate)
    end
    return datelookup

end

function date_proclivity(
    logfile::String,
    tstpop::Int64,
    match_margin::Float64,
    datelookup::structs.DateLookup
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

function calc_date_probability(samplepopulation, datelookup::structs.DateLookup)::structs.DateProbs

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

end # module
