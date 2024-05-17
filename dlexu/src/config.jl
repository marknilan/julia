module config

using TOML, StructTypes
include("./structs.jl")

# reads a TOML format file, gets dlexu configuration information

function getTOML(cfgfile::String)::Bool

    dlexucfg = structs.DlexuCfg()
    dlexuencl = structs.DlexuEncl()
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
           println("TOML parse complete")
        end
    end    
   
   
     # LOOPING THROUGH THE DICT
   for (iKey, iValue) in TomlParse

      for iValue in (keys(iValue))
         if iKey == "config"
            setfield!(dlexucfg, Symbol(iValue), TomlParse[iKey][iValue]) 
         elseif iKey == "date"
            dlexudates = TomlParse[iKey][iValue] 
               elseif iKey == "enclosures"
                  println("iValue is $(iValue)") 
                  setfield!(dlexuencl.enclpairs, Symbol(iValue), TomlParse[iKey][iValue]) 
                  #for iValue in (keys(iValue))                  
                      #println("iValue Symbol is $(Symbol(iValue))")
                      #println("iKey is $(iKey)")
                      #println("iValue is $(iValue)")
                      #println("TomlParse is $(TomlParse[iKey][iValue])")
                  #setfield!(dlexuencl.enclpairs, Symbol(iValue), TomlParse[iKey][iValue]) 
                  #end
               end 
      end

   end   
    println("dlexucfg logfile is $(dlexucfg.logfile)") 
    println("dlexudates is $(dlexudates) ")
    println("enclpairs is $(dlexuencl) ")
    
    return true 
end

end #module
