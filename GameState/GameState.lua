local class = {}

local currentState = ""
local requestedState = ""

function class.getCurrent()
    return currentState
end

function class.request(_requestedState)
    requestedState = _requestedState
end

function class.getRequested()
    return requestedState
end

function class.acceptRequested()
    currentState = requestedState
    requestedState = ""
end

return class