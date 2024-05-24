module gui

   
  using Gtk4
    
    function DlexUI()



    end

function on_button_clicked(w)
    println("The button has been clicked")
end


function display_message(message::String)::Bool
 
       win = GtkWindow("gtkwait")

       b = GtkButton("Continue")
       push!(win,b)

       e = GtkButton("Leave Dlexu")
       push!(win,e)

       signal_connect(on_button_clicked, b, "clicked")
       signal_connect(on_button_clicked, e, "exit")

       if !isinteractive()
            c = Condition()
            signal_connect(win, :close_request) do widget
               notify(c)
            end   
       end
       @async Gtk4.GLib.glib_main()
       wait(c)

       return true

end


function dispcfg(dlexucfg):Bool

    println("\n  Dlexu will...")
    println("       == Process File   : $(dlexucfg.logfile)")
    println("       == Of File Type   : $(dlexucfg.infiletype)")
    println("       ==  Considering   : $(dlexucfg.indelm) as a possible? incoming data delimiter")
    println("       ==    Expecting   : $(dlexucfg.inquote) quoted values in the incoming data rows")
    println("       ==")
    println("\n  Dlexu will then...")
    println("       ==  Push Files To : $(dlexucfg.outdir) directory")
    println("       == With Delimiter : $(dlexucfg.delimiter)")
    println("       ==      Quoted As : $(dlexucfg.quotes) values in the data columns output")
    println("       ==    Date format : $(dlexucfg.datefmt) for any date column output")
    println("       ==")
    println("\n Dlexu now calculating enclosure probabilities on the incoming log file...")
    return true
end


end # module
