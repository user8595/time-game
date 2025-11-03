local json = require("lib.json")
hiPerf = {
    normal = 0,
    random = 0
}

function newSave(jsonData, defData)
    if love.filesystem.read(jsonData) == nil then
        love.filesystem.write(jsonData, json.encode(defData))
    end
end

function loadOptions()
    decO = json.decode(love.filesystem.read("options.json"))
    isAudio, buttonSkin, shakeEnabled = decO.audio, decO.skin, decO.shakeEnabled
end

function loadScore()
    decSC = json.decode(love.filesystem.read("score.json"))
    hiPerf.normal, hiPerf.random = decSC.normal, decSC.random
end

function saveData(jsonData, changedData)
    if love.filesystem.read(jsonData) then
        love.filesystem.write(jsonData, json.encode(changedData))
    end
end