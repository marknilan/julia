# dlexu_data_entry.jl

using Gtk4
using StringManipulation

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
    
    g[11,21] = hbox
    
    return g

end

function make_fields(g,win,dlexucfg,cfgfile)
    #cfglabel = GtkLabel("Configuration file and path : ")
    cfglabel = GtkLabel(align_string("Configuration file and path : ", 81, :r))    
    dlexuconfig = GtkEntry(text=cfgfile)    
    cfgd = GtkButton("...",hexpand=false)
    loglabel = GtkLabel(align_string("Logname and path : ", 81, :r))    
    logfile = GtkEntry(text=dlexucfg.logfile)
    logd = GtkButton("...",hexpand=false)    
    inftypelabel = GtkLabel(align_string("Log Type ( LOG DLM JSON ) : ", 76, :r))
    infiletype = GtkEntry(text=dlexucfg.infiletype)
    indelmlabel = GtkLabel(align_string("Incoming delimiter ( <space> <any char/s> ) : ", 70, :r))    
    indelm = GtkEntry(text=dlexucfg.indelm)    
    inqtelabel = GtkLabel(align_string("Incoming quote char ( ' ` ) : ", 79, :r))    
    inquote = GtkEntry(text=dlexucfg.inquote)
    outdirlabel = GtkLabel(align_string("Output directory : ", 82, :r))    
    outdir = GtkEntry(text=dlexucfg.outdir)
    outd = GtkButton("...",hexpand=false)    
    outdelmlabel = GtkLabel(align_string("Output delimiter ( <space> <any char/s> ) : ", 73, :r))    
    delimiter = GtkEntry(text=dlexucfg.delimiter)    
    outqtelabel = GtkLabel(align_string("Output quote char ( ' ` ) : ", 80, :r))    
    quotes = GtkEntry(text=dlexucfg.quotes)
    datefmtlabel = GtkLabel(align_string("Output date format ( eg. YYYY-MM-DD HH:MM:SS ) : ", 65, :r))
    datefmt = GtkEntry(text=dlexucfg.datefmt)    

    g[2:4,7] = cfglabel
    g[5:10,7] = dlexuconfig
    g[11,7]   = cfgd   
 
    g[2:4,8] = loglabel
    g[5:10,8] = logfile
    g[11,8]   = logd  

    g[2:4,9] = inftypelabel
    g[5:10,9] = infiletype 
    
    g[2:4,10] = indelmlabel
    g[5:10,10] = indelm 
    
    g[2:4,11] = inqtelabel
    g[5:10,11] = inquote 
    
    g[2:4,12] = outdirlabel
    g[5:10,12] = outdir 
    g[11,12] = outd 

    g[2:4,13] = outdelmlabel
    g[5:10,13] = delimiter 

    g[2:4,14] = outqtelabel
    g[5:10,14] = quotes 

    g[2:4,15:20] = datefmtlabel
    g[5:10,15:20] = datefmt 

    function cfgclick(cfgd)
       open_dialog("Pick a DLEXU configuration file. Must be in TOML format", win) do filename
          dlexuconfig.text = filename
       end
    end

    function logclick(logd)
       open_dialog("Pick a log for Dlexu to process", win) do filename
          logfile.text = filename
       end
    end

    function outclick(outd)
       open_dialog("CSV output directory", select_folder = true, win) do dirname
          outdir.text = dirname
       end
    end

    signal_connect(cfgclick, cfgd, "clicked") 
    signal_connect(logclick, logd, "clicked") 
    signal_connect(outclick, outd, "clicked") 
   

   return g
end	