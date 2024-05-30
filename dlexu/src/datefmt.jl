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
)::Bool
    
    # create a cursor of log lines of the incoming file - or
    # if below the sample size threshold use the whole file to determine propensity
    samplepopulation = collect(Iterators.take(eachline(logfile), tstpop))
    cd = count_date_occurrence(samplepopulation, datelookup)
    println(cd)
    return true
end

function count_date_occurrence(samplepopulation, datelookup::structs.DateLookup)::Bool

    samplesize = length(samplepopulation)
    if samplesize > 0
       dateprobs = structs.DateProbs()
       println("type = $(typeof(datelookup))")
       for i in eachindex(datelookup.dlexudates)
          rx = Regex(datelookup.dlexudates[i].julia_regex)
          for logline in enumerate(samplepopulation)
              c = length(collect(eachmatch(rx,logline[2])))
              if c > 0 
                 println("cnt is $(c) ") 
              end
          end  
          
       end     
    end 
    #else
    #    println("error : sample size is 0 observations - aborting date propensity calculation")
    #    exit(8)
    #end   
    
    return true
end    

end # module
