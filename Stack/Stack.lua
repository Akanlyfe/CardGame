local Constants = require("Util/Constants")

local class = {}
class.__index = class

function class:new(_x, _y, _width, _height)
  local stack = setmetatable({
      x = _x,
      y = _y,
      width = _width,
      height = _height,

      cards = {}
      }, self)

  return stack
end

function class:canAccept(_card)
  return true
end

function class:addCard(_card)
  if (_card.previous) then
    _card.previous.next = nil
  end

  _card:moveTo(self.x, self.y)

  table.insert(self.cards, 1, _card)
end

function class:getBoundingBox()
  return {
    x = self.x * Constants.scale,
    y = self.y * Constants.scale,
    width = self.width * Constants.scale,
    height = self.height * Constants.scale
  }
end

return class