local Constants = require("Util/Constants")
local DrawAPI = require("Util/DrawAPI")

local class = {}
local stackList = {}

local cardWidth
local cardHeight

local function createStack(_x, _y, _isFinal, _color)
  local stack = {
    x = _x,
    y = _y,
    width = cardWidth,
    height = cardHeight,

    color = _color or nil,
    isFinal = _isFinal,

    cards = {}
  }

  function stack:getBoundingBox()
    return {
      x = self.x * Constants.scale,
      y = self.y * Constants.scale,
      width = self.width * Constants.scale,
      height = self.height * Constants.scale
    }
  end

  table.insert(stackList, stack)
end

function class.init(_cardWidth, _cardHeight)
  stackList = {}

  cardWidth = _cardWidth
  cardHeight = _cardHeight

  local baseX = 10
  for i = 1, 7 do
    createStack(baseX + i * cardWidth * 1.5, cardHeight * 1.5 + cardHeight / 5, false)
  end

  baseX = 10 + cardWidth * 4.5
  for i = 0, 3 do
    createStack(baseX + i * cardWidth * 1.5, 10, true, i + 1)
  end
end

function class.getStacks()
  return stackList
end

function class.draw()
  for _, stack in pairs(stackList) do
    DrawAPI.rectangle(Constants.priority.low, Constants.color.red, 'line', stack.x, stack.y, stack.width, stack.height)
  end
end

return class