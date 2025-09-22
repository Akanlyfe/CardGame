local Constants = require("Util/Constants")
local Collision = require("Util/Collision")

local GameState = require("GameState/GameState")
local Deck = require("Cards/Deck")
local Card = require("Cards/Card")

local AkanMath = require("Util/Lib/AkanMath")

local class = {}
local solitaire = {}

function solitaire.dropRule(_cardToPlace, _targetCard)
  -- TODO Check color like for real color, currently checking Spades is different from Clubs -> OK, but it is not OK!
  return (_cardToPlace.color ~= _targetCard.color) and (_cardToPlace.value == _targetCard.value - 1)
end

function class.load()
  Deck.init()
  Deck.shuffle()

  local previousCard = nil
  for i = 1, 7 do
    for j = 1, i do
      local card = Deck.drawCard()
      local x = card.width / 2 + card.width * 1.5 * i
      local y = card.height + card.height / 2 + j * card.height / 5

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