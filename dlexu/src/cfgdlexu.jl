# part of the dlexugui module

using Gtk4, Graphics, Cairo, Colors

function cfgdlexu() 


   c = GtkCanvas(1200, 900; vexpand=true, hexpand=true)
   win = GtkWindow(c,"D L E X U")
   @guarded draw(c) do widget
     ctx = getgc(c)
     h = height(c)
     w = width(c)
     # Paint red rectangle
     rectangle(ctx, 0, 0, w, h/8)
     set_source_rgb(ctx, 1, 0, 0)
     fill(ctx)
     # draw text 
    select_font_face(ctx, "Sans", Cairo.FONT_SLANT_NORMAL,
         Cairo.FONT_WEIGHT_NORMAL);
    set_font_size(ctx, 22.5);
    set_source_rgb(ctx, 0.8,0.8,0.8)
    extents = text_extents(ctx, "DLEXU MENU");
    x = 128.0-(extents[3]/2 + extents[1]);
    y = 128.0-(extents[4]/2 + extents[2]);
    move_to(ctx, x, y);
    show_text(ctx, "DLEXU MENU");
     # Paint blue rectangle
     rectangle(ctx, 0, 3h/4, w, h/4)
     set_source_rgb(ctx, 0, 0, 1)
     fill(ctx)
   end
   if !isinteractive()
       @async Gtk4.GLib.glib_main()
       Gtk4.GLib.waitforsignal(win,:close_request)
   end

end 

function makelayout(win)


  af = GtkAspectFrame(0.0, 0.0, 0.5, true)  
  push!(win, af)
  return win
end

function makebuttons(win)

    hbox = GtkBox(:h)  # :h makes a horizontal layout, :v a vertical layout
    push!(win, hbox)
    cancel = GtkButton("Cancel")
    save = GtkButton("Save")
    ok = GtkButton("Continue")
    save.hexpand = true
    hbox.spacing = 10
    push!(hbox, cancel)
    push!(hbox,save)
    push!(hbox, ok)
    return win

end	