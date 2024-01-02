local comunicate = require("comunicateModule")
local TXTFile = io.open("../values/prints/newUser.txt", "r")
local TXTFileProcess = nil
local mudanca = false
print("newUserWarn carregado!")
if TXTFile then
    TXTFileProcess = TXTFile:read("*l")
    TXTFile:close()
else
    print("erro ao abrir arquivo newUser.txt\nscript newUserWarn")
end

while true do
    mudanca = false
    mudanca, TXTFileProcess = comunicate.setArchive("../values/prints/newUser.txt", TXTFileProcess)
    if mudanca then
        print("novo usuario registrado, portador do nome "..TXTFileProcess)
    end
    comunicate.subFunctions.sleep(1)
end
