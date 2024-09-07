# dlexu_data_entry.jl

using Gtk4
using StringManipulation

function make_buttons(g,win)

    hbox = GtkBox(:h)   
    cancel = GtkButton("Cancel",tooltip_text="Leave Dlexu now and cancel changes")
    save = GtkButton("Save",tooltip_text="Save configuration to config file")
    ok = GtkButton("Continue",tooltip_text="Run Dlexu now using configuration")
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
    # setup fields and labels
    cfglabel = GtkLabel(align_string("Configuration file and path : ", 81, :r))    
    dlexuconfig = GtkEntry(text=cfgfile,tooltip_text="Use this file to run Dlexu")    
    cfgd = GtkButton(label="...",hexpand=false,width_request=10,tooltip_text="select file")
    loglabel = GtkLabel(align_string("Logname and path : ", 81, :r))    
    logfile = GtkEntry(text=dlexucfg.logfile,tooltip_text="Process this log file on next run")
    logd = GtkButton("...",hexpand=false,width_request=10,tooltip_text="select file")    
    inftypelabel = GtkLabel(align_string("Log Type ( LOG DLM JSON ) : ", 76, :r))
    infiletype = GtkEntry(text=dlexucfg.infiletype,tooltip_text="Select which type of log")
    indelmlabel = GtkLabel(align_string("Incoming delimiter ( <space> <any char/s> ) : ", 70, :r))    
    indelm = GtkEntry(text=dlexucfg.indelm,tooltip_text="How is the log delimited?")    
    inqtelabel = GtkLabel(align_string("Incoming quote char ( ' ` ) : ", 79, :r))    
    inquote = GtkEntry(text=dlexucfg.inquote,tooltip_text="Does the log file have quoted values")
    outdirlabel = GtkLabel(align_string("Output directory : ", 82, :r))    
    outdir = GtkEntry(text=dlexucfg.outdir,tooltip_text="Where to push the CSV file to? It will be name uniquely therein")
    outd = GtkButton("...",hexpand=false,width_request=10,tooltip_text="select file")    
    outdelmlabel = GtkLabel(align_string("Output delimiter ( <space> <any char/s> ) : ", 73, :r))    
    delimiter = GtkEntry(text=dlexucfg.delimiter,tooltip_text="Delimit the CSV file by this string or char")    
    outqtelabel = GtkLabel(align_string("Output quote char ( ' ` ) : ", 80, :r))    
    quotes = GtkEntry(text=dlexucfg.quotes,tooltip_text="Quote CSV columns by this char")
    datefmtlabel = GtkLabel(align_string("Output date format ( eg. YYYY-MM-DD HH:MM:SS ) : ", 65, :r))
    datefmt = GtkEntry(text=dlexucfg.datefmt,tooltip_text="If dates are present in log format them like this in CSV output")    
    # put into grid
    g[2:4,7]=cfglabel; g[5:10,7]=dlexuconfig ; g[11,7]=cfgd   
    g[2:4,8]=loglabel ; g[5:10,8]=logfile ; g[11,8]=logd  
    g[2:4,9]=inftypelabel ; g[5:10,9]=infiletype     
    g[2:4,10]=indelmlabel ; g[5:10,10]=indelm 
    g[2:4,11]=inqtelabel ; g[5:10,11]=inquote     
    g[2:4,12]=outdirlabel ; g[5:10,12]=outdir ; g[11,12] = outd 
    g[2:4,13]=outdelmlabel ; g[5:10,13]=delimiter 
    g[2:4,14]=outqtelabel ; g[5:10,14]=quotes 
    g[2:4,15:20]=datefmtlabel ; g[5:10,15:20]=datefmt 

    function cfgclick(cfgd)
       open_dialog("Pick a DLEXU configuration file. Must be in TOML xxxx format", win) do filename
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