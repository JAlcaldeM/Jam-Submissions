TestState2 = Class{__includes = BaseState}

function TestState2:init(def)
  self.type = 'Test2'
  
  self.points = {}
  self.lengths = {}
  
  
  
  self.angLimit = 1.5*math.pi --1.5*math.pi -- rotation speed
  self.angLimit2 = 0.7*math.pi -- for rotation limit between segments, MUST BE AT LEAST
  
  
  local totalLength = 400
  self.nPoints = 10
  self.distance = totalLength / self.nPoints --50
  
  --[[
  local radiusList = {}
  for i = 1, self.nPoints do
    table.insert(radiusList, 100)
  end
  local radiusList = {68, 81, 84, 83, 77, 64, 51, 38, 32, 19}
  ]]
  local radiusList = {19,28,38,51,64,77,83,84,78,68}
  
  self.angLimitValues = {}
  for i = 1, self.nPoints do
    --local angLimit = math.min(math.pi, math.max(0.7*math.pi, math.pi*radiusList[i]/(2*self.distance)))
    local angLimit = 0.96*math.pi
    
    table.insert(self.angLimitValues,angLimit)
  end
  
  
  for i = 1, self.nPoints do
    local point = {x = VIRTUAL_WIDTH/2 + self.distance*(i - self.nPoints), y = VIRTUAL_HEIGHT/2, r = radiusList[i], ang = 0}
    table.insert(self.points, point)
  end
  self.lastPoint = self.points[self.nPoints]
  
  self.lineWidth = 5
  
  self.pointSize = 10
  
  self.speedMax = 1000
  self.speedMin = 0.2*self.speedMax
  self.speed = self.speedMax
  self.speedStatus = 'max'
  self.accel = 0.5*self.speedMax
  self.deccel = 1.5*self.speedMax
  
  self.printRedPoints = false
  self.printBluePoints = true
  self.redPoint = {x = 0, y = 0}
  
  self.printPoints = false
  
  self.bones = false
  self.boneWidth = 20
  
  self.skin = true
  self.skinPoints = {}
  self.skinWidth = 10
  self.skinLineColor = colors.black
  
  self.skinFill = true
  self.skinPointsPure = {}
  self.skinColor = colors.orange--{1,0,0,0.5} 
  
  
  self.camera = {
    active = true,
    x = 0,---VIRTUAL_WIDTH/2,
    y = 0,---VIRTUAL_HEIGHT/2,
    xTarget = 0,---VIRTUAL_WIDTH/2,
    yTarget = 0,---VIRTUAL_HEIGHT/2,
    speedMin = 0,
    speedMax = 300,
    speedMult = 5,
    distanceMax = 500,
    }
  
  
  self.areaSize = 5000
  
  self.nPellets = nPellets
  self.pellets = {}
  for i = 1, self.nPellets do
    table.insert(self.pellets, {x = math.random(self.areaSize) - self.areaSize/2, y = math.random(self.areaSize) - self.areaSize/2})
  end
  
  self.autoMode = false
  
  
  self.swingAngleMax = math.pi/10
  self.swingAngle = 0
  self.swingSpeedMult = 10
  self.swingTime = 0
  
  self.returnTrue = false
  
  self.eyes = true
  self.eyeList = {}
  self.eyeDist = 0.8 * self.lastPoint.r
  self.eyeAngle = math.pi/3
  self.eyeSize = 20
  self.pupils = {}
  self.pupilSize = 5
  self.pupilDist = 5
  
  self.mouth = true
  self.mouthWidth = 50
  self.mouthTime = 0
  self.mouthDist = 0.5 * self.lastPoint.r
  self.mouthSizeX = 150
  self.mouthSizeY = 300
  self.mouthScale = 0.1
  self.mouthColor = colors.darkred
  self.mouthCanvas = love.graphics.newCanvas(2*self.mouthSizeX, 2*self.mouthSizeY, {msaa = 40})
  self.mouthCanvas:setFilter("linear", "linear")
  
  love.graphics.setCanvas(self.mouthCanvas)
  love.graphics.push()
  love.graphics.translate(self.mouthSizeX, self.mouthSizeY)
  --love.graphics.setColor(colors.magenta)
  --love.graphics.rectangle('fill', -self.mouthSizeX, -self.mouthSizeY, 2*self.mouthSizeX, 2*self.mouthSizeY)
  love.graphics.setColor(colors.black)
  love.graphics.ellipse('fill', 0, 0, self.mouthSizeX, self.mouthSizeY)
  love.graphics.setLineWidth(self.mouthWidth)
  love.graphics.setColor(self.mouthColor)
  love.graphics.ellipse('fill', 0, 0, self.mouthSizeX - self.mouthWidth, self.mouthSizeY - self.mouthWidth)
  love.graphics.pop()
  love.graphics.setCanvas()
  
  
  -- SHADER FOR BLUR, NOT USED!!
  self.blurShader = love.graphics.newShader([[
        extern vec2 direction;  // Dirección del desenfoque (horizontal o vertical)
        extern float radius;    // Radio del desenfoque

        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
            vec4 sum = vec4(0.0);
            vec2 tex_offset = direction / love_ScreenSize.xy; // Tamaño del paso (offset) en la textura

            // Aplicar el desenfoque (cálculo de varios píxeles alrededor)
            for (float i = -radius; i <= radius; i++) {
                sum += Texel(texture, texture_coords + tex_offset * i);
            }

            // Dividir por el número total de píxeles amostrados
            sum /= (2.0 * radius + 1.0);
            return sum * color;
        }
    ]])
    self.canvas = love.graphics.newCanvas()
  blurRadius = 1
  
  
  self.parallaxFactor = 2
  self.background = gTextures['ocean3blur']
  self.backgroundWidth = self.background:getWidth()
  self.backgroundHeight = self.background:getHeight()
  self.backgroundScale = self.areaSize / self.backgroundWidth
  
  
  self.eatDistance = 30
  self.pelletSize = 20
  self.detectDistance = 500
  
  self.score = 0
  
  
end





function TestState2:update(dt)
  
  if love.keyboard.isDown("up") then
        blurRadius = blurRadius + 1 * dt
    elseif love.keyboard.isDown("down") then
        blurRadius = blurRadius - 1 * dt
    end
  
  if self.returnTrue then
    return
  end
  
  
  local x, y = push:toGame(love.mouse.getPosition())
  
  if self.camera.active then
    x = x + self.camera.x
    y = y + self.camera.y
  end
  
  
  --[[
  local swingDirection = 0
  if self.swingAngle >= self.swingAngleMax then
    swingDirection = -1
  end
  ]]
  --self.swingAngle = self.swingAngle + swingDirection * self.swingSpeedMult * dt * (self.swingAngle/self.swingAngleMax) * (self.speed/self.speedMax)
  
  self.swingTime = self.swingTime + dt
  self.swingAngle = self.swingAngleMax * math.sin(self.swingTime * self.swingSpeedMult * math.max(1,self.speed/self.speedMax))
  
  --[[
  self.mouthTime = self.mouthTime + dt
  self.mouthScale = 0.1 + 0.05 * math.sin(self.mouthTime)
  ]]
  
  if self.autoMode or love.mouse.isDown(1) then
    local deltaX = x - self.lastPoint.x
    local deltaY = y - self.lastPoint.y
    local angle = (math.atan2(deltaY, deltaX))
    
    local cameraPoint = {x = self.lastPoint.x, y = self.lastPoint.y}
    cameraPoint = self:returnPointAngle(cameraPoint, self.camera.distanceMax, angle)
    self.bluePoints = {}
    table.insert(self.bluePoints, cameraPoint)
    
    
    local boxX = -0.5*self.areaSize
    local boxY = -0.5*self.areaSize
    local boxWidth = self.areaSize
    local boxHeight = self.areaSize
    
    
    local cameraMargin = 20

    if cameraPoint.x < boxX - cameraMargin then
      cameraPoint.x = boxX - cameraMargin
    elseif cameraPoint.x > boxX + boxWidth + cameraMargin then
      cameraPoint.x = boxX + boxWidth + cameraMargin
    end
    
    if cameraPoint.y < boxY - cameraMargin then
      cameraPoint.y = boxY - cameraMargin
    elseif cameraPoint.y > boxY + boxHeight + cameraMargin then
      cameraPoint.y = boxY + boxHeight + cameraMargin
    end
    
    self.camera.xTarget = cameraPoint.x
    self.camera.yTarget = cameraPoint.y
    

    
    
    local deltaAngle = angle + self.swingAngle - self.lastPoint.ang
    
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
      self.speed = self.speed - self.deccel*dt
      if self.speed <= self.speedMin then
        self.speed = self.speedMin
      end
    else
      self.speedStatus = '+ speed'
      self.speed = self.speed + self.accel*dt
      if self.speed >= self.speedMax then
        self.speedStatus = 'max'
        self.speed = self.speedMax
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
    
    
    local limitedPoints = {self.lastPoint}
    for _, point in ipairs(limitedPoints) do
      --self:keepPointInsideBox(point, boxX, boxY, boxWidth, boxHeight)
      if point.x - point.r < boxX then
        point.x = boxX + point.r
      elseif point.x + point.r > boxX + boxWidth then
        point.x = boxX + boxWidth - point.r
      end
      
      if point.y - point.r < boxY then
        point.y = boxY + point.r
      elseif point.y + point.r > boxY + boxHeight then
        point.y = boxY + boxHeight - point.r
      end
      
    end
    
    
  

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
  

  
  local cameraDeltaX = self.camera.xTarget - self.camera.x - VIRTUAL_WIDTH/2
  local cameraDeltaY = self.camera.yTarget - self.camera.y - VIRTUAL_HEIGHT/2
  
  local cameraSpeedX = dt*sign(cameraDeltaX)*math.max(self.camera.speedMin, math.min(self.camera.speedMax, math.abs(cameraDeltaX)))*self.camera.speedMult
  local cameraSpeedY = dt*sign(cameraDeltaY)*math.max(self.camera.speedMin, math.min(self.camera.speedMax, math.abs(cameraDeltaY)))*self.camera.speedMult
  self.cameraSpeeds = {x = cameraSpeedX, y = cameraSpeedY}
  
  self.camera.x = self.camera.x + cameraSpeedX
  self.camera.y = self.camera.y + cameraSpeedY
  
  
  for i, point in ipairs(self.skinPointsPure) do
    if i % 2 == 0 then
      self.skinPointsPure[i] = point - self.camera.y
    else
      self.skinPointsPure[i] = point - self.camera.x
    end
  end
  self.triangles = love.math.triangulate(self.skinPointsPure)
  
  
  self.eyeList = {}
  --[[
  local eye1 = {x = self.lastPoint.x, y = self.lastPoint.y}
  local eye2 = {x = self.lastPoint.x, y = self.lastPoint.y}
  ]]
  local eye1 = self:returnPointAngle(self.lastPoint, self.eyeDist, self.lastPoint.ang + self.eyeAngle)
  local eye2 = self:returnPointAngle(self.lastPoint, self.eyeDist, self.lastPoint.ang - self.eyeAngle)
  table.insert(self.eyeList, eye1)
  table.insert(self.eyeList, eye2)
  
  self.pupils = {}
  local pupilTarget = {x = self.camera.xTarget, y = self.camera.yTarget}
  local pupil1 = self:returnPointAngle(eye1, self.pupilDist, math.atan2(pupilTarget.y-eye1.y , pupilTarget.x-eye1.x))
  local pupil2 = self:returnPointAngle(eye2, self.pupilDist, math.atan2(pupilTarget.y-eye2.y , pupilTarget.x-eye2.x))
  table.insert(self.pupils, pupil1)
  table.insert(self.pupils, pupil2)
  
  
  self.mouthPoint = self:returnPointAngle(self.lastPoint, self.mouthDist, self.lastPoint.ang)
  
  self.minDistance = math.huge
  self.detectedPellet = nil
  for i = #self.pellets, 1, -1 do
    local pellet = self.pellets[i]
    local deltaX = pellet.x - self.mouthPoint.x
    local deltaY = pellet.y - self.mouthPoint.y
    local distance = math.sqrt(deltaX^2 + deltaY^2)
    if distance < self.detectDistance and distance < self.minDistance then
      self.minDistance = distance
      self.detectedPellet = pellet
    end
    if distance <= self.eatDistance + self.pelletSize then
      --self:eatPellet(pellet)
      table.remove(self.pellets, i)
      self.score = self.score + 1
      if self.score >= self.nPellets then
        Timer.after(1, function() gStateStack:push(ScoreState({})) end)
        
      end
    end
  end
  
  if self.detectedPellet then
    self.mouthScale = math.min(0.15, 0.05*self.detectDistance/self.minDistance)
    
    local pupilTarget = self.detectedPellet
    self.pupils[1] = self:returnPointAngle(eye1, self.pupilDist, math.atan2(pupilTarget.y-eye1.y , pupilTarget.x-eye1.x))
    self.pupils[2] = self:returnPointAngle(eye2, self.pupilDist, math.atan2(pupilTarget.y-eye2.y , pupilTarget.x-eye2.x))
  else
    self.mouthScale = 0.05
  end
  
  
  
end





function TestState2:returnPointAngle(point, distance, angle)
  
  local newX = point.x + distance * math.cos(angle)
  local newY = point.y + distance * math.sin(angle)
  
  return {x = newX, y = newY}
  
end




function TestState2:render()
  
  --love.graphics.setCanvas(self.canvas)
  --love.graphics.clear()
  
  
  
  
  -- background image
  love.graphics.setColor(colors.white)
  local pFactor = self.parallaxFactor
  local xBackOffset = 500
  love.graphics.draw(self.background,xBackOffset -self.areaSize/2 - self.camera.x/pFactor, -self.areaSize/2 - self.camera.y/pFactor, 0, self.backgroundScale, self.backgroundScale)
  
  
  -- squared background
  local function shadowStencil()
    love.graphics.rectangle('fill', -self.areaSize/2 - self.camera.x, -self.areaSize/2 - self.camera.y, self.areaSize, self.areaSize)
  end
  
  love.graphics.stencil(shadowStencil, "replace", 1)
  love.graphics.setStencilTest("equal", 0)
  love.graphics.setColor({0,0,0,0.3})
  love.graphics.rectangle('fill', -self.areaSize - self.camera.x, -self.areaSize - self.camera.y, 2*self.areaSize, 2*self.areaSize)
  love.graphics.setStencilTest()
  
  
  
  
  
  
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
      love.graphics.circle('fill', point.x - self.camera.x, point.y - self.camera.y, point.r + self.lineWidth/2)
      love.graphics.setColor(colors.black)
      love.graphics.circle('fill', point.x - self.camera.x, point.y - self.camera.y, point.r - self.lineWidth/2)
    end
    
  end
  
  if self.skin then
    love.graphics.setLineWidth(self.skinWidth)
    
    
    if self.skinFill then
      love.graphics.setColor(self.skinColor)
      
      self.skinPointsPure = removeDuplicatePoints(self.skinPointsPure, 1e-5)
      
      
      
      
      for i, triangle in ipairs(self.triangles) do
        --love.graphics.setColor(math.random(), math.random(), math.random())
        love.graphics.setColor(self.skinColor)
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
    
    love.graphics.setColor(self.skinLineColor)
    local smoothPoints = generateSmoothCurve(self.skinPoints, 100, self.camera)
    love.graphics.line(smoothPoints)
    
    
    
  end
  
  
  if self.mouth then
    love.graphics.setColor(colors.white)
    local scale = self.mouthScale
    local offsetX = - self.camera.x + scale*self.mouthSizeY*math.sin(self.lastPoint.ang)  -- - math.sin(self.lastPoint.ang)
    local offsetY = - self.camera.y - scale*self.mouthSizeY*math.cos(self.lastPoint.ang)
    love.graphics.draw(self.mouthCanvas, self.mouthPoint.x + offsetX, self.mouthPoint.y + offsetY, self.lastPoint.ang, scale, scale)
    
    
    -- draw mouth collider with pellets
    love.graphics.setColor(colors.green)
    --love.graphics.circle('fill', self.mouthPoint.x - self.camera.x, self.mouthPoint.y - self.camera.y, self.eatDistance)
    
    love.graphics.setColor(1,0,0,0.2)
    love.graphics.circle('fill', self.mouthPoint.x - self.camera.x, self.mouthPoint.y - self.camera.y, self.detectDistance)
    
    
    --love.graphics.ellipse('fill', self.mouthPoint.x - self.camera.x, self.mouthPoint.y - self.camera.y, self.mouthSizeX)
  end
  
  if self.eyes then
    love.graphics.setLineWidth(self.skinWidth)
    for _, eye in pairs(self.eyeList) do
      love.graphics.setColor(colors.black)
      love.graphics.circle('fill', eye.x - self.camera.x, eye.y - self.camera.y, self.eyeSize)
      love.graphics.setColor(colors.white)
      love.graphics.circle('line', eye.x - self.camera.x, eye.y - self.camera.y, self.eyeSize)
    end
    love.graphics.setColor(colors.white)
    for _, pupil in pairs(self.pupils) do
      love.graphics.circle('fill', pupil.x - self.camera.x, pupil.y - self.camera.y, self.pupilSize)
    end
  end
  
  
  
  
  -- draw pellets
  love.graphics.setColor(colors.white)
  for _, pellet in pairs(self.pellets) do
    love.graphics.circle('fill', pellet.x - self.camera.x, pellet.y - self.camera.y, self.pelletSize)
  end




  
  if self.printRedPoints then
    love.graphics.setColor(colors.red)
    love.graphics.circle('fill', self.redPoint.x - self.camera.x, self.redPoint.y - self.camera.y, 3)
    
    for _, point in pairs(self.skinPoints) do
      love.graphics.circle('fill', point.x - self.camera.x, point.y - self.camera.y, 6)
    end
  end
  
  
  love.graphics.setColor(colors.blue)
  if self.printBluePoints and self.bluePoints then
    for _, point in ipairs(self.bluePoints) do
      love.graphics.circle('fill', point.x - self.camera.x, point.y - self.camera.y, 6)
    end
  end

  
  love.graphics.setFont(gFonts['medium'])
  love.graphics.setColor(colors.red)
  love.graphics.print('Speed status: '..self.speedStatus, 1000, 10)
  love.graphics.print('Speed: '..self.speed, 1000, 100)
  love.graphics.print('Swing Angle = '.. self.swingAngle, 1000, 200)
  love.graphics.print('Speeds x,y = '..math.floor(self.cameraSpeeds.x)..' ,'..math.floor(self.cameraSpeeds.y), 1000, 300)
  love.graphics.print('Ang = '..self.lastPoint.ang, 1000, 400)
  love.graphics.print('minDistance = '..self.minDistance, 1000, 500)
  
  love.graphics.setFont(gFonts['big'])
  love.graphics.printf(self.score, 0, 100, VIRTUAL_WIDTH, 'right')
  
  --[[
  love.graphics.setCanvas()
  
  love.graphics.setColor(colors.white)
  local scaleFactor = 2
  if love.window.getFullscreen() then
    scaleFactor = 1
  end
  print(scaleFactor)
  love.graphics.draw(self.canvas, 0, 0, 0, scaleFactor, scaleFactor)
  ]]

  --[[
    -- Aplicar el shader de desenfoque horizontal
    self.blurShader:send("direction", {1.0, 0.0}) -- Horizontal
    self.blurShader:send("radius", blurRadius)
    love.graphics.setShader(self.blurShader)
    love.graphics.draw(self.canvas)

    -- Aplicar el shader de desenfoque vertical
    self.blurShader:send("direction", {0.0, 1.0}) -- Vertical
    love.graphics.setShader(self.blurShader)
    love.graphics.draw(self.canvas)

    -- Restablecer el shader para futuros dibujos sin desenfoque
    love.graphics.setShader()
  ]]
end


function TestState2:constrainPoint(anchorPoint, movedPoint, distance, angleLimit)
  
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


