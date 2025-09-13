local class = {}
local timers = {}

function class.create(_duration, _callback)
  local timer = {
    time = 0,
    isPlaying = false,
    isFinished = false,
    duration = _duration,
    callback = _callback,

    isRemoved = false
  }

  function timer:getTime()
    return timer.time
  end

  function timer:getDuration()
    return timer.duration
  end

  function timer:getHalfDuration()
    return timer.duration / 2
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

  function timer:isStarted()
    return self.isPlaying
  end

  function timer:reset()
    self.time = 0
    self.isFinished = false
  end

  function timer:update(_dt)
    if (self.isPlaying) then
      if (self.time < self.duration) then
        self.time = self.time + _dt
      else
        if (self.callback and not self.isFinished) then
          self.isFinished = true
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