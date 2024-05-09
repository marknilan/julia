module gui

using Blink
#using Mousetrap



 
# ------------------------------------------------------------------------------------
# displays the rlexu session configuration to the output device

function dispcfg(cfghold)

    println("rlexu will...")
    println(" == Process File   : $(cfghold.logfile)")
    println(" == Of File Type   : $(cfghold.infiletype)")
    println(" ==  Considering   : $(cfghold.indelm) as a possible? incoming data delimiter")
    println(" ==    Expecting   : $(cfghold.inhead) header at top of file")
    println(" ==")
    println("rlexu will then...")
    println(" ==")
    println(" ==  Push Files To : $(cfghold.outdir) directory")
    println(" == With Delimiter : $(cfghold.delimiter)")
    println(" ==      Quoted As : $(cfghold.quotes) values in the data columns output")
    println(" == Using Header ? : $(cfghold.header) at top of files in the output")
    println(" ==")
    println("rlexu now checking input file...")

end


function dispcmdline(parsed_args::Dict{String, Any})

    #println("typeof(parsed_args): ", typeof(parsed_args))
    println("Rlexu invoked with the following parameters:")                            
    for (arg, val) in parsed_args
       println("  $arg  =>  $val")                                                    
    end              

end


function startUI()
  
    d = Dict("title"=>"Rlexu","center"=>"false","frame"=>"true")

    w = Window(d) # Open a new window

    handle(w, "press") do args...
         println("Start")
         sleep(5) # This will happily yield to any other computation.
         println("End")
    end

    body!(w, """<button onclick='Blink.msg("press", 1)'>go</button>""", async=false);

    while true  # Still an infinite loop, but a _fair_ one.
      yield()  # This will yield to any other computation, allowing the callback to run.
    end

end

#function mtUI() 
##    do app::Application
#       window = Window(app)
#       set_child!(window, Label("Hello World!"))
#       present!(window)
#    end

#end

end #module
