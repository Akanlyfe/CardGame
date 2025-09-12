local Constants = require("Util/Constants")
local AkanMath = require("Util/Lib/AkanMath")

local class = {}
local speed = 100

function class.create(_cardName, _x, _y)
  local card = {
    name = _cardName,
    sprite = love.graphics.newImage("Assets/Sprites/Cards/card" .. _cardName .. ".png"),
    x = _x,
    y = _y,
    nextX = _x,
    nextY = _y
  }

  card.width = card.sprite:getWidth()
  card.height = card.sprite:getHeight()

  function card:setPosition(_newX, _newY)
    self.nextX = _newX
    self.nextY = _newY
  end

  function card:getBoundingBox()
    local boundingBox = {}

    boundingBox.x = self.x * Constants.scale
    boundingBox.y = self.y * Constants.scale
    boundingBox.width = self.width * Constants.scale
    boundingBox.height = self.height * Constants.scale

    return boundingBox
  end

  function card:update(_dt)
    if (card.nextX ~= card.x or card.nextY ~= card.y) then
      local distance = {
        x = card.nextX - card.x,
        y = card.nextY - card.y
      }

      distance.length = AkanMath.length(distance)
      if (distance.length == 0) then return end

      local step = (speed + distance.length) * _dt

      if (step >= distance.length) then
        card.x = card.nextX
        card.y = card.nextY
      else
        local direction = AkanMath.normalize(distance)
        card.x = card.x + direction.x * (speed + distance.length) * _dt
        card.y = card.y + direction.y * (speed + distance.length) * _dt
      end
    end
  end

  return card
end

return class