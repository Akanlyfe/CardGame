local Constants = require("Util/Constants")
local Collision = require("Util/Collision")

local GameState = require("GameState/GameState")
local Deck = require("Cards/Deck")
local Card = require("Cards/Card")

local class = {}
local inGame = {}

function class.load()
  Deck.init()
  --TODO Deck.shuffle()

  inGame.deckPile = Card.create("Back_red3", 10, 10)
  inGame.drawnCards = {}
end

function class.unload()
  inGame = {}
  collectgarbage('collect')
end

function class.update(_dt)
end

function class.draw()
  love.graphics.setBackgroundColor(0, .5, 0, 1)

  -- DECK
  if (Deck.count() > 0) then
    love.graphics.draw(inGame.deckPile.sprite, 10, 10)
  end

  -- DRAWN CARD
  if (#inGame.drawnCards > 0) then
    for i, card in ipairs(inGame.drawnCards) do
      love.graphics.draw(card.sprite, card.x, card.y)
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
    if (Collision.isPointRectangleColliding(mousePosition, inGame.deckPile)) then
      if (Deck.count() > 0) then
        local cardName = Deck.drawCard()
        local card = Card.create(cardName, 160 + (60 * Constants.scale) * #inGame.drawnCards, 10)

        table.insert(inGame.drawnCards, card)
      else
        Deck.init()
        Deck.shuffle()

        inGame.drawnCards = {}
      end
    end
  end
end

return class