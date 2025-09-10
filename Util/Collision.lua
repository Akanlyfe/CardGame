local class = {}

function class.isPointRectangleColliding(_point, _rectangle)
  return (_rectangle.x <= _point.x)
  and (_point.x <= _rectangle.x + _rectangle.width)
  and (_rectangle.y <= _point.y)
  and (_point.y <= _rectangle.y + _rectangle.height)
end

function class.isRectangleRectangleColliding(_rectangle1, _rectangle2)
  return (_rectangle1.x + _rectangle1.width >= _rectangle2.x)
  and (_rectangle1.x <= _rectangle2.x + _rectangle2.width)
  and (_rectangle1.y + _rectangle1.height >= _rectangle2.y)
  and (_rectangle1.y <= _rectangle2.y + _rectangle2.height)
end

function class.isPointCircleColliding(_point, _circle)
  local distance = math.pow(_point.x - _circle.x, 2) + math.pow(_point.y - _circle.y, 2)
  return distance <= math.pow(_circle.radius, 2)
end

function class.isCircleCircleColliding(_circle1, _circle2)
  local distance = math.pow(_circle1.x - _circle2.x, 2) + math.pow(_circle1.y - _circle2.y, 2)
  return distance <= math.pow(_circle1.radius + _circle2.radius, 2)
end

return class