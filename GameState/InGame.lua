local GameState = require("GameState/GameState")
local Deck = require("Cards/Deck")

local class = {}
local inGame = {}

function class.load()
  Deck.init()
  Deck.shuffle()
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
    local deckPile = love.graphics.newImage("Assets/Sprites/Cards/cardBack_red3.png")
    love.graphics.draw(deckPile, 10, 10)
  end
end

function class.keypressed(_key)
  if (_key == 'tab') then
    GameState.request("gameOver")
  end
end

function class.mousepressed(_x, _y, _button)
  if (Deck.count() > 0) then
    if (_button == 1) then
      if (_x >= 10 and _y >= 10
        and _x <= 100 and _y <= 100) then
        local card = Deck.drawCard()
        print(card)
      end
    end
  end
end

return class