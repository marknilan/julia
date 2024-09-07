# part of the dlexugui module

using Gtk4, Graphics, Cairo, Colors

function cfgdlexu(dlexucfg,cfgfile) 

    #win = GtkWindow("D L E X U", 870, 670)
    #g = GtkGrid()
    #dlexutitle = GtkLabel("DLEXU - the Devops Log EXtract Utility")     
    #g[1:8,1] = dlexutitle       
    #g = ui.make_fields(g,win,dlexucfg,cfgfile)
    #g.column_homogeneous = false
    #g.column_spacing = 5   
    #g = ui.make_buttons(g,win)
    #push!(win,g)
    
    #if !isinteractive()
    #   c = Condition()
    #   signal_connect(win, :close_request) do widget
    #       notify(c)
    #   end
    #   @async Gtk4.GLib.glib_main()
    #   wait(c)
    #end
    return dlexucfg

end 


