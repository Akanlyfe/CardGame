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
  --TODO Deck.shuffle()

  inGame.deckPile = Card.create(Deck.getBack(), Deck.getBack(), 10, 10)
  inGame.drawnCards = {}
end

function class.unload()
  inGame = {}
  collectgarbage('collect')
end

function class.update(_dt)
  if (#inGame.drawnCards > 0) then
    table.sort(inGame.drawnCards, AkanMath.prioritySorting)
    for _, card in ipairs(inGame.drawnCards) do
      card:update(_dt)
    end
  end
end

function class.draw()
  love.graphics.setBackgroundColor(0, .5, 0, 1)

  -- DECK
  if (Deck.count() > 0) then
    love.graphics.draw(inGame.deckPile.sprite, 10, 10)
  end

  -- DRAWN CARDS
  if (#inGame.drawnCards > 0) then
    for _, card in ipairs(inGame.drawnCards) do
      card:draw()
    end
  end
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
        local cardName = Deck.drawCard()
        local x = inGame.deckPile.x + inGame.deckPile.width + 10
        local y = inGame.deckPile.y
        local spacing = inGame.deckPile.width / 4.5 * #inGame.drawnCards

        local card = Card.create(Deck.getBack(), cardName, x + spacing, y)
        table.insert(inGame.drawnCards, card)
      else
        Deck.init()
        Deck.shuffle()

        inGame.drawnCards = {}
      end
    end

    if (#inGame.drawnCards > 0) then
      for i = #inGame.drawnCards, 1, -1 do
        local card = inGame.drawnCards[i]
        if (Collision.isPointRectangleColliding(mousePosition, card:getBoundingBox())) then
          card:moveTo(love.math.random(Constants.screen.width), love.math.random(Constants.screen.height))
          break
        end
      end
    end
  elseif (_button == 2) then
    if (#inGame.drawnCards > 0) then
      for i = #inGame.drawnCards, 1, -1 do
        local card = inGame.drawnCards[i]
        if (Collision.isPointRectangleColliding(mousePosition, card:getBoundingBox())) then
          card:flip()
          break
        end
      end
    end
  end
end

return class