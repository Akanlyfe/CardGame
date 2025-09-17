local Constants = require("Util/Constants")
local Collision = require("Util/Collision")

local GameState = require("GameState/GameState")
local Deck = require("Cards/Deck")
local Card = require("Cards/Card")

local AkanMath = require("Util/Lib/AkanMath")

local class = {}
local inGame = {}

function class.load()
  Deck.init()
  Deck.shuffle()

  inGame.deckPile = Card.create(1, 1, Deck.getBack(), 10, 10)

  for i = 1, 7 do
    for j = 1, i do
      local card = Deck.drawCard()
      local x = inGame.deckPile.x + inGame.deckPile.width / 2 + inGame.deckPile.width * 1.5 * i
      local y = inGame.deckPile.y + inGame.deckPile.height + inGame.deckPile.height / 2 + j * inGame.deckPile.height / 5

      card:setPosition(x, y)

      if (j == i) then
        card.isUncovered = true
      end
    end
  end
end

function class.unload()
  inGame = {}
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
    if (Collision.isPointRectangleColliding(mousePosition, inGame.deckPile:getBoundingBox())) then
      if (Deck.count() > 0) then
        local card = Deck.drawCard()
        local x = inGame.deckPile.x + inGame.deckPile.width + 10
        local y = inGame.deckPile.y
        local spacing = inGame.deckPile.width / 4.5

        card:setPosition(x + spacing, y)
      end
    end

    if (Card.getCardCount() > 0) then
      for i = Card.getCardCount(), 1, -1 do
        local card = Card.getCard(i)
        if (Collision.isPointRectangleColliding(mousePosition, card:getBoundingBox())) then
          local worldX, worldY = Constants.screenToWorld(_x, _y)

          card.isSelected = true
          card.dragOffsetX = worldX - card.x
          card.dragOffsetY = worldY - card.y

          card.startX = card.x
          card.startY = card.y

          -- TODO Check for a card "pile" to move everything in once.
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
  local mousePosition = {
    x = _x,
    y = _y
  }

  if (_button == 1) then
    if (Card.getCardCount() > 0) then
      for i = Card.getCardCount(), 1, -1 do
        local card = Card.getCard(i)
        local isStacked = false

        if (card.isSelected) then
          card.isSelected = false

          -- TODO Check if card can be placed "here".
          -- TODO "Stack" cards together in those situations.

          for i = Card.getCardCount(), 1, -1 do
            local cardClicked = Card.getCard(i)
            if (card ~= cardClicked and Collision.isRectangleRectangleColliding(card:getBoundingBox(), cardClicked:getBoundingBox())) then
              card:stackOn(cardClicked)
              isStacked = true
              break
            end
          end

          if (not isStacked) then
            card.x = card.startX
            card.y = card.startY
          end

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