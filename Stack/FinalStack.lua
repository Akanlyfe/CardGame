local Constants = require("Util/Constants")

local Stack = require("Stack/Stack")

local class = setmetatable({}, { __index = Stack })
class.__index = class

function class:new(_x, _y, _width, _height, _color)
  local stack = Stack.new(self, _x, _y, _width, _height)
  stack.isFinal = true
  stack.color = _color

  return stack
end

function class:canAccept(_card)
  if (_card.next or _card.color ~= self.color) then
    return false
  end

  if (#self.cards == 0) then
    return _card.value == 1
  else
    return _card.value == self.cards[1].value + 1
  end
end

function class:addCard(_card)
  Stack.addCard(self, _card)

  _card.canStack = false
end

return class