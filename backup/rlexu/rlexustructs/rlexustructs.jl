module rlexustructs

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



export DateLookup
Base.@kwdef mutable struct DateLookup
    date_template::String = " "
    date_desc::String = " "
    date_key::String = " "
    date_example::String = " "
end


end
