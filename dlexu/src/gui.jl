module gui

using Dash

include("../../jlib/jlib.jl")


# function DlexUI()

#    jlib.open_in_default_browser(".\\dlexumenu.html")

# end


function DlexUI(dlexucfg)


app = dash()

app.layout = html_div() do
    html_i("Try typing in input 1 & 2, and observe how debounce is impacting the callbacks. Press Enter and/or Tab key in Input 2 to cancel the delay."),
    html_br(),
    dcc_input(id="input-no-debounce", type="text", value=dlexucfg.logfile),
    dcc_input(id="input-debounce", type="text", value=dlexucfg.infiletype, debounce=true),
    html_div(id = "output-keywords-2")
end

callback!(
    app,
    Output("output-keywords-2", "children"),
    Input("input-no-debounce", "value"),
    Input("input-debounce", "value"),
) do input_1, input_2
    return "Input 1 is \"$input_1\" and Input 2 is \"$input_2\""
end

run_server(app, "0.0.0.0", debug=true)



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
