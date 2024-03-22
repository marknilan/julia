module instream

include("../../jlib/jlib.jl")
include("../propensity/propensity.jl")
include("../outstream/outstream.jl")

using .jlib
using .propensity
using .outstream

using Printf
using DataFrames
using JSON3    
using CSV
using DelimitedFiles

#    using Base:read_sub


#    using StructTypes
#    using ArgParse


#using LAJuliaUtils
#    # import Pkg; Pkg.add("JSON3")




# ------------------------------------------------------------------------------------
# will read JSON file of varying lengths (some fields can be missing) in SINGLE LINE JSON FORMULATION
# checks JSON is correct { <content> } function (checkjsonln) and if finding an invalid line 
# writes out to a bad data area 

function read_varying_JSON(cfghold::Main.config.rlexustructs.RlexuCfg)

    #vars required from config

    logfile = cfghold.logfile
    outdir = cfghold.outdir
    delimiter = cfghold.delimiter
    header = cfghold.header
    quotes = cfghold.quotes


    # which OS are we on? Set the delimiter

    d = jlib.determine_os()
    jsonstream = DataFrame()
    allowmissing!(jsonstream)
    cols::Symbol = :union
    promote::Bool = (cols in [:union, :subset])
    global ln = 0
    open(logfile, "r") do f
        while !eof(f)
            ln += 1
            s = readline(f)

            # check its valid JSON, if not write the line to bad JSON file
            if !(checkjsonln(s, outdir))
                filn = jlib.getfn(logfile)

                fn = outdir * d * filn * "_badJSONread.csv"
                outstream.write_line_to_file(s, fn, ln, cfghold)
            else

                # ok its a good JSON line, append the line to the dataframe
                # j ::AbstractDataFrame = DataFrame(JSON3.parse(s))
                j::AbstractDataFrame = DataFrame(JSON3.read(s))
                append!(jsonstream, j; cols, promote)
            end
        end
    end

    return jsonstream
end

# ------------------------------------------------------------------------------------
# checks a JSON line for correct formation "{" and "}" in ONE LINE 

function checkjsonln(s::String, outdir::String)

    # interim flag used between "before" and "after" syntax checks

    jsonok::Bool = true

    # check first that the line being read is in fact a JSON line must have "{ }"  

    if (!(findfirst("{", s) === nothing)) && (!(findlast("}", s) === nothing))

        # the "before" test for data BEFORE the JSON line

        firstcurly = findfirst("{", s)

        if (SubString(s, 1, firstcurly[1] - 1) == "")

            # nothing before the first brace {

            jsonok = true
        else

            # ok we see something BEFORE the first brace, check its just not spaces
            # spaces are OK in the standard JSON reader being used

            if !(isempty(strip(SubString(s, 1, firstcurly[1] - 1))))
                # ok there is a character string or more than one non blank chars before the JSON
                jsonok = false
            else

                # ok there are only spaces before the JSON

                jsonok = true
            end
        end

        # test for data AFTER the JSON line

        if jsonok == true
            lastcurly = findlast("}", s)
            if (SubString(s, lastcurly[1] + 1, length(s)) == "")

                # nothing after the last brace {

                jsonok = true
            else

                # ok we see something AFTER the last brace, check its just not spaces and LF
                # spaces are OK in the JSON reader used.

                if !(isempty(strip(SubString(s, lastcurly + 1, length(s)))))

                    # ok there is a character string or more than one non blank chars after the JSON

                    jsonok = false
                else

                    # ok there are only spaces and a line feed after the JSON

                    jsonok = true
                end
            end
        end
    else

        # there are no JSON lines here {between brackets} 

        jsonok = false
    end

    return jsonok
end

# ------------------------------------------------------------------------------------
#reads a delimted file

function read_delimited_file(cfghold::Main.config.rlexustructs.RlexuCfg, scores::Vector{Array}, match_margin::Float64)
    
    #get input file parms from the config struct 
    
    logfile = cfghold.logfile
    indelm = cfghold.indelm
    infiletype = cfghold.infiletype    

    vs = DataFrame()

    if !(indelm == "")

       #test the incoming header specified in config is actually a number if not sets to 'false' which is
       #also legal syntax in the CSV read to dataframe apparently... nasty

       inhead = 1 #safety for the try
       try
           inhead = parse(Int64, cfghold.inhead)
       catch
           inhead = false    
       end

       # it is just normal delimited file, and type of file is specified and there's a delimiter then just read it  
    
       if (size(scores)[1] == 1) && (uppercase(first(scores[size(scores)[1]])) == "INDELM")    
           if !(indelm === "")        
              vs = CSV.read(logfile, DataFrame; delim = indelm, header = inhead, silencewarnings = true)       
           else
              println("E17 ERROR reading delimited file with config INDELM = $indelm NOT seen in file $logfile")
              exit(2)
           end    
       else
           # break up the line by the delimiter given, Then using enclosures get the string values between them
           vs = splitline_on_propensities(logfile, indelm, scores, cfghold.inhead)
       end    
    else
       println("E18 ERROR you specified a log file type of $infiletype yet the delimiter is missing")
       println("          from the rlexu configuration file. Delimiters are usually ',' or ';' or ' ' etc...")        
       exit(86)
    end      

    #println("\n typeof(vs): ", typeof(vs))
    return vs
end

# ------------------------------------------------------------------------------------
#reads a log file

function read_log_file(cfghold::Main.config.rlexustructs.RlexuCfg, scores::Vector{Array}, match_margin::Float64)
    
    #get input file parms from the config struct 
    
    logfile = cfghold.logfile
    indelm = cfghold.indelm
    infiletype = cfghold.infiletype
    
       vs = DataFrame()

       #test the incoming header specified in config is actually a number if not sets to 'false' which is
       #also legal syntax in the CSV read to dataframe apparently... nasty

       inhead = 1 #safety for the try
       try
           inhead = parse(Int64, cfghold.inhead)
       catch
           inhead = false    
       end

       # for log files using the whole line read each time and enclosures, get the string values between them
       vs = splitline_on_propensities(logfile, indelm, scores,cfghold.inhead)    

    #println("\n typeof(vs): ", typeof(vs))
    return vs
end


# ------------------------------------------------------------------------------------
#determines the test population to use for file sampling

function get_tstpop(logfile::String, samplesize::Int64, error_margin::Float64, lincnt::Int64) 

    # check the file processing timing - how big is it, how many rows?

    #@time jlib.guagefile(logfile) 
    #l, t = jlib.fcount(logfile)

    # create a test population ONLY IF the l (count) above is greater than the static
    # sample size (constant) set above in the mainline. Else just use the record count

    if lincnt > samplesize
        tstpop = trunc(Int, lincnt / (1 + (lincnt * error_margin^2))) * 1000
    else
        tstpop = lincnt   
    end
    println("\n Test population to use will be $tstpop")

    return tstpop

end

# ------------------------------------------------------------------------------------
#processes the LOG file if it has not been flagged as "CSV", "DLM" or "JSON" infiletype in the rlexu config
#Uses the propensity of enclosures to break up the file

function splitline_on_propensities(logfile::String, indelm::String, scores::Vector{Array},inhead)
   
    for i in eachindex(scores)
        println("scores[i] is $(scores[i])")
    end    

    pa = Vector[]
    pa1 = Any[]

    encl1 = "["
    encl2 = "]"
    build_s = "" 
    maxrowsize = 0

    io = IOBuffer()
    f = open(logfile)        
    cnt = 0
    for line in eachline(f)
        chomp(line)        
        #println("line is $line")
        if !(indelm == "")
           sa = split(line,indelm)                           
           push!(pa,sa) 
        else
           #all non delimited log files
           
           build_s = zotts(line,encl1,encl2,build_s)
           build_s = chop(build_s)
           #println("build_s is $build_s \n")
           ba = split(build_s,indelm)
           push!(pa1,ba)
           
           #finds the largest (delimited and enclosured) row that was previously read from the log file
           if length(ba) > maxrowsize
              maxrowsize = length(ba)
           end   
           build_s = ""
        end        
    end      

    #delimited files only 

    if !(indelm == "")
       for i in eachindex(pa)
            for j in eachindex(pa[i]) 
                s = collect(pa[i])[j]            
                build_s = zotts(s,encl1,encl2,build_s)
            end    
            build_s = chop(build_s)
            #println("$build_s \n")
            ba = split(build_s,indelm)
            push!(pa1,ba)

            #finds the largest (delimited and enclosured) row that was previously read from the log file            
            if length(ba) > maxrowsize
              maxrowsize = length(ba)
            end   
            build_s = ""        
        end        
    end        

   #@show pa1  

   #row normalise the array, so that all columns are present up to the max that were read.

    for i in eachindex(pa1)     
        a = pa1[i]
        l = length(a)
        for j = 1:maxrowsize-l
            push!(a,"")        
        end
        pa1[i] = a
    end 
    
    #use header if it is present to setup the dataframe column names
    if !(inhead == "") 
        namelist = Symbol.(pa1[1])
        startdf = 2
    else 

        #create headers 'h1 - h<n>'' where n (maxrowsize) is the largest delimited line read or split by the 
        #enclosures that have qualified as significant in earlier propensity calcs within the log file

        startdf = 1
        namelist = []
        for i = 1:maxrowsize
            push!(namelist,string("h",i))
        end    
    end

    #@show namelist

    vs  = DataFrame()

    #loop through the namelist array, create a column in the DataFrame entitled namelist[i]
    #and assign its values by using an array comprehension to the values into columns of the 
    #dataframe. startdf sets the 1st or 2nd row if a header is present as per the rlexu config
    
    for (i, name) in enumerate(namelist)
        vs[!, name] =  [pa1[j][i] for j in startdf:length(pa1)]
    end

    @show vs

    #for i in eachindex(pa1)
    #    arr = pa1[i]
    #    for j in eachindex(arr)
    #        sline = string.(arr[i,j])
    #        println("$(sline)")
    #    end    
    #end    



    #vs = CSV.Rows(@pipe println("$pa1") |>)
    #println("a=$(row.a), b=$(row.b), c=$(row.c)")
    
    #@pipe 10 |> ratio(_,4,1) |> percent(_[1],_[2])
    #vs = @pipe println("$pa1") |> CSV.read(logfile, DataFrame; delim = indelm, header = inhead, silencewarnings = true)
    #vs = CSV.read(logfile, DataFrame; delim = indelm, header = inhead, silencewarnings = true)
    #vs = DataFrame() 

   #vs = DataFrame()
   return vs

end 

function zotts(s,encl1,encl2,build_s)
                
                s = replace(s,"$encl1" => "zotts", "$encl2" => "zotts", '"' => "" )            
                hs = split(s,"zotts")
                if length(hs) > 1
                     for k in eachindex(hs)
                          build_s = build_s * '"' * strip(hs[k]) * '"' * "," 
                     end    
                else
                    build_s = build_s * '"' * strip(s) * '"' * "," 
                end    

    return build_s

end


function remove_enclosures(s::AbstractString,encl1::String,encl2::String,indelm::String,q)

    nes = s
  
    nes = rm_enc_whole(s,encl1,encl2,q)         
    nes = rm_enc_replace_dlm(nes,encl1,encl2,indelm,q)   

    return nes

end    

function rm_enc_whole(s::AbstractString,encl1::String,encl2::String,q)
        
    nes = s    
    if gquote(s) == ""
       if SubString(s,1,1) == encl1 &&  SubString(s,length(s),length(s)) == encl2
          nes = jlib.delimited_substring(s,encl1,encl2)    
       end
    else
       if (SubString(s,2,2) == encl1 &&  SubString(s,length(s)-1,length(s)-1) ==  encl2)
          s = SubString(s,2,length(s)-1)
          nes = jlib.delimited_substring(s,encl1,encl2)    
       end      
    end    
    return nes
end    


function gquote(s::AbstractString)                                            

    if SubString(s,1,1) in ("\"","'","`")           
        q = SubString(s,1,1)
    else
        q = ""
    end       
              
    return q                          

end

function rm_enc_replace_dlm(s,encl1::String,encl2::String,indelm,q) 

    fst = findfirst(encl1, s)
    lst = findfirst(encl2, s)      
    nes = s
    println("s IS NOW $s")
    ds = jlib.delimited_substring(s,encl1,encl2)
    println("ds = $ds")
    bfr = SubString(s,1,max(fst[1]-1,1))
    println("bfr = $bfr")
    if length(s) > lst[1]
       aft = SubString(s,lst[1]+1)
    else
       aft = ""
    end
    println("aft = $aft")
    if fst[1] == 1
       nes = String(string(q,ds,q,indelm,lstrip(aft)))                                     
    else
       nes = String(string(rstrip(bfr),q,indelm,q,ds,lstrip(aft)))
    end   
    println("Returning after editing nes is ===== $nes")
    return nes

end

end # module
