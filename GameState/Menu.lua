local GameState = require("GameState/GameState")

local class = {}
local menu = {}

-- TODO Do some buttons to play differents gamemodes
-- Maybe do a class Button in OOP?

function class.load()
end

function class.unload()
  menu = {}
  collectgarbage('collect')
end

function class.update(_dt)
end

function class.draw()
  love.graphics.setBackgroundColor(0, 0, 0, 1)

  love.graphics.push()
  love.graphics.scale(2, 2)
  love.graphics.print("MENU", 10, 10)
  love.graphics.pop()
end

function class.keypressed(_key)
  if (_key == 'tab') then
    GameState.request("solitaire")
  elseif (_key == 'escape') then
    love.event.quit(0)
  end
end

return class