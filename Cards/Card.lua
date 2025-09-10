local Constants = require("Util/Constants")

local class = {}

function class.create(_cardName, _x, _y)
  local card = {
    name = _cardName,
    sprite = love.graphics.newImage("Assets/Sprites/Cards/card" .. _cardName .. ".png"),
    x = _x,
    y = _y,
    width = 150 * Constants.scale,
    height = 200 * Constants.scale
  }
  
  function card:setPosition(_newX, _newY)
    self.x = _newX
    self.y = _newY
  end

  return card
end

return class