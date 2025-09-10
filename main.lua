local GameState = require("GameState/GameState")
local SaveSystem = require("Util/SaveSystem")
local Constants = require("Util/Constants")

local modules = {}
local currentGameState = ""

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest', 0)

  modules.menu = require("GameState/Menu")
  modules.inGame = require("GameState/InGame")
  modules.gameOver = require("GameState/GameOver")

  GameState.request("menu")

  Constants.screen.compute()

  SaveSystem.load()
end

function love.update(_dt)
  local requestedGameState = GameState.getRequested()

  if (requestedGameState ~= "") then
    if (currentGameState ~= "") then
      modules[currentGameState].unload()
    end

    GameState.acceptRequested()
    currentGameState = GameState.getCurrent()

    modules[currentGameState].load()
  end

  if (currentGameState ~= "") then
    modules[currentGameState].update(_dt)
  end
end

function love.draw()
  if (currentGameState ~= "") then
    modules[currentGameState].draw()
  end
end

function love.keypressed(_key)
  if (currentGameState ~= "") then
    if (modules[currentGameState].keypressed) then
      modules[currentGameState].keypressed(_key)
    end
  end
end

function love.keyreleased(_key)
  if (currentGameState ~= "") then
    if (modules[currentGameState].keyreleased) then
      modules[currentGameState].keyreleased(_key)
    end
  end
end

function love.mousepressed(_x, _y, _button)
  if (currentGameState ~= "") then
    if (modules[currentGameState].mousepressed) then
      modules[currentGameState].mousepressed(_x, _y, _button)
    end
  end
end

function love.mousereleased(_x, _y, _button)
  if (currentGameState ~= "") then
    if (modules[currentGameState].mousereleased) then
      modules[currentGameState].mousereleased(_x, _y, _button)
    end
  end
end

function love.mousemoved(_x, _y, _moveX, _moveY)
  if (currentGameState ~= "") then
    if (modules[currentGameState].mousemoved) then
      modules[currentGameState].mousemoved(_x, _y, _moveX, _moveY)
    end
  end
end

function love.wheelmoved(_x, _y)
  if (currentGameState ~= "") then
    if (modules[currentGameState].wheelmoved) then
      modules[currentGameState].wheelmoved(_x, _y)
    end
  end
end

function love.quit()
  SaveSystem.save()
end