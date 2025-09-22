local Animation = require("Util/Animation")

local AkanAPI = require("Util/Lib/AkanAPI")

local class = {}
local objectList = {}
local UID = 0

local function createNewObject(_priority, _color, _x, _y, _rotation, _scaleX, _scaleY, _offSetX, _offSetY)
  local object = {
    UID = UID,
    priority = _priority,
    color = _color,
    x = _x,
    y = _y,
    rotation = _rotation,
    scaleX = _scaleX,
    scaleY = _scaleY,
    offSetX = _offSetX,
    offSetY = _offSetY
  }

  UID = UID + 1

  return object
end

function class.newImageFromSheet(_sprite, _x, _y, _width, _height)
  return love.graphics.newQuad(_x, _y, _width, _height, _sprite:getDimensions())
end

function class.color(_r, _g, _b, _a)
  return {r = _r, g = _g, b = _b, a = _a}
end

function class.drawObjects()
  table.sort(objectList, AkanAPI.prioritySorting)

  for objectID = 1, #objectList do
    local object = objectList[objectID]
    local color = object.color

    love.graphics.setColor(color.r, color.g, color.b, color.a)

    if (object.isText) then
      love.graphics.printf(object.text, object.font, object.x, object.y, object.width, object.align, object.rotation, object.scaleX, object.scaleY, object.offSetX, object.offSetY)

    elseif (object.isRectangle) then
      love.graphics.rectangle(object.mode, object.x, object.y, object.width, object.height)

    elseif (object.isCircle) then
      love.graphics.circle(object.mode, object.x, object.y, object.radius)

    elseif (object.isStatic) then
      love.graphics.draw(object.sprite, object.x, object.y, object.rotation, object.scaleX, object.scaleY, object.offSetX, object.offSetY)

    elseif (object.isAnimation) then
      Animation.draw(object.animation, object.x, object.y, object.rotation, object.scaleX, object.scaleY, object.offSetX, object.offSetY)
    end
  end

  objectList = {}
end

function class.text(_priority, _color, _text, _font, _x, _y, _width, _align, _rotation, _scaleX, _scaleY, _offSetX, _offSetY)
  local object = createNewObject(_priority, _color, _x, _y, _rotation, _scaleX, _scaleY, _offSetX, _offSetY)

  object.text = _text
  object.font = _font
  object.width = _width
  object.align = _align

  object.isText = true

  table.insert(objectList, object)
end

function class.rectangle(_priority, _color, _mode, _x, _y, _width, _height)
  local object = createNewObject(_priority, _color, _x, _y)
  object.mode = _mode
  object.width = _width
  object.height = _height

  object.isRectangle = true

  table.insert(objectList, object)
end

function class.circle(_priority, _color, _mode, _x, _y, _radius)
  local object = createNewObject(_priority, _color, _x, _y)
  object.mode = _mode
  object.radius = _radius

  object.isCircle = true

  table.insert(objectList, object)
end

function class.draw(_priority, _color, _drawable, _x, _y, _rotation, _scaleX, _scaleY, _offSetX, _offSetY)
  local object = createNewObject(_priority, _color, _x, _y, _rotation, _scaleX, _scaleY, _offSetX, _offSetY)
  object.sprite = _drawable

  object.isStatic = true

  table.insert(objectList, object)
end

function class.drawAnimation(_priority, _color, _animation, _x, _y, _rotation, _scaleX, _scaleY, _offSetX, _offSetY)
  local object = createNewObject(_priority, _color, _x, _y, _rotation, _scaleX, _scaleY, _offSetX, _offSetY)
  object.animation = _animation

  object.isAnimation = true

  table.insert(objectList, object)
end

return class