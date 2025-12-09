local json = require("lib.json")
hiPerf = {
  normal = 0,
  random = 0,
  comboNormal = 0,
  comboRandom = 0
}

function newSave(jsonData, defData)
  if love.filesystem.read(jsonData) == nil then
    love.filesystem.write(jsonData, json.encode(defData))
  end
end

function loadOptions()
  decO = json.decode(love.filesystem.read("options.json"))
  if decO.audio == nil then
    decO.audio = true
  end
  if decO.skin == nil then
    decO.skin = 1
  end
  if decO.shakeEnabled == nil then
    decO.shakeEnabled = true
  end
  if decO.shakeEnabled == nil then
    decO.shakeEnabled = true
  end
  if decO.isFullscreen == nil then
    decO.isFullscreen = false
  end
  if decO.isVSync == nil then
    decO.isVSync = true
  end
  isAudio, buttonSkin, shakeEnabled, isFullscreen, isVSync = decO.audio, decO.skin, decO.shakeEnabled, decO.isFullscreen,
      decO.isVSync
end

function loadScore()
  decSC = json.decode(love.filesystem.read("score.json"))
  if decSC.normal == nil then
    decSC.normal = 0
  end
  if decSC.random == nil then
    decSC.random = 0
  end
  if decSC.comboNormal == nil then
    decSC.comboNormal = 0
  end
  if decSC.comboRandom == nil then
    decSC.comboRandom = 0
  end
  hiPerf.normal, hiPerf.random, hiPerf.comboNormal, hiPerf.comboRandom = decSC.normal, decSC.random, decSC.comboNormal,
      decSC.comboRandom
end

function saveData(jsonData, changedData)
  if love.filesystem.read(jsonData) then
    love.filesystem.write(jsonData, json.encode(changedData))
  end
end

