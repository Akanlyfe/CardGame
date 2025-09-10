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
  local deckPile = love.graphics.newImage("Assets/Sprites/Cards/cardBack_red3.png")
  love.graphics.draw(deckPile, 10, 10)
end

function class.keypressed(_key)
  if (_key == 'tab') then
    GameState.request("gameOver")
  elseif (_key == 'a') then
    local card = Deck.draw()
    print(card)
  end
end

return class