
# Info: 
#  Web Server starting at http://127.0.0.1:8000 

#setup of the Genie Framework environment
using GenieFramework
include("../../jlib/jlib.jl")

@genietools

# reactive code
@app begin
    # reactive variables synchronised between server and browser
    @in N = 0
    @out msg = ""
    #reactive handler, executes code when N changes
    @onchange N begin
        msg = "N = $N"
    end
end

# UI components
function dlexumenu(cfgfile,logfile)
    [
        heading("DLEXU", class = "bg-blue-1")
        [separator(color = "primary"), p("the Devops Log EXtract Utility")]
        row([
           column(span("Hello"), size = 2, class = "bg-blue-2"),
           column(span("Genie"), size = 4, class = "bg-red-2"),
        ])
        p([    
        textfield("Configuration filename and path", :cfgfile, placeholder="$cfgfile"),
        textfield("Log filename and path", :logfile, placeholder="$logfile")
        ])
        cell([
                p("Enter a number")
                # variables are bound to a component using their symbol name
                textfield("N", :N )
            ])
        cell([
                bignumber("The value of N is", :N)
            ])
    ]
end

# definition of root route
function runapp(cfgfile,dlexucfg)
    logfile = dlexucfg.logfile
    println("$logfile")
    @page("/", dlexumenu(cfgfile,logfile))
    GenieFramework.up(8002, async = false)
    #r = jlib.open_in_default_browser("http://127.0.0.1:8002")
    #r = HTTP.request("GET", "http://127.0.0.1:8002")
    #println(r)
end        

