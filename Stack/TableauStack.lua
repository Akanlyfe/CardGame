local Constants = require("Util/Constants")

local Stack = require("Stack/Stack")

local class = setmetatable({}, { __index = Stack })
class.__index = class

function class:new(_x, _y, _width, _height)
  return Stack.new(self, _x, _y, _width, _height)
end

function class:canAccept(_card)
  if (#self.cards == 0) then
    return _card.value == 13
  else
    local topCard = self.cards[1]
    return (_card.color % 2 ~= topCard.color % 2) and (_card.value == topCard.value - 1)
  end
end

return class