module dlexu


# this is the mainline program of rlexu

using mousetrap
#Package examples dont delete
#    # import Pkg; Pkg.add("JSON3")
#    Pkg.add(url="https://github.com/sylvaticus/LAJuliaUtils.jl.git")    
#maintenance
#using Pkg
#Pkg.update()
#Pkg.status()
#Pkg.rm("PackageName")
#cleanup
#Pkg.gc()



#---------------------------------------- MAINLINE --------------------------------------

#acknowledging this link for dates https://en.wikipedia.org/wiki/Date_format_by_country

#rlexu constants
const error_margin = 0.15
const samplesize = 5000
const match_margin = 0.15
const enclosuresfile = "rlexuenclosures.json"

       function main() do app::Application
           window = Window(app)
           set_child!(window, Label("Hello World!"))
           present!(window)
       end    
    
       end # mainline

# ------------------------------------------------------------------------------------

end # module dlexu
