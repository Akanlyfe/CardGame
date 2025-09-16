local AkanEase = require("Util/Lib/AkanEase")
local AkanMath = require("Util/Lib/AkanMath")

local class = {}

class.ease = AkanEase
class.math = AkanMath

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

function class.switchFunction(_value, _cases)
  local func = _cases[_value] or _cases.default
  if (func) then
    return func()
  end
end

function class.switchString(_value, _cases)
  local string = _cases[_value] or _cases.default
  if (string) then
    return string
  end
end

return class