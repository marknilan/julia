module gui

using Blink



include("../../jlib/jlib.jl")


function DlexUI()



w = Window() 

body!(w, "Hello World")  

 handle(w, "press") do args...
         println("Start")
         sleep(5) 
         println("End")
       end
 

   body!(w, """<button onclick='Blink.msg("press", 1)'>go</button>""", async=false);

    while true   
         yield()   
       end


end


function dispcfg(dlexucfg)
    :Bool

    println("\n  Dlexu will...")
    println("   == Process Log File   : $(dlexucfg.logfile)")
    println("   ==     Of File Type   : $(dlexucfg.infiletype)")
    println(
        "       ==      Considering   : $(dlexucfg.indelm) as the incoming data delimiter",
    )
    println(
        "       ==    Expecting   : $(dlexucfg.inquote) quoted values in the incoming data rows",
    )
    println("       ==")
    println("\n  Dlexu will then...")
    println("       ==  Push Files To : $(dlexucfg.outdir) directory")
    println("       == With Delimiter : $(dlexucfg.delimiter)")
    println(
        "       ==      Quoted As : $(dlexucfg.quotes) values in the data columns output",
    )
    println("       ==    Date format : $(dlexucfg.datefmt) for any date column output")
    println("       ==")
    println("\n Dlexu now calculating enclosure probabilities on the incoming log file...")
    return true
end


end # module
