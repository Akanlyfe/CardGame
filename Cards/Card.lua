local Constants = require("Util/Constants")

local class = {}

function class.create(_cardName, _x, _y)
  local card = {
    name = _cardName,
    sprite = love.graphics.newImage("Assets/Sprites/Cards/card" .. _cardName .. ".png"),
    x = _x,
    y = _y
  }

  card.width = card.sprite:getWidth()
  card.height = card.sprite:getHeight()

  function card:setPosition(_newX, _newY)
    self.x = _newX
    self.y = _newY
  end

  function card:getBoundingBox()
    local boundingBox = {}

    boundingBox.x = self.x
    boundingBox.y = self.y
    boundingBox.width = self.width * Constants.scale
    boundingBox.height = self.height * Constants.scale

    return boundingBox
  end

  return card
end

return class