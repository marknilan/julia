# part of the Startup module

using CSV

include("./structs.jl")

# reads the supplied date formats CSV file which must be in the form as follows
# "date_template";"date_desc";"date_key";"date_example";"julia_regex"
# which is header=yes, values quoted with '"' and delimited by ";"
# returns a date formatting struct used read and match date data candidates and
# validate the date format specified by the user for outputting dates
function make_datelookup(dlexudates::String)

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