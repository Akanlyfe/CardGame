local class = {}

-- SCREEN RELATED CONSTANTS
class.screen = {}
class.screen.game = {}
class.screen.scale = {}

class.screen.game.width = 1920
class.screen.game.height = 1080

class.screen.width = love.graphics.getWidth()
class.screen.height = love.graphics.getHeight()

class.screen.scale.x = class.screen.width / class.screen.game.width
class.screen.scale.y = class.screen.height / class.screen.game.height

return class