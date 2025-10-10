local Constants = require("Util/Constants")
local Collision = require("Util/Collision")
local Timer = require("Util/Timer")
local DrawAPI = require("Util/DrawAPI")
local Sound = require("Util/Sound")

local StackManager = require("Stack/StackManager")

local AkanAPI = require("Util/Lib/AkanAPI")
local AkanEase = AkanAPI.ease
local AkanMath = AkanAPI.math

local class = { UID = 0 }
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
  _update(_card)
  if (_card.next) then
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

local function isValidStack(_root, _stackRule)
  local current = _root
  while current.next do
    if (not _stackRule(current, current.next)) then
      return false
    end

    current = current.next
  end

  return true
end

function class.create(_color, _value, _cardBack, _x, _y)
  class.UID = class.UID + 1
  local card = {
    UID = class.UID,
    color = _color,
    value = _value,

    spriteBack = love.graphics.newImage("Assets/Sprites/Cards/card" .. _cardBack .. ".png"),

    isSelected = false,
    dragOffsetX = 0,
    dragOffsetY = 0,

    isInDeck = true,

    isUncovered = false,
    canFlip = true,
    isFlipping = false,
    flipState = 0,

    canStack = true,

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
    previousPriority = Constants.priority.normal,
    priority = Constants.priority.normal,

    flipSoundList = {}
  }

  local cardName = getCardName(card)
  card.name = cardName

  card.sprite = love.graphics.newImage("Assets/Sprites/Cards/card" .. cardName .. ".png")

  card.width = card.sprite:getWidth()
  card.height = card.sprite:getHeight()

  card.flipTimer = Timer.create("card" .. cardName .. "Flip", 0.15, false,
    function()
      if (card.flipState == 0) then
        card.flipState = 1

        card.isUncovered = not card.isUncovered

        card.flipTimer:reset()
        card.flipTimer:play()
      elseif (card.flipState == 1) then
        card.flipState = 0

        card.isFlipping = false
        card.canFlip = true
      end
    end
  )

  for i = 1, 4 do
    local sound = Sound.create("Cards/cardPlace" .. i, "ogg", "stream", 1, false)
    table.insert(card.flipSoundList, sound)
  end
  card.flipSound = card.flipSoundList[math.random(#card.flipSoundList)]

  card.previous = nil
  card.next = nil

  function card:setPosition(_newX, _newY)
    self.x = _newX
    self.y = _newY

    self:updateStackPositions()
  end

  function card:moveTo(_nextX, _nextY, _duration)
    self.previousPriority = self.priority

    self.startX = self.x
    self.startY = self.y
    self.nextX = _nextX
    self.nextY = _nextY

    self.moveTime = 0
    self.moveDuration = _duration or .5
    self.isMoving = true
  end

  function card:flip()
    if (not self.canFlip) then return end

    self.canFlip = false
    self.isFlipping = true

    self.flipTimer:play()

    self.flipSound:stop()
    self.flipSound = self.flipSoundList[math.random(#self.flipSoundList)]
    self.flipSound:play()
  end

  function card:pickUp(_stackRule)
    if ((not self.isUncovered) or (self.next and _stackRule and not isValidStack(self, _stackRule))) then
      return false
    end

    local x, y = love.mouse.getPosition()
    local worldX, worldY = Constants.screenToWorld(x, y)

    self.isSelected = true
    self.dragOffsetX = worldX - self.x
    self.dragOffsetY = worldY - self.y

    self.startX = self.x
    self.startY = self.y

    self.previousPriority = self.priority
    self.priority = Constants.priority.high

    if (self.next) then
      updateStack(self,
        function(_card)
          if (_card.previous) then
            _card.priority = _card.previous.priority + 1
          end
        end
      )
    end

    return true
  end

  function card:drop(_stackRule)
    local isStacked = false
    local stackList = StackManager.getStacks()
    local selectedStack = nil

    self.isSelected = false

    updateStack(self,
      function(_card)
        _card.priority = Constants.priority.normal
      end
    )

    -- Try drop on other card
    for i = #cards, 1, -1 do
      local cardClicked = cards[i] or nil

      if (self ~= cardClicked
        and cardClicked.canStack
        and cardClicked.next ~= self
        and not belongsToStack(self, cardClicked)
        and Collision.isRectangleRectangleColliding(self:getBoundingBox(), cardClicked:getBoundingBox())) then
        isStacked = self:stackOn(cardClicked, _stackRule or nil)
        -- TODO Instead of just breaking on the "first" card found
        -- add colliding card to another list and then run thrue this list? (maybe check the "most collided" first?)
        break
      end
    end

    -- Try drop on stack
    if (not isStacked) then
      for _, stack in pairs(stackList) do
        if (Collision.isRectangleRectangleColliding(self:getBoundingBox(), stack:getBoundingBox())) then
          if (stack:canAccept(self)) then
            stack:addCard(self)
            isStacked = true
            selectedStack = stack
          end
        end
      end
    end

    -- Clean other stacks
    if (isStacked) then
      for _, stack in pairs(stackList) do
        if (stack ~= selectedStack) then
          for cardID, cardInStack in pairs(stack.cards) do
            if (cardInStack == self) then
              cardInStack.canStack = true
              table.remove(stack.cards, cardID)
              
              -- TODO Flip previous card in stack.
            end
          end
        end
      end
    else
      self.priority = self.previousPriority
      self:moveTo(self.startX, self.startY)
    end

    return isStacked
  end

  function card:stackOn(_card, _acceptFunction)
    local canStack = true
    if (_acceptFunction) then
      canStack = _acceptFunction(_card, self)
    end

    if ((not canStack) or self.isMoving) then
      return false
    end

    if (_card.next == nil) then
      if (self.previous) then
        self.previous.next = nil
      end

      _card.next = self
      self.previous = _card

      self:moveTo(_card.x, _card.y + self.height / 5)
      return true
    else
      return self:stackOn(_card.next)
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

        self.priority = self.previousPriority
      end
    end

    if (self.isFlipping) then
      local t = self.flipTimer:getTime() / self.flipTimer:getDuration()
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
  table.sort(cards, AkanAPI.prioritySorting)

  for _, card in pairs(cards) do
    card:update(_dt)
  end
end

function class.draw()
  for _, card in pairs(cards) do
    card:draw()
  end
end

return class