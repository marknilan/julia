module config

using TOML

# reads a TOML format file, gets dlexu configuration information

function getTOML(cfgfile::String)

    tomlcontent = ""
    println("DLEXU configuration TOML is being read from file : $(cfgfile)")
    try
        f = open(cfgfile, "r")
        tomlcontent = read(f, String)
        close(f)
    catch e
        println("Could not open file $(e)")
    end
    try
        f = open(cfgfile, "r")
        tomlcontent = TOML.parsefile(f)
        close(f)
    catch e
        println("TOML parse complete")
    end
    println("type of tomlcontent is $(typeof(tomlcontent))")
    mud = TOML.parse(tomlcontent)
      return mud
end

end #module
