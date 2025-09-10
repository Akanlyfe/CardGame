local class = {}
local saveSystem = {}

local function updateKeysAndValues()
  saveSystem.saveKeys = {
    "version"
  }

  saveSystem.saveValues = {
    string.sub(love.window.getTitle(), string.find(love.window.getTitle(), "%s") + 1)
  }
end

local function findTextInString(_string, _textToFind)
  return string.find(_string, _textToFind, 1, true)
end

function class.save()
  local saveText = ""

  updateKeysAndValues()

  for saveKeyID, saveKey in pairs(saveSystem.saveKeys) do
    saveText = saveText .. "\n[" .. saveKey .. "] " .. saveSystem.saveValues[saveKeyID]
  end

  love.filesystem.write(saveSystem.savePath, saveText)
end

function class.load()
  saveSystem.savePath = string.sub(love.window.getTitle(), 0, string.find(love.window.getTitle(), "%s") - 1) .. ".sav"

  updateKeysAndValues()

  if (love.filesystem.getInfo(saveSystem.savePath) ~= nil) then
    local saveLines = love.filesystem.lines(saveSystem.savePath)

    for line in saveLines do
      for _, saveKey in pairs(saveSystem.saveKeys) do
        if (findTextInString(line, "[" .. saveKey .. "]")) then
          saveSystem[saveKey] = string.sub(line, string.find(line, "%s") + 1)
        end
      end
    end
  end
end

return class