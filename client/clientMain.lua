print("sistema bancario iniciando...")
--modules
local comunicate = require("comunicateModule")

--objects
local serverLocation = "/home/lao/Desktop/pastas/SistemaBancario/server"
local serverStatusLocation = serverLocation.."/values/serverStatus"
local serverUsersLocation = serverLocation.."/values/users"
local serverValuesLocation = serverLocation.."/values"

local user = nil
local userMoney = nil
local userName = nil

-- functions
local function verificarServerOnline()
    local serverActive = comunicate.archiveContentByArchive(serverStatusLocation.."/active.txt")

    while not serverActive do
    print("o serividor esta ofline, digite qualquer tecla para tentar novamente")
        local a = io.read()
        serverActive = comunicate.archiveContentByArchive(serverStatusLocation.."/active.txt")
    end
end

local function serverBeOn()
    local serverActive = comunicate.archiveContentByArchive(serverStatusLocation.."/active.txt")
    if serverActive then
        return true
    else
        return false
    end
end
print("modulos carregados!")
print("sistema bancario iniciado!")
print("verificando se o servidor esta online...")

::serveroff::
verificarServerOnline()
print("o servidor esta online!")

::entrar::
print("entrar:\n")
print("digite L para loggin ou S para signup")
local reposta = string.upper(io.read())
if reposta == "L" then
    ::loggin::
    print("digite o nome de usuario")
    local username = io.read()
    print("digite sua senha")
    local password = io.read()
    local alreadyRegistred = comunicate.subFunctions.haveArchive(serverUsersLocation.."/"..username)
    if not alreadyRegistred then
        print("esse nome de usuario nao existe!")
        goto loggin
    end
    local realpassword = comunicate.archiveContentByArchive(serverUsersLocation.."/"..username.."/".."password.txt")
    if realpassword ~= password then
        print("voce digitou a senha errada!")
        goto loggin
    end
    user = serverUsersLocation.."/"..username
    userMoney = user.."/".."money.txt"
    userName = username
    print("logado com sucesso!")
elseif reposta == "S" then
    ::signup::
    print("digite o nome de usuario")
    local username = io.read()
    print("digite sua senha")
    local password = io.read()
    local alreadyRegistred = comunicate.subFunctions.haveArchive(serverUsersLocation.."/"..username)
    if alreadyRegistred then
        print("esse nome de usuario ja existe!")
        goto signup
    end
    local serveronline = serverBeOn()
    if serveronline then
        local command = "cd / ; cd "..serverUsersLocation.." ; mkdir "..username.." ; cd "..username.." ; touch money.txt ; touch password.txt ; echo 0 > money.txt ; echo ".. password.." > password.txt"
        os.execute(command)
        os.execute("cd "..serverValuesLocation.."/prints ; echo "..username.." > newUser.txt")
        print("Registrado com sucesso!\nagora fassa o login!\n")
        goto entrar
    else
        print("não foi possivel registrar pois o server esta ofline")
        goto serveroff
    end

else
    print("voce digitou algo errado!")
    goto entrar
end


local commands = {
    verdinheiro = {
        inputSTR = "verdinheiro",
        executar = function()
            local dinheiro = comunicate.archiveContentByArchive(userMoney)
            print("voce tem "..dinheiro.."$")
        end
    },
    transferir = {
        inputSTR = "transferir",
        executar = function()
            local serveron = serverBeOn()
            if serveron then
                local atirador = userName
                ::tranferencia::
                print("digite o nome de usuario da pessoa que voce que transferir:")
                local alvo = io.read()
                local alreadyRegistred = comunicate.subFunctions.haveArchive(serverUsersLocation.."/"..alvo)
                if not alreadyRegistred then
                    print("esse nome de usuario nao existe!")
                    goto tranferencia
                end
                ::quantia::
                print("quanto deseja transferir?")
                local quantia = io.read()
                local numero = comunicate.subFunctions.isNumber(quantia)
                if not numero then
                    print("isso não é um numero")
                    goto quantia
                end
                quantia = tonumber(quantia)
                local quantoVoceTem = comunicate.archiveContentByArchive(userMoney)
                if quantia > quantoVoceTem then
                    print("voce não tem esse dinheiro!")
                    goto quantia
                end
                quantia = tostring(quantia)
                print("fazendo transferencia...")
                os.execute("cd "..serverLocation.."/transferencias ; echo "..quantia.." > quantia.txt ; echo "..alvo.." > alvo.txt ; echo "..atirador.." > atirador.txt ; echo true > podeir.txt")
                local transferenciaAproved =  comunicate.archiveContentByArchive("transferenciaAproved.txt")
                while not transferenciaAproved == true do
                    print(type(transferenciaAproved))
                    print(transferenciaAproved)
                    transferenciaAproved =  comunicate.archiveContentByArchive("transferenciaAproved.txt")
                    comunicate.subFunctions.sleep(1)
                end
                os.execute("echo false > transferenciaAproved.txt")
                print("tranferencia feita!")
            else
                print("o servidor esta ofline")
            end
        end
    },
    ajuda = {
        inputSTR = "ajuda",
        executar = function()
            print("comandos:\n\ntransferir\nsair\nverdinheiro\ndeslogar")
        end
    },
}

print("\n\n\naguardando os commandos\ncaso nao saiba os commandos, digite \"ajuda\" para ver-os")
while true do
    local input = io.read()
    for _,comando in pairs(commands) do
        if comando.inputSTR == input then
            comando.executar()
        end
    end
    if input == "deslogar" then
        user = nil
        userMoney = nil
        userName = nil
        goto entrar
    elseif input == "sair" then
            goto final
    end
end
::final::