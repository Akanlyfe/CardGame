local Constants = require("Util/Constants")

local StackManager = require("Stack/StackManager")

local class = {}
class.__index = class

function class:new(_x, _y)
  local stack = setmetatable({
      x = _x,
      y = _y,
      width = StackManager.width,
      height = StackManager.height,

      cards = {}
      }, self)

  StackManager.register(stack)

  return stack
end

function class:canAccept(_card)
  return true
end

function class:addCard(_card)
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