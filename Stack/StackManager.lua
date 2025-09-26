local Constants = require("Util/Constants")
local DrawAPI = require("Util/DrawAPI")

local FinalStack = require("Stack/FinalStack")
local TableauStack = require("Stack/TableauStack")

local class = {}
local stackList = {}

function class.init(_cardWidth, _cardHeight)
  stackList = {}

  class.width = _cardWidth
  class.height = _cardHeight

  -- TODO Create stacks
  local baseX = 10
  for i = 1, 7 do
    local stack = TableauStack:new(baseX + i * _cardWidth * 1.5, _cardHeight * 1.5 + _cardHeight / 5, _cardWidth, _cardHeight)
    class.register(stack)
  end

  baseX = 10 + _cardWidth * 4.5
  for i = 0, 3 do
    local stack = FinalStack:new(baseX + i * _cardWidth * 1.5, 10, _cardWidth, _cardHeight, i + 1)
    class.register(stack)
  end
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