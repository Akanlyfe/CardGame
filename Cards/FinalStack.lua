local DrawAPI = require("Util/DrawAPI")
local Constants = require("Util/Constants")

local class = {}

-- TODO function init to init all datas (x, y, width, height) then in the draw func DrawAPI.rectangle with all datas (use for loop?)

function class.draw()
  DrawAPI.rectangle(Constants.priority.low, )
end

return class