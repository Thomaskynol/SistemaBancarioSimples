comunicate = {subFunctions = {}}

function comunicate.subFunctions.haveArchive(arquivo)
    local arquivo = io.open(arquivo, "r")
    if arquivo then
        arquivo:close()
        return true
    else
        return false
    end
end

function comunicate.subFunctions.isNumber(str)
    if str ~= nil then
        return string.match(str, "^[0-9.]+$") ~= nil
    else
        return false
    end
end

function comunicate.subFunctions.sleep(n)
    os.execute("sleep " .. tonumber(n))
end

function comunicate.subFunctions.archiveContentByString(str)
    if comunicate.subFunctions.isNumber(str) then
        return tonumber(str)
    elseif str == "false" or str == "true" then
        local value = str == "true"
        return value
    else
        return str
    end
end
function comunicate.archiveContentByArchive(archiveName)
    local arquivo = io.open(archiveName, "r")
    if arquivo then
        local arquivoString = arquivo:read("*l")
        if comunicate.subFunctions.isNumber(arquivoString) then
            return tonumber(arquivoString)
        elseif arquivoString == "false" or arquivoString == "true" then
            local value = arquivoString == "true"
            return value
        else
            return arquivoString
        end
    else
        print("o arquivo não existe")
        return nil
    end
end

function comunicate.setArchive(archiveName, EXTvar)
    local arquivo = io.open(archiveName, "r")
    if arquivo then
        local arquivoString = arquivo:read("*l")
        if arquivoString ~= EXTvar then
            print("mudança detectada")
            EXTvar = arquivoString
            arquivo:close()
            return true, EXTvar
        else
            --print("sem mudanças")
            arquivo:close()
            return false, EXTvar
        end 
    else
        print("o arquivo não existe")
        return false, EXTvar
    end
end

return comunicate