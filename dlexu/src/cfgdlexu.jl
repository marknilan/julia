# part of the dlexugui module

using Gtk4, Graphics, Cairo, Colors

function cfgdlexu() 

    win = GtkWindow("D L E X U", 1200, 900)
    g = GtkGrid()
    dlexutitle = GtkLabel("DLEXU - the Devops Log EXtract Utility")
    blank = GtkLabel("   ")  
    g[1:8,1] = dlexutitle   
    g[1,2:6] = blank  
    g = ui.make_fields(g,win)
    g.column_homogeneous = false # grid forces columns to have the same width
    g.column_spacing = 5   
    g = ui.make_buttons(g,win)
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


