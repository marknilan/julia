module config

using TOML, StructTypes
include("./structs.jl")

# reads a TOML format file, gets dlexu configuration information

function getTOML(cfgfile::String)

    TomlParse = Dict()
    println("DLEXU configuration TOML is being read from file : $(cfgfile)")
    try
        TomlParse = TOML.tryparsefile(cfgfile)
        println("TomlParse is $(TomlParse)")
    catch e
        println("TOML parse complete")
    end
   
   # LOOPING THROUGH THE TOML DICT
   for (iKey, iValue) in TomlParse

      for iValue in (keys(iValue))
         if iKey == "config"
            setfield!(structs.DlexuCfg, Symbol(iValue), TomlParse[iKey][iValue])

         elseif iKey == "dateformats"
            dlexudates = TomlParse[iKey][iValue]
            println("dlexudates is : $(dlexudates)")
         end 
      end
   end


      return TomlParse
end

end #module
