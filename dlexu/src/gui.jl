module gui

using Mousetrap

function generate_child(label::String)
    out = Frame(Overlay(Separator(), Label(label)))
    set_margin!(out, 10)
    return out
end

    function DlexUI(app::Application)
       window = Window(app)    
       header_bar = get_header_bar(window)
       set_layout!(header_bar, "close")
       set_title_widget!(header_bar, Label("DLEXU - Devops Log eXtract Utility"))
       paned = Paned(ORIENTATION_HORIZONTAL)
       set_start_child!(paned, generate_child("Left"))
       set_end_child!(paned, generate_child("Right"))

       set_start_child_shrinkable!(paned, true)
       set_end_child_shrinkable!(paned, true)

       center_box = CenterBox(ORIENTATION_HORIZONTAL)
       set_start_child!(center_box, Label(""))
       set_center_child!(center_box, Label(""))
       set_end_child!(center_box, Button())

       set_child!(window, paned)
       set_child!(window, center_box)
       
       return window
        
    end	



end # module