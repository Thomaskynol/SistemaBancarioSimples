local ciclo = true

local commands = {
    stop = {
        inputSTR = "stop",
        executar = function()
            print("server encerrando")
            os.execute("cd ../values/serverStatus ; echo false > active.txt")
            print("server encerrado")
            ciclo = false
        end
    }
}

while ciclo do
    local input = io.read()
    for _, comand in pairs(commands) do
       if input == comand.inputSTR then
            comand.executar()
       end 
    end
end

