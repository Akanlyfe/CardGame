local Constants = require("Util/Constants")
local DrawAPI = require("Util/DrawAPI")

local class = {}
local stackList = {}

function class.init(_cardWidth, _cardHeight)
  stackList = {}

  class.width = _cardWidth
  class.height = _cardHeight
  
  -- TODO Create stacks
end

function class.register(_stack)
  table.insert(stackList, _stack)
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