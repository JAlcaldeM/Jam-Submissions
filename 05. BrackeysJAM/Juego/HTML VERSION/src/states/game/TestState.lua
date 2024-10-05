TestState = Class{__includes = BaseState}

function TestState:init(def)
  self.type = 'Test'
  
  self.points = {}
  self.lengths = {}
  
  local totalLength = 800
  
  self.angLimit = 1.5*math.pi -- rotation speed
  self.angLimit2 = 0.7*math.pi -- for rotation limit between segments, MUST BE AT LEAST
  
  self.nPoints = 60
  self.distance = totalLength / self.nPoints --50
  
  --local radiusList = {17,27,29,11,15,28,50,65,71,68,60,40,58,52}
  local radiusList = {}
  for i = 1, self.nPoints do
    table.insert(radiusList, 100)
  end
  
  
  self.angLimitValues = {}
  for i = 1, self.nPoints do
    --local angLimit = math.min(math.pi, math.max(0.7*math.pi, math.pi*radiusList[i]/(2*self.distance)))
    local angLimit = 0.7*math.pi
    
    table.insert(self.angLimitValues,angLimit)
  end
  
  
  for i = 1, self.nPoints do
    local point = {x = 100 + self.distance*i, y = 200, r = radiusList[i], ang = 0}
    table.insert(self.points, point)
  end
  self.lastPoint = self.points[self.nPoints]
  
  self.lineWidth = 5
  
  self.pointSize = 10
  
  self.speedMax = 500
  self.speedMin = 150
  self.speed = self.speedMax
  self.speedStatus = 'max'
  self.accel = 800
  
  self.printRedPoints = false
  self.redPoint = {x = 0, y = 0}
  
  self.printPoints = false
  
  self.bones = false
  self.boneWidth = 20
  
  self.skin = true
  self.skinPoints = {}
  self.skinWidth = 10
  self.skinLineColor = colors.blue
  
  self.skinFill = false
  self.skinPointsPure = {}
  self.skinColor = colors.green
  
  
  
  
  
end



function TestState:update(dt)
  
  local x, y = push:toGame(love.mouse.getPosition())
  
  if love.mouse.isDown(1) then
    local deltaX = x - self.lastPoint.x
    local deltaY = y - self.lastPoint.y
    local angle = (math.atan2(deltaY, deltaX))
    local deltaAngle = angle - self.lastPoint.ang
    
    --[[
    local deltaAngleSign = sign(deltaAngle)
    deltaAngle = math.min(math.abs(deltaAngle), self.angLimit*dt)
    --print(angle, self.lastPoint.ang, deltaAngle)
    angle = self.lastPoint.ang + deltaAngle*deltaAngleSign
    
    
    --angle = math.min(angle + self.angLimit*dt,math.max(angle, angle - self.angLimit*dt))
    
    ]]
    
    deltaAngle = (deltaAngle + math.pi) % (2 * math.pi) - math.pi
    local deltaAngleSign = sign(deltaAngle)
    if math.abs(deltaAngle) > self.angLimit*dt then
      local deccelRate = math.abs(deltaAngle)/(self.angLimit*dt)
      deltaAngle = math.min(math.abs(deltaAngle), self.angLimit * dt) * deltaAngleSign
      self.speedStatus = '- speed'
      self.speed = self.speed - self.accel*dt
      if self.speed <= self.speedMin then
        self.speed = self.speedMin
      end
    else
      self.speedStatus = '+ speed'
      self.speed = self.speed + self.accel*dt
      if self.speed >= self.speedMax then
        self.speedStatus = 'max'
        self.speed = self.speed
      end
    end
    
    
    angle = self.lastPoint.ang + deltaAngle
    angle = (angle + math.pi) % (2 * math.pi) - math.pi

    
    
    local distance = math.sqrt((deltaX)^2 + (deltaY)^2)
    local movement = self.speed*dt
    if movement > distance then
      movement = distance - 0.01
    end
    
    local movX = movement * math.cos(angle)
    local movY = movement * math.sin(angle)
    
    self.redPoint.x = self.lastPoint.x + movX
    self.redPoint.y = self.lastPoint.y + movY
    
    self.lastPoint.x = self.lastPoint.x + movX
    self.lastPoint.y = self.lastPoint.y + movY
    
    self.lastPoint.ang = angle

end

  
  for i = self.nPoints, 2, -1 do
    local anchorPoint = self.points[i]
    local movedPoint = self.points[i-1]
    local distance = self.distance
    self:constrainPoint(anchorPoint, movedPoint, distance, self.angLimitValues[i])
  end

  
  
  
  self.skinPointsLeft = {}
  self.skinPointsRight = {}
  for i, point in ipairs(self.points) do
    --[[
    local leftPointX = point.x + point.r * math.sin(-point.ang)
    local leftPointY = point.y + point.r * math.cos(-point.ang)
    local rightPointX = point.x - point.r * math.sin(-point.ang)
    local rightPointY = point.y - point.r * math.cos(-point.ang)
    ]]
    
    local leftPoint = self:returnPointAngle(point, point.r, point.ang + math.pi/2)
    local rightPoint = self:returnPointAngle(point, point.r, point.ang - math.pi/2)
    if i == self.nPoints then
      local tempLeftPoint = leftPoint
      leftPoint = rightPoint
      rightPoint = tempLeftPoint
    end
    table.insert(self.skinPointsLeft, leftPoint)
    table.insert(self.skinPointsRight, rightPoint)
  end
  
  self.bluePoints = {}
  --[[
  table.insert(self.bluePoints, self:returnPointAngle(self.lastPoint, self.lastPoint.r, self.lastPoint.ang - math.pi/3))
  table.insert(self.bluePoints, self:returnPointAngle(self.lastPoint, self.lastPoint.r, self.lastPoint.ang - math.pi/6))
  table.insert(self.bluePoints, self:returnPointAngle(self.lastPoint, self.lastPoint.r, self.lastPoint.ang))
  table.insert(self.bluePoints, self:returnPointAngle(self.lastPoint, self.lastPoint.r, self.lastPoint.ang + math.pi/6))
  table.insert(self.bluePoints, self:returnPointAngle(self.lastPoint, self.lastPoint.r, self.lastPoint.ang + math.pi/3))
  ]]

  self.skinPoints = {}
  
  local firstPoint = self.points[1]
  table.insert(self.skinPoints, self:returnPointAngle(firstPoint, firstPoint.r, firstPoint.ang + math.pi))
  table.insert(self.skinPoints, self:returnPointAngle(firstPoint, firstPoint.r, firstPoint.ang + math.pi - math.pi/6))
  table.insert(self.skinPoints, self:returnPointAngle(firstPoint, firstPoint.r, firstPoint.ang + math.pi - math.pi/3))
  
  
  for i = 1, #self.skinPointsLeft - 1 do
    table.insert(self.skinPoints, self.skinPointsLeft[i])
  end
  
  table.insert(self.skinPoints, self.skinPointsRight[#self.skinPointsRight])
  
  table.insert(self.skinPoints, self:returnPointAngle(self.lastPoint, self.lastPoint.r, self.lastPoint.ang + math.pi/3))
  table.insert(self.skinPoints, self:returnPointAngle(self.lastPoint, self.lastPoint.r, self.lastPoint.ang + math.pi/6))
  table.insert(self.skinPoints, self:returnPointAngle(self.lastPoint, self.lastPoint.r, self.lastPoint.ang))
  table.insert(self.skinPoints, self:returnPointAngle(self.lastPoint, self.lastPoint.r, self.lastPoint.ang - math.pi/6))
  table.insert(self.skinPoints, self:returnPointAngle(self.lastPoint, self.lastPoint.r, self.lastPoint.ang - math.pi/3))
  
  table.insert(self.skinPoints, self.skinPointsLeft[#self.skinPointsLeft])
  
  for i = #self.skinPointsRight - 1, 1, -1 do
    table.insert(self.skinPoints, self.skinPointsRight[i])
  end

  table.insert(self.skinPoints, self:returnPointAngle(firstPoint, firstPoint.r, firstPoint.ang + math.pi + math.pi/3))
  table.insert(self.skinPoints, self:returnPointAngle(firstPoint, firstPoint.r, firstPoint.ang + math.pi + math.pi/6))
  
  
  
  self.skinPointsPure = {}
  for _, point in ipairs(self.skinPoints) do
    table.insert(self.skinPointsPure, point.x)
    table.insert(self.skinPointsPure, point.y)
  end
  
  

end

function TestState:returnPointAngle(point, distance, angle)
  
  local newX = point.x + distance * math.cos(angle)
  local newY = point.y + distance * math.sin(angle)
  
  return {x = newX, y = newY}
  
end




function TestState:render()
  
  -- points
  
  for i, point in ipairs(self.points) do
    
    
    if self.bones and i < self.nPoints then
      love.graphics.setColor(colors.white)
      local nextPoint = self.points[i+1]
      love.graphics.setLineWidth(self.boneWidth)
      love.graphics.line(point.x, point.y, nextPoint.x, nextPoint.y)
    end
    
    if self.printPoints then
      love.graphics.setColor(colors.white)
      --love.graphics.setLineWidth(self.lineWidth)
      love.graphics.circle('fill', point.x, point.y, point.r + self.lineWidth/2)
      love.graphics.setColor(colors.black)
      love.graphics.circle('fill', point.x, point.y, point.r - self.lineWidth/2)
    end
    
  end
  
  if self.skin then
    love.graphics.setLineWidth(self.skinWidth)
    --local curve = love.math.newBezierCurve(self.skinPointsPure)
    --love.graphics.line(curve:render())
    love.graphics.setColor(self.skinLineColor)
    local smoothPoints = generateSmoothCurve(self.skinPoints, 100)
    love.graphics.line(smoothPoints)
    
    if self.skinFill then
      love.graphics.setColor(self.skinColor)
      local triangles = love.math.triangulate(self.skinPointsPure)
      for i, triangle in ipairs(triangles) do
        love.graphics.setColor(math.random(), math.random(), math.random())
        love.graphics.polygon("fill", triangle)
      end
      --love.graphics.polygon('fill', self.skinPointsPure)
      --[[
      for i, point in ipairs(self.skinPoints) do
        local nextPoint = self.skinPoints[i+1]
        if nextPoint then
          love.graphics.line(point.x, point.y, nextPoint.x, nextPoint.y)
        end
      end
      ]]
    end
  end
  
  if self.printRedPoints then
    love.graphics.setColor(colors.red)
    love.graphics.circle('fill', self.redPoint.x, self.redPoint.y, 3)
    
    for _, point in pairs(self.skinPoints) do
      love.graphics.circle('fill', point.x, point.y, 6)
    end
  end
  
  
  love.graphics.setColor(colors.blue)
  for _, point in ipairs(self.bluePoints) do
    love.graphics.circle('fill', point.x, point.y, 6)
  end

  love.graphics.setColor(colors.red)
  love.graphics.print(self.speedStatus, 1000, 10)
  
end


function TestState:constrainPoint(anchorPoint, movedPoint, distance, angleLimit)
  
  local deltaX = movedPoint.x - anchorPoint.x
  local deltaY = movedPoint.y - anchorPoint.y
  local angle = (math.atan2(deltaY, deltaX))
  
  --[[
  local deltaAngle = angle - anchorPoint.ang
  -- make it so that angle can only be up to  anchorPoint.ang +- self.angLimit2
  --...
  
  local newPoint = self:returnPointAngle(anchorPoint, distance, angle)
  movedPoint.x = newPoint.x
  movedPoint.y = newPoint.y
  movedPoint.ang = angle
  ]]
  
  -- Calcular la diferencia de ángulo con respecto al anchorPoint
    local deltaAngle = angle - anchorPoint.ang
    --print('angle and anchorPoint.ang', angle, anchorPoint.ang)
    --print('da1', deltaAngle)
    deltaAngle = (deltaAngle + math.pi) % (2 * math.pi) - math.pi
   -- print('da2', deltaAngle)

    local angLimit = angleLimit or 0
    --deltaAngle = math.max(-angLimit, math.min(deltaAngle, angLimit))
    if math.abs(deltaAngle) < angLimit then
      -- Asegurar que deltaAngle sea al menos angLimit, manteniendo el signo
      deltaAngle = sign(deltaAngle) * angLimit
    end
    local limitedAngle = anchorPoint.ang + deltaAngle
    limitedAngle = (limitedAngle + math.pi) % (2 * math.pi) - math.pi
    local newPoint = self:returnPointAngle(anchorPoint, distance, limitedAngle)

    movedPoint.x = newPoint.x
    movedPoint.y = newPoint.y
    
    --print('limitedAngle', limitedAngle)
    movedPoint.ang = limitedAngle + math.pi

  
  
end


