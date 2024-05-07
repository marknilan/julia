module rlexustructs


# ------------------------------------------------------------------------------------
#configuration JSON of the program. Fed from -c rlexu command line configuration option
#example rlexu -c '<path to file><delimiter><rlexu config file name>' -d dateformats.txt 
#path = anywhere uses chooses. User configurable by changing the command line call made to rlexu

    export RlexuCfg
    Base.@kwdef mutable struct RlexuCfg
        logfile::String = " "
        infiletype::String = " "
        indelm::String = " "
        inhead::String = " "
        outdir::String = " "
        delimiter::String = " "
        quotes::String = " "
        header::String = " "
    end

# ------------------------------------------------------------------------------------
#date formats lookup CSV of the program. Fed from -d rlexu command line configuration option
#example rlexu -c rlexuconfig.txt -d '<path to file><delimiter><date formats file name>'
#path = anywhere uses chooses. User configurable by changing the command line call made to rlexu


    export DateLookup
    Base.@kwdef mutable struct DateLookup
        date_template::String = " "
        date_desc::String = " "
        date_key::String = " "
        date_example::String = " "
    end

# ------------------------------------------------------------------------------------
#editable by the user, JSON file contains the specific enclosures useful for the site
#default file provided initially are '[]', '()', '{}', '::', etc    
#hard coded path expects to be in same dir as the rlexu mainline file called 'rlexu.jl'    

#defaults - shipped with the rlexu program as follows
#    [
#    {"Encl1": "{","Encl2": "}"},
#    {"Encl1": "[","Encl2": "]"},
#    {"Encl1": "<","Encl2": ">"},
#    {"Encl1": "(","Encl2": ")"},
#    {"Encl1": ",","Encl2": ","},
#    {"Encl1": ";","Encl2": ";"},    
#    {"Encl1": ":","Encl2": ":"},
#    {"Encl1": "|","Encl2": "|"},
#    {"Encl1": "^","Encl2": "^"},
#    {"Encl1": "-","Encl2": "-"},
#    {"Encl1": "any text user desires start","Encl2": "any text user desires end"}, 
#    {"Encl1": "+","Encl2": "+"}  
#    ]

    export Enclosures
    Base.@kwdef mutable struct Enclosures
        encl1::String = " "
        encl2::String = " "
    end


end #module
