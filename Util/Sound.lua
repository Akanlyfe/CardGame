local class = {}

function class.create(_name, _extension, _type, _volume, _isLooping)
  local audio = love.audio.newSource("Assets/Sounds/" .. _name .. "." .. _extension, _type)
  audio:setVolume(_volume)
  audio:setVolumeLimits(0, _volume)
  audio:setLooping(_isLooping)

  return audio
end

function class.createMusic(_name, _extension, _type, _volume)
  local audio = love.audio.newSource("Assets/Musics/" .. _name .. "." .. _extension, _type)
  audio:setVolume(_volume)
  audio:setVolumeLimits(0, _volume)
  audio:setLooping(true)

  return audio
end

return class