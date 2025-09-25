local Constants = require("Util/Constants")
local Timer = require("Util/Timer")
local Card = require("Cards/Card")

local class = {}
local deck = {}

function class.init()
  deck.canDraw = true
  deck.drawTimer = Timer.create("deckDrawCard", .5, false,
    function()
      deck.canDraw = true
    end
  )

  deck.cards = {}
  deck.backs = {
    "Back_red1", "Back_red2", "Back_red3", "Back_red4", "Back_red5",
    "Back_green1", "Back_green2", "Back_green3", "Back_green4", "Back_green5",
    "Back_blue1", "Back_blue2", "Back_blue3", "Back_blue4", "Back_blue5"
  }

  deck.back = deck.backs[math.random(#deck.backs)]
  deck.spriteBack = love.graphics.newImage("Assets/Sprites/Cards/card" .. deck.back .. ".png")

  deck.x = 10
  deck.y = 10
  deck.width = deck.spriteBack:getWidth()
  deck.height = deck.spriteBack:getHeight()

  for color = 1, 4 do
    for value = 1, 13 do
      local card = Card.create(color, value, deck.back, -5000, -5000)
      table.insert(deck.cards, card)
    end
  end
end

function class.getSpriteBack()
  return deck.spriteBack
end

function class.getPosition()
  return {
    x = deck.x,
    y = deck.y
  }
end

function class.getCardSize()
  return { 
    width = deck.width,
    height = deck.height
  }
end

function class.getBoundingBox()
  return {
    x = deck.x * Constants.scale,
    y = deck.y * Constants.scale,
    width = deck.width * Constants.scale,
    height = deck.height * Constants.scale
  }
end

function class.getCount()
  return #deck.cards
end

function class.addCard(_card)
  _card:setPosition(-5000, -5000)
  _card.isUncovered = false

  table.insert(deck.cards, _card)
end

function class.shuffle()
  for i = #deck.cards, 2, -1 do
    local random = math.random(i)

    local temp = deck.cards[i]
    deck.cards[i] = deck.cards[random]
    deck.cards[random] = temp
  end
end

function class.drawCard(_isForced)
  if (deck.canDraw or _isForced) then
    if (#deck.cards > 0) then
      local card = deck.cards[1]
      card.isInDeck = false

      table.remove(deck.cards, 1)

      deck.canDraw = false
      deck.drawTimer:play()

      return card
    end
  end

  return nil
end

return class