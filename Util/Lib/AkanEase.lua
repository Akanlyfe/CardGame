local AkanMath = require("Util/Lib/AkanMath")

local class = {}

function class.linear(_t)
  _t = AkanMath.clamp(0, 1, _t)
  return _t
end

function class.easeInQuad(_t)
  _t = AkanMath.clamp(0, 1, _t)
  return _t * _t
end

function class.easeOutQuad(_t)
  _t = AkanMath.clamp(0, 1, _t)
  return _t * (2 - _t)
end

function class.easeInOutQuad(_t)
  _t = AkanMath.clamp(0, 1, _t)
  if (_t < 0.5) then
    return 2 * _t * _t
  else
    return -1 + (4 - 2 * _t) * _t
  end
end

function class.easeInCubic(_t)
  return _t * _t * _t
end

function class.easeOutCubic(_t)
    _t = _t - 1
    return _t * _t * _t + 1
end

function class.easeInOutCubic(_t)
  if (_t < 0.5) then
    return 4 * _t * _t * _t
  else
    _t = 2 * _t - 2
    return 0.5 * _t * _t * _t + 1
  end
end

return class