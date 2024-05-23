module jlib

using Base: undef_ref_str
using CSV
using DataFrames
using StructTypes
using LAJuliaUtils
using TimeZones, Dates


# counts file rows, returns the count and the time taken
function fcount(filename::String) 
        open(filename) do fh
        linecounter = 0
        timetaken = @elapsed for l in eachline(fh)
            linecounter += 1
        end
        (linecounter, timetaken)
    end

end

# reads a file into buffer memory, determines processing timing and memory and displays record count
function guagefile(filename::String)
    io = IOBuffer()
    f = open(filename)
    try
        l0 = readline(f)
        linecounter = 0
        for line in eachline(f)
           linecounter += 1
        end
        println("\n  $(filename) Input Rows : $linecounter")
    catch e
        println("Error while reading the file: ", e)
    finally
        close(f)
    end
    
    return String(take!(io))

end

# given a string representing a line of the incoming file from a string vector
# returns the propensity of the search as a floating number
function char_propensity(strline, rx)
    global count = 0
    # println("char_propensity strline is $(typeof(strline))")
    for s in strline
        for m in eachmatch(rx, s)
            if !(m.match === nothing)
                # println("Matched $(m.match) at index $(m.offset) at line $count plus 1")
                count = count + 1
            end
        end
    end
    count / size(strline, 1)

end

# returns a filename from a directory AND filename if present else returns the filename
# NOTE: also returns extension char in the filename itself - watch that on windows

function getfn(filename::String)

    # which OS are we on? Set the directory delimiter

    d = determine_os()

    if !(findfirst(d, filename) === nothing)
        lastdelm = findlast(d, filename)
        f = SubString(filename, lastdelm[1] + 1, length(filename))
    else
        f = filename
    end

    return f
end

# returns a non quoted string given a starting and ending delimiter

function delimited_substring(strline, fst, lst)    
    
    esl = strline

    f = findfirst(fst,strline)
    println("f = $f")
    if !(f === nothing)
       l = findnext(lst,strline,max(f[1],1))
       println("l = $l")
       if !(l === nothing)          
          esl = SubString(strline, max(f[1] + 1,1), max(l[1] - 1,1))
          println("strline is now $esl")
       end
    end
    
    return esl

end


function textbetween(text::AbstractString, startdlm::AbstractString, enddlm::AbstractString)
    startind = startdlm != "start" ? last(search(text, startdlm)) + 1 : 1
    endind   = enddlm   != "end"   ? first(search(text, enddlm, startind)) - 1 : endof(text)
    if iszero(startind) || iszero(endind) return "" end
    return text[startind:endind]
end

#returns an array of strings with enclosures removed

function delimited_array(str::String,encl1::String,encl2::String)
 
    arr = []
    occ = 1

    while true               
        f = findnext(encl1, str,occ)
        l = findnext(encl2, str,occ)
        ds = ""
        if !(f == nothing) && !(l == nothing)                 
           ds = SubString(str, f[1] + 1, l[1] - 1)
           occ = l[1] + 1                  
           push!(arr,ds)
        else   
           break
        end         
    end   

    return arr
    
end



# returns a character string from an OS call to determine slash direction eg  


function determine_os()
    if Sys.iswindows()
        d = "\\"
    else
        d = "/"
    end
end

function init_vec_num(range::AbstractRange)
    v = Vector{MyStruct}(undef, length(range))
    @inbounds for i in eachindex(range)
        v[i] = MyStruct(range[i], 0)
    end
    return v
end

function init_vec_chr(range::AbstractRange)
    v = Vector{MyStruct}(undef, length(range))
    @inbounds for i in eachindex(range)
        v[i] = MyStruct(range[i], " ")
    end
    return v
end

#displays the system time and a statement to suit its relevence

function disptm(statement::String)
     println(" \n $(Dates.now()) : $statement")
end 

#checks existence of an integer number (alone) in a string

function testnumber(s::String)

    isvalidnum = true 

    try                                                                     
       h = parse(Int64, s)                                                         
    catch                                                                   
       println("$s is not a count of lines - nor a number")                                                          
       isvalidnum = false
    end                                                                     

    return isvalidnum

end    

#replaces char with passed in Paired Dictionary entries (note: key is Char dtype ONLY)

function replace(str::String, old_news::Pair...)                        
                  out::String, mapping::Dict{Char,Any} = "", Dict(old_news)    
                  for c in str                                                 
                      if c in keys(mapping)                                    
                          out *= mapping[c]                                    
                      else                                                     
                          out *= c                                             
                      end                                                      
                  end                                                          
                  out                                                          
end   

# counts lines in a file

function countlines(filename::String)
        
    # create the command to execute (note the command is specific to the OS)

    if Sys.iswindows()
       cmdtorun = Cmd(["find","/V","/C","",filename])
    else   
       cmdtorun = Cmd(["wc","-l",filename])    
    end

    #readying for redirection
    
    original_stdout = stdout
    (rd, wr) = redirect_stdout();
    @async global cntchk = readline(rd)
    
    # call the redirect in this case the OS based linecount

    run(cmdtorun)
    linecnt = cntchk    

    close(wr)
    close(rd)

    redirect_stdout(original_stdout)
    
    #differences in output, note Mac uses same as linux

    if Sys.iswindows()
       return parse(Int64,linecnt)
    else
       return parse(Int64,split(linecnt)[1])   
    end   
end

# specific WSL code for MS windows types used to opens a specific windows OS browser

function detectwsl()
    Sys.islinux() &&
    isfile("/proc/sys/kernel/osrelease") &&
    occursin(r"Microsoft|WSL"i, read("/proc/sys/kernel/osrelease", String))
end

# opens passed paremeter URL in browser dependent on machine
# example local file 
# cmd.exe /s /c start "" /b "file:///C:/Users/Mark/projects/julia/dlexu/DlexuMenu/lib/index.html"

function open_in_default_browser(url::AbstractString)::Bool
    try
        if Sys.isapple()
            Base.run(`open $url`)
            return true
        elseif Sys.iswindows() || detectwsl()
            Base.run(`cmd.exe /s /c start "" /b $url`)
            return true
        elseif Sys.islinux()
            browser = "xdg-open"
            if isfile(browser)
                Base.run(`$browser $url`)
                return true
            else
                @warn "Unable to find `xdg-open`. Try `apt install xdg-open`"
                return false
            end
        else
            return false
        end
    catch ex
        return false
    end
end


end # module lib
