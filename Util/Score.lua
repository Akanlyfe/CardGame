local class = {}
local score = {}

function class.set(_newScore)
  score.score = _newScore
end

function class.get()
  return score.score
end

function class.add(_amount)
  score.score = score.score + _amount * score.multiplier
end

function class.remove(_amount)
  score.score = math.max(score.score - _amount, 0)
end

function class.setMultiplier(_multiplier)
  score.multiplier = _multiplier
end

function class.resetMultiplier()
  score.multiplier = 1
end

function class.load()
  score.score = 0
  
  score.multiplier = 1
end

return class