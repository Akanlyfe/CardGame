local Constants = require("Util/Constants")
local Collision = require("Util/Collision")
local Timer = require("Util/Timer")
local DrawAPI = require("Util/DrawAPI")
local Sound = require("Util/Sound")

local AkanAPI = require("Util/Lib/AkanAPI")
local AkanEase = AkanAPI.ease
local AkanMath = AkanAPI.math

local class = {}
local cards = {}
local speed = 100

local function getCardName(_card)
  local color = AkanAPI.switchString(_card.color, {
      [1] = "Spades", [2] = "Hearts",
      [3] = "Clubs",  [4] = "Diamonds",

      default = "Spades"
    })

  local value = AkanAPI.switchString(_card.value, {
      [1] = "A",    [2] = "2",    [3] = "3",
      [4] = "4",    [5] = "5",    [6] = "6",
      [7] = "7",    [8] = "8",    [9] = "9",
      [10] = "10",  [11] = "J",
      [12] = "Q",   [13] = "K",

      default = "A"
    })

  return color .. value
end

local function updateStack(_card, _update)
  if (_card.next) then
    _update(_card.next)
    updateStack(_card.next, _update)
  end
end

local function belongsToStack(_root, _target)
  local current = _root
  while current do
    if current == _target then
      return true 
    end

    current = current.next
  end

  return false
end

function class.create(_color, _value, _cardBack, _x, _y)
  local card = {
    color = _color,
    value = _value,

    spriteBack = love.graphics.newImage("Assets/Sprites/Cards/card" .. _cardBack .. ".png"),

    isSelected = false,
    dragOffsetX = 0,
    dragOffsetY = 0,

    isUncovered = false,
    canFlip = true,
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

    scaleX = 1,
    priority = Constants.priority.normal,

    flipSound = Sound.create("Cards/cardPlace" .. math.random(4), "ogg", "stream", 1, false)
  }

  local cardName = getCardName(card)
  card.name = cardName

  card.sprite = love.graphics.newImage("Assets/Sprites/Cards/card" .. cardName .. ".png")

  card.width = card.sprite:getWidth()
  card.height = card.sprite:getHeight()

  card.timer = Timer.create("card" .. cardName .. "Flip", 0.15, false,
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
        card.canFlip = true
      end
    end
  )

  card.previous = nil
  card.next = nil

  function card:flip()
    if (not self.canFlip) then return end

    self.canFlip = false
    self.isFlipping = true
    self.timer:play()

    self.flipSound = Sound.create("Cards/cardPlace" .. math.random(4), "ogg", "stream", 1, false)
    self.flipSound:play()
  end

  function card:setPosition(_newX, _newY)
    self.x = _newX
    self.y = _newY

    card:updateStackPositions()
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

  function card:pickUp()
    local x, y = love.mouse.getPosition()
    local worldX, worldY = Constants.screenToWorld(x, y)

    self.isSelected = true
    self.dragOffsetX = worldX - self.x
    self.dragOffsetY = worldY - self.y

    self.startX = self.x
    self.startY = self.y

    self.priority = Constants.priority.high

    if (self.previous) then
      self.previous.next = nil
      self.previous = nil
    end

    if (self.next) then
      updateStack(self,
        function(_card)
          _card.priority = _card.previous.priority + 1
        end
      )
    end
  end

  function card:drop(_stackRule)
    local isStacked = false

    self.isSelected = false
    self.priority = Constants.priority.normal

    updateStack(self,
      function(_card)
        _card.priority = Constants.priority.normal
      end
    )

    for i = #cards, 1, -1 do
      local cardClicked = cards[i] or nil

      if (self ~= cardClicked
        and not belongsToStack(self, cardClicked)
        and Collision.isRectangleRectangleColliding(self:getBoundingBox(), cardClicked:getBoundingBox())) then
        self:stackOn(cardClicked, _stackRule or nil)
        isStacked = _stackRule(self, cardClicked)
        break
      end
    end

    if (not isStacked) then
      self.x = self.startX
      self.y = self.startY
    end

    self:updateStackPositions()
  end

  function card:stackOn(_card, _acceptFunction)
    local canStack = true
    if (_acceptFunction) then
      canStack = _acceptFunction(self, _card)
    end

    if (not canStack) then
      return
    end

    if (_card.next == nil) then
      _card.next = self
      self.previous = _card

      self:setPosition(_card.x, _card.y + self.height / 5)
    else
      self:stackOn(_card.next)
    end
  end

  function card:updateStackPositions()
    local current = self.next
    local offset = self.height / 5
    local y = self.y

    while current do
      y = y + offset

      current.x = self.x
      current.y = y

      current = current.next
    end
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

      self:updateStackPositions()

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
    local sprite = (self.isUncovered) and card.sprite or card.spriteBack

    DrawAPI.draw(self.priority, Constants.color.white, sprite, card.x + card.width / 2, card.y, 0, card.scaleX, 1, card.width / 2, 0)
  end

  table.insert(cards, card)

  return card
end

function class.getCardCount()
  return #cards
end

function class.getCard(_i)
  return cards[_i] or nil
end

function class.clear()
  cards = {}
end

function class.update(_dt)
  for _, card in pairs(cards) do
    card:update(_dt)
  end
end

function class.draw()
  table.sort(cards, AkanAPI.prioritySorting)
  for _, card in pairs(cards) do
    card:draw()
  end
end

return class