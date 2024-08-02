include("../../jlib/jlib.jl")
include("./structs.jl")

using Dash


# function DlexUI()

#    jlib.open_in_default_browser(".\\dlexumenu.html")

# end


function DlexUI(dlexucfg)

    app = dash()
    p = structs.DlexuCfg()
    app.layout = html_div(className = "app-header") do
        html_h1("DLEXU", className = "app-header.app-header--title"),
        html_div(
            "Devops  Log  EXtract  Utility",
            style = Dict("color" => "#063970", "textAlign" => "left"),
        ),
        html_hr(),
        html_label(className = "app-div1", id = "logfilelabel", "Log filename and path"),
        dcc_input(
            id = "logfile",
            className = "app-div2",
            type = "text",
            value = dlexucfg.logfile,
        ),
        html_br(),
        html_label(
            className = "app-div1",
            id = "infilelabel",
            "Log type (LOG DLM CSV JSON",
        ),
        dcc_input(
            className = "app-div2",
            id = "infiletype",
            type = "text",
            value = dlexucfg.infiletype,
        ),
        html_br(),
        html_label(
            className = "app-div1",
            id = "indelmlabel",
            "Incoming delimiter (<space> <any char> <any str>",
        ),
        dcc_input(
            id = "indelm",
            className = "app-div2",
            type = "text",
            value = dlexucfg.indelm,
        ),
        html_br(),
        html_label(
            className = "app-div1",
            id = "inquotelabel",
            "Incoming quote char ('\"' '`' \"'\" )",
        ),
        dcc_input(
            id = "inquote",
            className = "app-div2",
            type = "text",
            value = dlexucfg.inquote,
        ),
        html_hr(),
        html_label(
            className = "app-div1",
            id = "outdirlabel",
            "CSV export target directory - CSV name will be log_named_timestamp",
        ),
        dcc_input(
            id = "outdir",
            className = "app-div2",
            type = "text",
            value = dlexucfg.outdir,
        ),
        html_br(),
        html_label(
            className = "app-div1",
            id = "delimiterlabel",
            "CSV output column delimiter (<space> <any char> <any str>",
        ),
        dcc_input(
            id = "delimiter",
            className = "app-div2",
            type = "text",
            value = dlexucfg.delimiter,
        ),
        html_br(),
        html_label(
            className = "pl",
            id = "quoteslabel",
            "CSV output quote character ('\"' '`' \"'\" )",
        ),
        dcc_input(id = "quotes", className = "pr", type = "text", value = dlexucfg.quotes),
        html_br(),
        html_label(
            className = "app-div1",
            id = "datefmtlabel",
            "CSV output date column format (eg YYYY-MM-DD:HH:MM:SS)",
        ),
        dcc_input(
            id = "datefmt",
            className = "app-div2",
            type = "text",
            value = dlexucfg.datefmt,
        ),
        html_hr(),
        html_button(
            "Exit Dlexu without saving",
            id = "exitdlexu",
            className = "button button3",
            n_clicks = 0,
        ),
        html_div(id = "configfileout")

    end

    callback!(
        app,
        Output("configfileout", "children"),
        Input("logfile", "value"),
        Input("infiletype", "value"),
        Input("indelm", "value"),
        Input("inquote", "value"),
        Input("outdir", "value"),
        Input("delimiter", "value"),
        Input("quotes", "value"),
        Input("datefmt", "value"),
        Input("exitdlexu", "n_clicks"),
    ) do logfile, infiletype, indelm, inquote, outdir, delimiter, quotes, datefmt, exitdlexu
        p = structs.DlexuCfg(
            logfile,
            infiletype,
            indelm,
            inquote,
            outdir,
            delimiter,
            quotes,
            datefmt,
        )
        if exitdlexu > 0

            exit(0)
        end
    end


    run_server(app, "0.0.0.0", debug = true)
    os.kill(os.getpid(), signal.SIGTERM)
    jlib.open_in_default_browser("http://127.0.0.1:8050/")
    return p

end

# not used
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

