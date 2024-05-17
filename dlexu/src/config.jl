module config

using TOML, StructTypes
include("./structs.jl")

# reads a TOML format file, gets dlexu configuration information

function getTOML(cfgfile::String)::Bool

    enclist = Vector{String}
    dlexucfg = structs.DlexuCfg()
    dlexudates = ""
    TomlParse = Dict()
    println("cfgfile is $(cfgfile)")
    println("DLEXU configuration TOML is being read from file : $(cfgfile)")
    if !(isfile(cfgfile))        
        println("Error : Config file $(cfgfile) does not exist")
        exit(8)
    else     
        try
           TomlParse = TOML.parsefile(cfgfile)
           println("TomlParse is $(TomlParse)")
        catch e
           println("TOML parse error $(e)")
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
    if !iseven(length(enclist)) 
        println("Error : Enclosure list $(enclist) has ODD number of elements - must be EVEN")
        exit(8)
    end    
    
    dlexuencl = MakeEncl(enclist)

    println("dlexucfg logfile is $(dlexucfg.logfile)") 
    println("dlexudates is $(dlexudates) ")
    println("dlexuencl is $(length(dlexuencl)) ")
    
    return true 
end

function MakeEncl(enclist::Vector{String})::structs.DlexuEncl
    dlexuencl = structs.DlexuEncl()
    encl = structs.Encl()
    for i in 1:length(enclist)
        if iseven(i) 
            encl.encl1 = enclist[i]
        else
            encl.encl2 = enclist[i]
            push!(dlexuencl.enclpairs, encl); 
        end
    end
    return dlexuencl
end    

end #module
