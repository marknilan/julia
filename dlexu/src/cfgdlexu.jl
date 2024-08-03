# part of the dlexugui module

using Gtk4, Graphics, Cairo, Colors

function cfgdlexu() 

    win = GtkWindow("D L E X U", 1200, 900)
    g = GtkGrid()
    dlexutitle = GtkLabel("DLEXU - the Devops Log EXtract Utility")
    blank = GtkLabel("   ")  
    g[1:8,1] = dlexutitle   
    g[1,2:6] = blank  
    g = make_data_entry(g,win)
    g.column_homogeneous = false # grid forces columns to have the same width
    g.column_spacing = 5   
    g = make_buttons(g,win)
    push!(win,g)
    
    if !isinteractive()
       c = Condition()
       signal_connect(win, :close_request) do widget
           notify(c)
       end
       @async Gtk4.GLib.glib_main()
       wait(c)
    end
  

end 

function make_buttons(g,win)

    hbox = GtkBox(:h)  # :h makes a horizontal layout, :v a vertical layout
    cancel = GtkButton("Cancel")
    save = GtkButton("Save")
    ok = GtkButton("Continue")
    save.hexpand = false
    hbox.spacing = 5
    push!(hbox, cancel)
    push!(hbox,save)
    push!(hbox, ok)

    function cancelclick(cancel)
        Gtk4.destroy(win)
        println("Exit Dlexu via Cancel")
        exit(0)
    end

    signal_connect(cancelclick, cancel, "clicked") 
    
    g[11,10] = hbox
    
    return g

end

function make_data_entry(g,win)

    cfglabel = GtkLabel("Configuration file and path : ")
    dlexucfg = GtkEntry()
    dlexucfg.text = "blah blah"
    cfgd = GtkButton("...")
    cfgd.hexpand = false
    loglabel = GtkLabel("Logname and path : ")
    logfile = GtkEntry()
    logfile.text = "blah blah"
    logd = GtkButton("...")
    logd.hexpand = false

    g[2:4,7] = cfglabel
    g[5:10,7] = dlexucfg
    g[11,7]   = cfgd   
    
    g[2:4,8] = loglabel
    g[5:10,8] = logfile
    g[11,8]   = logd   
    
    
    function cfgclick(cfgd)
       #info_dialog(f, "Julia rocks!",win)
       open_dialog("Pick a DLEXU configuration file. Must be in TOML format", win) do filename
           dlexucfg.text = filename 
       end
    end

    function logclick(logd)
       #info_dialog(f, "Julia rocks!",win)
       open_dialog("Pick a log for Dlexu to process", win) do filename
           logfile.text = filename 
       end
    end
    signal_connect(cfgclick, cfgd, "clicked") 
    signal_connect(logclick, logd, "clicked") 

   return g
end	
