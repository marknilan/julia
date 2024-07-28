module gui

include("../../jlib/jlib.jl")

using Dash

include("../../jlib/jlib.jl")


# function DlexUI()

#    jlib.open_in_default_browser(".\\dlexumenu.html")

# end


function DlexUI(dlexucfg)


app = dash()

app.layout = html_div(className="app-header") do
    html_h1("DLEXU",className="app-header.app-header--title"
    ),
    html_div(
        "Devops  Log  EXtract  Utility",
        style = Dict("color" => "#063970", "textAlign" => "left"),
    ),
    html_br(),
    html_label(className="app-div1",id="logfilelabel","Log filename and path"),
    dcc_input(id="logfile", className="app-div2", type="text", value=dlexucfg.logfile),
    html_br(),
    html_label(className="app-div1",id="infilelabel","Log type (LOG DLM CSV JSON"),
    dcc_input(className="app-div2",id="infiletype", type="text", value=dlexucfg.infiletype),
    html_br(),
    html_label(className="app-div1",
        id="indelmlabel","Incoming delimiter (<space> <any char> <any str>"),
    dcc_input(id="indelm", className="app-div2", type="text", value=dlexucfg.indelm),
    html_div(id = "configfileout")
end

callback!(
    app,
    Output("configfileout", "children"),
    Input("logfile", "value"),
    Input("infiletype", "value"),
) do logfile, infiletype
    return "Input 1 is \"$logfile\" and Input 2 is \"$infiletype\""
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
