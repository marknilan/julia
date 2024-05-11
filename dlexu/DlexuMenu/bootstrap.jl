(pwd() != @__DIR__) && cd(@__DIR__) # allow starting app from bin/ dir

using DlexuMenu
const UserApp = DlexuMenu
DlexuMenu.main()
