local Constants = require("Util/Constants")
local Timer = require("Util/Timer")
local AkanMath = require("Util/Lib/AkanMath")
local AkanEase = require("Util/Lib/AkanEase")

local class = {}
local speed = 100

function class.create(_cardBack, _cardName, _x, _y)
  local card = {
    name = _cardName,
    spriteBack = love.graphics.newImage("Assets/Sprites/Cards/card" .. _cardBack .. ".png"),
    sprite = love.graphics.newImage("Assets/Sprites/Cards/card" .. _cardName .. ".png"),

    isUncovered = false,
    isFlipping = false,
    flipState = 0,

    x = _x,
    y = _y,
    startX = _x,
    startY = _y,
    nextX = _x,
    nextY = _y,

    moveTime = 0,
    moveDuration = 0,
    isMoving = false,

    scaleX = 1
  }

  card.width = card.sprite:getWidth()
  card.height = card.sprite:getHeight()

  card.timer = Timer.create(0.25,
    function()
      card.timer:pause()
      card.timer:reset()

      if (card.flipState == 0) then
        card.flipState = 1

        card.isUncovered = not card.isUncovered
        card.timer:play()
      elseif (card.flipState == 1) then
        card.flipState = 0

        card.isFlipping = false
      end
    end
  )

  function card:flip()
    self.isFlipping = true
    self.timer:play()
  end

  function card:setPosition(_newX, _newY)
    self.x = _newX
    self.y = _newY
  end

  function card:moveTo(_nextX, _nextY, _duration)
    self.startX = self.x
    self.startY = self.y
    self.nextX = _nextX
    self.nextY = _nextY

    self.moveTime = 0
    self.moveDuration = _duration or 0.5
    self.isMoving = true
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
    if (self.isMoving) then
      self.moveTime = math.min(self.moveTime + _dt, self.moveDuration)

      local t = self.moveTime / self.moveDuration
      local easedT = AkanEase.easeInOutQuad(t)

      self.x = self.startX + (self.nextX - self.startX) * easedT
      self.y = self.startY + (self.nextY - self.startY) * easedT

      if (self.moveTime >= self.moveDuration) then
        self.isMoving = false
      end
    end

    if (self.isFlipping) then
      local t = self.timer:getTime() / self.timer:getDuration()
      local easedT = AkanEase.easeInOutCubic(t)
      
      if (self.flipState == 0) then
        self.scaleX = AkanMath.lerp(1, 0, easedT)
      else
        self.scaleX = AkanMath.lerp(0, 1, easedT)
      end
    end
  end

  function card:draw()
    if (self.isUncovered) then
      love.graphics.draw(card.sprite, card.x + card.width / 2, card.y, 0, card.scaleX, 1, card.width / 2)
    else
      love.graphics.draw(card.spriteBack, card.x + card.width / 2, card.y, 0, card.scaleX, 1, card.width / 2)
    end
  end

  return card
end

return class