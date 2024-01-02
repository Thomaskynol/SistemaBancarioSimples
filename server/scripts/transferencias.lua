local comunicate = require("comunicateModule")
local TXTFile = io.open("../transferencias/podeir.txt", "r")
local TXTFileProcess = nil
local mudanca = false
print("setor de transferencias carregado!")
if TXTFile then
    TXTFileProcess = TXTFile:read("*l")
    TXTFile:close()
else
    print("erro ao abrir arquivo newUser.txt\nscript newUserWarn")
end

while true do
    mudanca = false
    mudanca, TXTFileProcess = comunicate.setArchive("../transferencias/podeir.txt", TXTFileProcess)
    if mudanca then
        local value = comunicate.archiveContentByArchive("../transferencias/podeir.txt")
        if value then
            local atirador = comunicate.archiveContentByArchive("../transferencias/atirador.txt")
            local alvo = comunicate.archiveContentByArchive("../transferencias/alvo.txt")
            local quantia = comunicate.archiveContentByArchive("../transferencias/quantia.txt")
            local atiradorMoney = comunicate.archiveContentByArchive("../values/users/"..atirador.."/money.txt")
            local alvoMoney = comunicate.archiveContentByArchive("../values/users/"..alvo.."/money.txt")
            atiradorMoney = atiradorMoney - quantia
            alvoMoney = alvoMoney + quantia
            os.execute("cd ../values/users/"..atirador.." ; echo "..atiradorMoney.." > money.txt")
            os.execute("cd ../values/users/"..alvo.." ; echo "..alvoMoney.." > money.txt")
            os.execute("cd ../../client ; echo true > transferenciaAproved.txt")
            print("transferencia feita de "..atirador.." para "..alvo.." com o valor de "..quantia) 
        end
    end
    os.execute("cd ../transferencias ; echo false > podeir.txt")
    comunicate.subFunctions.sleep(1)
end
