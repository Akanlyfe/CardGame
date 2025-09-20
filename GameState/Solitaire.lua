local Constants = require("Util/Constants")
local Collision = require("Util/Collision")

local GameState = require("GameState/GameState")
local Deck = require("Cards/Deck")
local Card = require("Cards/Card")

local AkanMath = require("Util/Lib/AkanMath")

local class = {}
local solitaire = {}

function solitaire.stackRule(_cardToPlace, _targetCard)
  return (_cardToPlace.color ~= _targetCard.color) and (_cardToPlace.value == _targetCard.value - 1)
end

function class.load()
  Deck.init()
  Deck.shuffle()

  solitaire.deckPile = Card.create(1, 1, Deck.getBack(), 10, 10)

  local previousCard = nil
  for i = 1, 7 do
    for j = 1, i do
      local card = Deck.drawCard()
      local x = solitaire.deckPile.x + solitaire.deckPile.width / 2 + solitaire.deckPile.width * 1.5 * i
      local y = solitaire.deckPile.y + solitaire.deckPile.height + solitaire.deckPile.height / 2 + j * solitaire.deckPile.height / 5

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
end

function class.unload()
  solitaire = {}
  Card.clear()
  collectgarbage('collect')
end

function class.update(_dt)
end

function class.draw()
  love.graphics.setBackgroundColor(0, .5, 0, 1)
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
--    if (Collision.isPointRectangleColliding(mousePosition, solitaire.deckPile:getBoundingBox())) then
--      if (Deck.count() > 0) then
--        local card = Deck.drawCard()
--        local x = solitaire.deckPile.x + solitaire.deckPile.width + 10
--        local y = solitaire.deckPile.y
--        local spacing = solitaire.deckPile.width / 4.5

--        card:setPosition(x + spacing, y)
--      end
--    end

    if (Card.getCardCount() > 0) then
      for i = Card.getCardCount(), 1, -1 do
        local card = Card.getCard(i)
        if (Collision.isPointRectangleColliding(mousePosition, card:getBoundingBox())) then
          card:pickUp()
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
    
    -- TODO REMOVE THIS DEBUG
  elseif (_button == 3) then
    if (Card.getCardCount() > 0) then
      for i = Card.getCardCount(), 1, -1 do
        local card = Card.getCard(i)
        if (Collision.isPointRectangleColliding(mousePosition, card:getBoundingBox())) then
          local current = card
          while current do
            print(current.name)
            current = current.next
          end
          break
        end
      end
    end
  end
end

function class.mousereleased(_x, _y, _button)
  local mousePosition = {
    x = _x,
    y = _y
  }

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