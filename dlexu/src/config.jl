module config

using TOML

# reads a TOML format file, gets dlexu configuration information

function getTOML(cfgfile::String)
    tomlcontent = ""
    println("cfgfile is : $(cfgfile)")
    try
       f = open(cfgfile, "r")
       tomlcontent = read(f, String)
       #println(tomlcontent)
       close(f)
    catch e
           println("Could not open file $(e)")
       end
    try
       dlexuconfig = TOML.parse(tomlcontent)
    catch e
       println("TOML parse error $(e)")
    end
    
            
end



end #module