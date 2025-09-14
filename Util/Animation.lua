local class = {}

function class.newLeftToRight(_sprite, _frames, _framerate, _x, _y, _width, _height)
  local newAnimation = {}

  newAnimation.width = _width
  newAnimation.height = _height

  newAnimation.sprite = _sprite
  newAnimation.frames = _frames
  newAnimation.framerate = _framerate
  newAnimation.currentFrame = 1
  newAnimation.timer = 0

  newAnimation.playing = true

  newAnimation.quadList = {}
  for frame = 0, _frames do
    local quad = love.graphics.newQuad(_x + frame * _width, _y, _width, _height, _sprite:getDimensions())
    table.insert(newAnimation.quadList, quad)
  end

  return newAnimation
end

function class.newLeftToRightPlayable(_sprite, _frames, _framerate, _x, _y, _width, _height)
  local newAnimation = {}

  newAnimation.width = _width
  newAnimation.height = _height

  newAnimation.sprite = _sprite
  newAnimation.frames = _frames
  newAnimation.framerate = _framerate
  newAnimation.currentFrame = 1
  newAnimation.timer = 0

  newAnimation.isPlayable = true
  newAnimation.playing = false

  newAnimation.quadList = {}
  for frame = 0, _frames do
    local quad = love.graphics.newQuad(_x + frame * _width, _y, _width, _height, _sprite:getDimensions())
    table.insert(newAnimation.quadList, quad)
  end

  function newAnimation:play()
    self.currentFrame = 1
    self.playing = true
  end

  function newAnimation:stop()
    self.playing = false
  end

  function newAnimation:isPlaying()
    return self.playing
  end

  return newAnimation
end

function class.newTopToDown(_sprite, _frames, _framerate, _x, _y, _width, _height)
  local newAnimation = {}

  newAnimation.width = _width
  newAnimation.height = _height

  newAnimation.sprite = _sprite
  newAnimation.frames = _frames
  newAnimation.framerate = _framerate
  newAnimation.currentFrame = 1
  newAnimation.timer = 0

  newAnimation.playing = true

  newAnimation.quadList = {}
  for frame = 0, _frames do
    local quad = love.graphics.newQuad(_x, _y + frame * _height, _width, _height, _sprite:getDimensions())
    table.insert(newAnimation.quadList, quad)
  end

  return newAnimation
end

function class.newTopToDownPlayable(_sprite, _frames, _framerate, _x, _y, _width, _height)
  local newAnimation = {}

  newAnimation.width = _width
  newAnimation.height = _height

  newAnimation.sprite = _sprite
  newAnimation.frames = _frames
  newAnimation.framerate = _framerate
  newAnimation.currentFrame = 1
  newAnimation.timer = 0

  newAnimation.isPlayable = true
  newAnimation.playing = false

  newAnimation.quadList = {}
  for frame = 0, _frames do
    local quad = love.graphics.newQuad(_x, _y + frame * _height, _width, _height, _sprite:getDimensions())
    table.insert(newAnimation.quadList, quad)
  end

  function newAnimation:play()
    self.currentFrame = 1
    self.playing = true
  end

  function newAnimation:stop()
    self.playing = false
  end

  function newAnimation:isPlaying()
    return self.playing
  end

  function newAnimation:setCurrentFrame(_currentFrame)
    self.currentFrame = math.min(_currentFrame, _frames)
  end

  return newAnimation
end

function class.newSelected(_sprite, _selected, _x, _y, _width, _height)
  local newAnimation = {}

  newAnimation.sprite = _sprite
  newAnimation.selected = _selected
  newAnimation.currentFrame = 1

  newAnimation.playing = true

  newAnimation.quadList = {}
  newAnimation.quadList[1] = love.graphics.newQuad(_x, _y, _width, _height, _sprite:getDimensions())
  newAnimation.quadList[2] = love.graphics.newQuad(_x + _width, _y, _width, _height, _sprite:getDimensions())

  function newAnimation:update()
    if (self.selected) then
      self.currentFrame = 2
    else
      self.currentFrame = 1
    end
  end

  function newAnimation:setSelected(_selectedBoolean)
    self.selected = _selectedBoolean
  end

  function newAnimation:isSelected()
    return self.selected
  end

  return newAnimation
end

function class.update(_animation, _dt)
  if (_animation.playing) then

    _animation.timer = _animation.timer + _dt
    if (_animation.timer >= 1 / _animation.framerate) then
      _animation.timer = 0

      _animation.currentFrame = _animation.currentFrame + 1
      if (_animation.currentFrame > _animation.frames) then

        if (_animation.isPlayable) then
          _animation:stop()
          _animation.currentFrame = _animation.frames
        else
          _animation.currentFrame = 1
        end
      end
    end
  end
end

function class.draw(_animation, _x, _y, _rotation, _scaleX, _scaleY, _offSetX, _offSetY)
  love.graphics.draw(_animation.sprite, _animation.quadList[_animation.currentFrame], _x, _y, _rotation, _scaleX, _scaleY, _offSetX, _offSetY)
end

return class