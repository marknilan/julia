module gui

#using Gtk
include("../../jlib/jlib.jl")


# function DlexUI()

#    jlib.open_in_default_browser(".\\dlexumenu.html")

# end

function DlexUI()
   win = GtkWindow("A new window")
   g = GtkGrid()
   a = GtkEntry()  # a widget for entering text
   set_gtk_property!(a, :text, "This is Gtk!")
   b = GtkCheckButton("Check me!")
   c = GtkScale(false, 0:10)     # a slider

# Now let's place these graphical elements into the Grid:
   g[1,1] = a    # Cartesian coordinates, g[x,y]
   g[2,1] = b
   g[1:2,2] = c  # spans both columns
   set_gtk_property!(g, :column_homogeneous, true)
   set_gtk_property!(g, :column_spacing, 15)  # introduce a 15-pixel gap between columns
   push!(win, g)
   showall(win)
end

function display_message(message::String)::Bool

    win = GtkWindow("gtkwait")

    b = GtkButton("Continue")
    push!(win, b)

    e = GtkButton("Leave Dlexu")
    push!(win, e)

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
