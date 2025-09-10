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

return class