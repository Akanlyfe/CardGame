local GameState = require("GameState/GameState")

local class = {}
local gameOver = {}

function class.load()
end

function class.unload()
  collectgarbage('collect')
end

function class.update(_dt)
end

function class.draw()
  love.graphics.setBackgroundColor(0, 0, 0, 1)
end

function class.keypressed(_key)
  if (_key == 'tab') then
    GameState.request("menu")
  end
end

return class