local GameState = require("GameState/GameState")
local SaveSystem = require("Util/SaveSystem")
local Constants = require("Util/Constants")

local DrawAPI = require("Util/DrawAPI")
local Timer = require("Util/Timer")
local Card = require("Cards/Card")

local modules = {}
local currentGameState = ""

-- TODO LIST
-- * Some troubles with the replacment of setPosition by moveTo (cards not good priority, stacking when moving)
-- * If card is moving, then pickUp previous (or root) card then priority isn't updated right.
-- * Investigate drop crash (reproduce bug (not always): drop card stack on uncovered card that is it's previous)

function love.load()
  math.randomseed(os.time())
  love.graphics.setDefaultFilter('nearest', 'nearest', 0)

  modules.menu = require("GameState/Menu")
  modules.solitaire = require("GameState/Solitaire")
  modules.gameOver = require("GameState/GameOver")

  GameState.request("menu")

  SaveSystem.load()
end

function love.update(_dt)
  local requestedGameState = GameState.getRequested()

  if (requestedGameState ~= "") then
    if (currentGameState ~= "") then
      modules[currentGameState].unload()
    end

    if (not modules[requestedGameState]) then
      print("[ERROR] requestedGameState does not exist (" .. requestedGameState .. ").")
      GameState.request("menu")
    end

    GameState.acceptRequested()
    currentGameState = GameState.getCurrent()

    modules[currentGameState].load()
  end

  if (currentGameState ~= "") then
    modules[currentGameState].update(_dt)
  end

  Timer.update(_dt)
  Card.update(_dt)
end

function love.draw()
  if (currentGameState ~= "") then
    love.graphics.push()

    love.graphics.translate(Constants.screen.offset.x, Constants.screen.offset.y)
    love.graphics.scale(Constants.scale, Constants.scale)

    modules[currentGameState].draw()
    Card.draw()

    DrawAPI.drawObjects()

    love.graphics.pop()
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