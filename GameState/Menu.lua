local GameState = require("GameState/GameState")

local class = {}
local menu = {}

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
end

function class.keypressed(_key)
  if (_key == 'tab') then
    GameState.request("inGame")
  elseif (_key == 'escape') then
    love.event.quit(0)
  end
end

return class