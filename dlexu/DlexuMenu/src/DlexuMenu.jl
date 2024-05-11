module DlexuMenu

using Genie

const up = Genie.up
export up

function main()
  Genie.genie(; context = @__MODULE__)
  Connect_To()
end

function Connect_To()
   mycommand = `powershell "Invoke-WebRequest -Uri <http://127.0.0.1:8000/>"`
   run(mycommand);
end

end #module