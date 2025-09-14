local class = {}

function class.length(_vector)
  return math.sqrt(_vector.x * _vector.x + _vector.y * _vector.y)
end

function class.normalize(_vector)
  local length = class.length(_vector)
  local normalizedVector = { x = 0, y = 0 }

  if (length ~= 0) then
    normalizedVector.x = _vector.x / length
    normalizedVector.y = _vector.y / length
  end

  return normalizedVector
end

function class.clamp(_min, _max, _value)
  return math.max(_min, math.min(_max, _value))
end

function class.lerp(_min, _max, _time)
  return _min + (_max - _min) * _time
end

function class.prioritySorting(_a, _b)
  if (_a.priority == _b.priority) then
    if (_a.y == _b.y) then
      return _a.x < _b.x
    else
      return _a.y < _b.y
    end
  else
    return _a.priority < _b.priority
  end
end

return class