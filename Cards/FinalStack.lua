local Constants = require("Util/Constants")
local DrawAPI = require("Util/DrawAPI")

local class = {}
local finalStackList = {}

function class.init(_cardWidth, _cardHeight)
  local baseX = 10 + _cardWidth * 4.5

  for i = 0, 3 do
    local finalStack = {
      x = baseX + i * _cardWidth * 1.5,
      y = 10,
      width = _cardWidth,
      height = _cardHeight,

      cards = {}
    }

    function finalStack:getBoundingBox()
      return {
        x = self.x * Constants.scale,
        y = self.y * Constants.scale,
        width = self.width * Constants.scale,
        height = self.height * Constants.scale
      }
    end

    table.insert(finalStackList, finalStack)
  end
end

function class.getFinalStacks()
  return finalStackList
end

function class.draw()
  for _, stack in pairs(finalStackList) do
    DrawAPI.rectangle(Constants.priority.low, Constants.color.red, 'line', stack.x, stack.y, stack.width, stack.height)
  end
end

return class