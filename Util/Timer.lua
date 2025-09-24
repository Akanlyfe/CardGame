local class = {}
local timers = {}

function class.create(_name, _duration, _isRepeating, _callback)
  local timer = {
    name = _name,
    time = 0,
    isPlaying = false,
    duration = _duration,
    callback = _callback,

    isRepeating = _isRepeating,

    isRemoved = false
  }

  function timer:getTime()
    return self.time
  end

  function timer:getDuration()
    return self.duration
  end

  function timer:getHalfDuration()
    return self.duration / 2
  end

  function timer:isStarted()
    return self.isPlaying
  end

  function timer:play()
    self.isPlaying = true
  end

  function timer:pause()
    self.isPlaying = false
  end

  function timer:remove()
    self.isRemoved = true
  end

  function timer:reset()
    self.time = 0
  end

  function timer:update(_dt)
    if (self.isPlaying) then
      self.time = self.time + _dt

      if (self.time >= self.duration) then
        if (not self.isRepeating) then
          self.isPlaying = false
          self.time = 0
        else
          self.time = self.time - self.duration
        end

        if (self.callback) then
          self.callback()
        end
      end
    end
  end

  table.insert(timers, timer)

  return timer
end

function class.update(_dt)
  for i = #timers, 1, -1 do
    local timer = timers[i]

    if (timer.isRemoved) then
      table.remove(timers, i)
    else
      timer:update(_dt)
    end
  end
end

return class