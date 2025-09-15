local class = {}

-- SCREEN RELATED CONSTANTS
class.screen = {}
class.screen.offset = {}

class.game = {}

class.game.width = 1920
class.game.height = 1080

class.screen.width = love.graphics.getWidth()
class.screen.height = love.graphics.getHeight()

local scaleX = class.screen.width / class.game.width
local scaleY = class.screen.height / class.game.height
class.scale = math.min(scaleX, scaleY)

class.screen.offset.x = (class.screen.width - class.game.width * class.scale) / 2
class.screen.offset.y = (class.screen.height - class.game.height * class.scale) / 2

function class.screenToWorld(_x, _y)
  local worldX = (_x - class.screen.offset.x) / class.scale
  local worldY = (_y - class.screen.offset.y) / class.scale

  return worldX, worldY
end

-- PRIORITY RELATED CONSTANTS
class.priority = {}
class.priority.onTopOfAll = 10000
class.priority.veryHigh = 5000
class.priority.high = 2000
class.priority.normal = 0
class.priority.low = -2000
class.priority.veryLow = -5000
class.priority.underAll = -10000

-- COLOR RELATED CONSTANTS
class.color = {}
class.color.white = {r = 1, g = 1, b = 1, a = 1}
class.color.black = {r = 0, g = 0, b = 0, a = 1}
class.color.red = {r = 1, g = 0, b = 0, a = 1}
class.color.green = {r = 0, g = 1, b = 0, a = 1}
class.color.blue = {r = 0, g = 0, b = 1, a = 1}
class.color.lightBlue = {r = .25, g = .8, b = 1, a = 1}
class.color.darkBlue = {r = .2, g = 0, b = 1, a = 1}

return class