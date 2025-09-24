local Constants = require("Util/Constants")
local Collision = require("Util/Collision")

local GameState = require("GameState/GameState")
local Deck = require("Cards/Deck")
local Card = require("Cards/Card")
local FinalStack = require("Cards/FinalStack")

local DrawAPI = require("Util/DrawAPI")
local AkanMath = require("Util/Lib/AkanMath")

local class = {}
local solitaire = {}

function solitaire.stackRule(_card, _cardNext)
  return (_card.color % 2 ~= _cardNext.color % 2) and (_card.value == _cardNext.value + 1)
end

function class.load()
  Deck.init()
  Deck.shuffle()

  local previousCard = nil
  for i = 1, 7 do
    for j = 1, i do
      local card = Deck.drawCard()
      local x = 10 + i * card.width * 1.5
      local y = card.height * 1.5 + j * card.height / 5

      card:setPosition(x, y)

      if (j > 1 and previousCard ~= nil) then
        card:stackOn(previousCard)
      end

      if (j == i) then
        card.isUncovered = true
      end

      previousCard = card
    end
  end

  FinalStack.init(previousCard.width, previousCard.height)
end

function class.unload()
  Card.clear()
  collectgarbage('collect')
end

function class.update(_dt)
end

function class.draw()
  love.graphics.setBackgroundColor(0, .5, 0, 1)

  if (Deck.getCount() > 0) then
    DrawAPI.draw(Constants.priority.normal, Constants.color.white, Deck.getSpriteBack(), Deck.getPosition().x, Deck.getPosition().y)
  end

  FinalStack.draw()
end

function class.keypressed(_key)
  if (_key == 'tab') then
    GameState.request("gameOver")
  end
end

function class.mousepressed(_x, _y, _button)
  local mousePosition = {
    x = _x,
    y = _y
  }

  if (_button == 1) then
    if (Deck.getCount() > 0) then
      local deckPosition = Deck.getPosition()
      local deckBB = Deck.getBoundingBox()

      if (Collision.isPointRectangleColliding(mousePosition, deckBB)) then
        local card = Deck.drawCard()
        if (solitaire.previousPriority) then
          card.priority = solitaire.previousPriority + 1
        end

        solitaire.previousPriority = card.priority

        card:setPosition(deckPosition.x, deckPosition.y)
        card:moveTo(deckPosition.x + deckBB.width * 3, deckPosition.y)
        card:flip()
      end
    end

    if (Card.getCardCount() > 0) then
      for i = Card.getCardCount(), 1, -1 do
        local card = Card.getCard(i)
        if (Collision.isPointRectangleColliding(mousePosition, card:getBoundingBox())) then
          card:pickUp(solitaire.stackRule)
          break
        end
      end
    end
  elseif (_button == 2) then
    if (Card.getCardCount() > 0) then
      for i = Card.getCardCount(), 1, -1 do
        local card = Card.getCard(i)
        if (Collision.isPointRectangleColliding(mousePosition, card:getBoundingBox())) then
          card:flip()
          break
        end
      end
    end
  end
end

function class.mousereleased(_x, _y, _button)
  if (_button == 1) then
    if (Card.getCardCount() > 0) then
      for i = Card.getCardCount(), 1, -1 do
        local card = Card.getCard(i)

        if (card.isSelected) then
          card:drop(solitaire.stackRule)
          break
        end
      end
    end
  end
end

function class.mousemoved(_x, _y, _moveX, _moveY)
  if (love.mouse.isDown(1)) then
    if (Card.getCardCount() > 0) then
      for i = Card.getCardCount(), 1, -1 do
        local card = Card.getCard(i)
        if (card.isSelected) then
          local worldX, worldY = Constants.screenToWorld(_x, _y)
          card:setPosition(worldX - card.dragOffsetX, worldY - card.dragOffsetY)
          break
        end
      end
    end
  end
end

return class