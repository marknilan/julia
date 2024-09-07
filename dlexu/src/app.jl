
# Info: 
#  Web Server starting at http://127.0.0.1:8000 

#setup of the Genie Framework environment
using GenieFramework
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
function myui()
    [
        heading("DLEXU", class = "bg-blue-1")
        [separator(color = "primary"), p("the Devops Log EXtract Utility")]
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
function runapp()
    @page("/", myui)
    GenieFramework.up(8002, async = false)
    r = HTTP.request("GET", "http://127.0.0.1:8002")
    println(r.status)
    println(String(r.body))
end    

