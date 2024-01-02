local list = io.popen("ls","r")
local listProcessed = list:read("*all")
local finalCommand = ""
local controlVar = 1
for valueName in listProcessed:gmatch("[^\n]+") do
    if string.find(valueName, ".lua") then
        if not string.find(valueName,"Module") and not string.find(valueName,"start.lua") and not string.find(valueName,"serverControler.lua") then
            if controlVar == 1 then
                finalCommand = finalCommand.."lua "..valueName.." "
                controlVar = 2
            else
                finalCommand = finalCommand.."& lua "..valueName.." "
            end
        end
    end
end
os.execute(finalCommand)