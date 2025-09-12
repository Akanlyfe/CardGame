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

return class