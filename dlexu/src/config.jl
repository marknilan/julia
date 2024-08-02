# part of the Startup module

using TOML, StructTypes

include("./structs.jl")
include("../../jlib/jlib.jl")

# reads a TOML format file, gets dlexu program configuration 
function getTOML(cfgfile::String)
    enclist = Vector{String}
    dlexucfg = structs.DlexuCfg()
    dlexuencl = structs.DlexuEncl()
    dlexudates = ""
    TomlParse = Dict()
    println("    DLEXU configuration TOML is being read from file : $(cfgfile)")
    if !(isfile(cfgfile))
        println("error : Config file $(cfgfile) does not exist")
        exit(8)
    else
        try
            TomlParse = TOML.parsefile(cfgfile)
        catch e
            println("error : TOML parse error $(e)")
            exit(8)
        end
    end
    for (iKey, iValue) in TomlParse
        for iValue in (keys(iValue))
            if iKey == "config"
                setfield!(dlexucfg, Symbol(iValue), TomlParse[iKey][iValue])
            elseif iKey == "date"
                dlexudates = TomlParse[iKey][iValue]
            elseif iKey == "enclosures"
                enclist = TomlParse[iKey][iValue]
            end
        end

    end
    # errors if there is not incoming delimiter if a log is "value""value" then use 
    # delimiter = \"\" as the delimiter (decodes to "") you just cannot leave this null

    if length(dlexucfg.indelm) < 1
        println(
            "error : you must specify an incoming logical delimiting string for the log"
        )
        exit(8)
    end    

    # errors if ODD number (enforces pairs of enclosures)
    if !iseven(length(enclist))
        println(
            "error : enclosure list $(enclist) has ODD number of elements - must be EVEN",
        )
        exit(8)
    end
    # make list of enclosure pairs to search for
    dlexuencl = MakeEncl(enclist)
    # show the program configuration at the command line
    dispcfg(dlexucfg)
    return dlexucfg, dlexudates, dlexuencl
end

# turns a EVEN number of array elements into an enclosure pairs struct
function MakeEncl(enclist::Vector{String})::structs.DlexuEncl
    encl = structs.Encl()
    dlexuencl = structs.DlexuEncl()
    for i = 1:length(enclist)
        if iseven(i)
            encl.encl2 = enclist[i]
        else
            encl.encl1 = enclist[i]
            continue
        end
        push!(dlexuencl.enclpairs, encl)
        encl = structs.Encl()

    end
      
    return dlexuencl
end
