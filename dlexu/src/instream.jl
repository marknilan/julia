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
    println("\n Test population to use will be $tstpop")

    return tstpop

end

function snifflines(logfile::String, tstpop::Int64)::Bool

    # create a cursor (dataframe) of lines of the incoming file to checking
    # based on the size of the file


    testlines = collect(Iterators.take(eachline(logfile), tstpop))
    
    for i in eachindex(testlines)
        println(testlines[i])
    end
    
    #println("testlines is $(testlines)")
    return true

end


end # module
