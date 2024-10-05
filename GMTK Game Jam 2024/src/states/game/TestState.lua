TestState = Class{__includes = BaseState}

function TestState:init(def)
    self.type = 'Test'
    
    self.level = def.level
    
    self.spriteNumber = self.level
    
    self.canvasWidth = 600
    self.canvasHeight = 600
    
    self.canvasX = VIRTUAL_WIDTH/2 - self.canvasWidth/2
    self.canvasY = VIRTUAL_HEIGHT/2 - self.canvasHeight/2
    self.canvas = love.graphics.newCanvas(self.canvasWidth, self.canvasHeight)
    
    self.canvasX1 = self.canvasX
    self.canvasY1 = self.canvasY
    self.canvasX2 = self.canvasX
    self.canvasY2 = self.canvasY
    
    self.canvasCorners = {
      {x = self.canvasX, y = self.canvasY}, -- upper left
      {x = self.canvasX + self.canvasWidth, y = self.canvasY}, -- upper right
      {x = self.canvasX + self.canvasWidth, y = self.canvasY + self.canvasHeight}, -- lower right
      {x = self.canvasX, y = self.canvasY + self.canvasHeight}, -- lower left
    }
    
    self.upperCorners = {self.canvasCorners[1],self.canvasCorners[2]}
    self.lowerCorners = {self.canvasCorners[3],self.canvasCorners[4]}
    

    self.mask = self.canvas
    self.mask_shader = love.graphics.newShader[[
       vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
          if (Texel(texture, texture_coords).a == 0.0) {
             discard;
          }
          return vec4(1.0);
       }
    ]]

    
    love.graphics.setCanvas(self.canvas)
    love.graphics.setColor(colors.white)
    love.graphics.draw(gTextures['food'], gFrames['food'][self.spriteNumber])
    love.graphics.setCanvas()
    
    self.itemThickness = itemsThickness[self.level]
    self.itemSpace = 0

    self.shadowCanvas = self:createShadowCanvas(self.canvas, self.itemThickness)


    self.lineX = 0
    self.lineAng = -math.pi/12
    self.rotating = false
    self.lowering = false
    self.lowerAmount = 0
    
    self.canvasX = VIRTUAL_WIDTH / 2 - self.canvasWidth / 2
    self.canvasY = VIRTUAL_HEIGHT / 2 - self.canvasHeight / 2

    
    self.knife = gTextures['knife']
    self.knifeWidth = self.knife:getWidth()
    self.knifeHeight = self.knife:getHeight()
    
    self.allowInput = true
    
    self.renderItem = true
    
    self.backgroundX = 0
    
    
    self.scale = gTextures['scale']
    self.scaleWidth = self.scale:getWidth()
    self.scaleHeight = self.scale:getHeight()
    self.scaleX1 = 0.25*VIRTUAL_WIDTH - self.scaleWidth/2 + 1920
    self.scaleX2 = 0.75*VIRTUAL_WIDTH - self.scaleWidth/2 + 1920
    self.scaleY = 0.5*VIRTUAL_HEIGHT - self.scaleHeight/2
    
    self.centerStyle = centerStyle[self.level]
    
    self.weight1 = 0
    self.weight2 = 0
    
    self.woodentable = gTextures['woodentable']
    self.woodThickness = 50
    self.woodentableWidth = self.woodentable:getWidth()
    self.woodentableHeight = self.woodentable:getHeight()
    self.woodentableX = 0.5*VIRTUAL_WIDTH - self.woodentableWidth/2
    self.woodentableY = 0.5*VIRTUAL_HEIGHT - self.woodentableHeight/2
    
    self.woodCanvas = love.graphics.newCanvas(self.woodentableWidth, self.woodentableHeight)
    love.graphics.setCanvas(self.woodCanvas)
    love.graphics.setColor(colors.white)
    love.graphics.draw(self.woodentable)
    love.graphics.setCanvas()
    self.woodShadowCanvas = self:createShadowCanvas(self.woodCanvas, self.woodThickness)
    
    self.renderKnife = true
    
    self.infoWidth = 200
    self.infoHeight = 200
    self.infoX = VIRTUAL_WIDTH/2 - self.infoWidth/2
    self.infoY = 800
    
    
    self.knifeSound = gSounds['knifetable']
    self.itemSound = itemSounds[self.level]
end




function TestState:update(dt)
  
  

  
  local x, y = push:toGame(love.mouse.getPosition())
  self.x = x
  self.y = y
  
  if x >= 0.25*VIRTUAL_WIDTH and x <= 0.75*VIRTUAL_WIDTH and y >= 0.4*VIRTUAL_HEIGHT and y <= 0.85*VIRTUAL_HEIGHT then
    self.cutAllowed = true
  else
    self.cutAllowed = false
  end
  
  
  local yFactor = y / VIRTUAL_HEIGHT
  
  if not self.knifeDistance then
    self.knifeDistance = math.max(25, math.min(100, 200 * (0.8 - yFactor)))
  end
  
  
  local deltaY
  if self.lastMouseY then
    deltaY = y - self.lastMouseY
  end
  
  if (not self.cutStarted) and self.knifeDistance <= 0 then
    -- knife starts cutting sound
    self.cutStarted = true
    self.lowering = false
    
    local edgeWidth = 8
    self.xSliceMov = edgeWidth * math.cos(self.lineAng)
    self.ySliceMov = edgeWidth * math.sin(self.lineAng)
    local nPixels1 = countNonTransparentPixels(self.canvas1)
    local nPixels2 = countNonTransparentPixels(self.canvas2)
    if nPixels1 == 0 or nPixels2 == 0 then
      self.xSliceMov = 0
      self.ySliceMov = 0
    end
    
    -- canvas derecho positivos, canvas izquierdo negativos
    --print(self.lineAng, self.xSliceMov, self.ySliceMov)
    self.cutSpeed = 100
    self.cutTime = self.itemThickness/self.cutSpeed
    Timer.tween(self.cutTime, {
        [self] = {canvasX1 = self.canvasX1 - self.xSliceMov, canvasY1 = self.canvasY1 - self.ySliceMov, canvasX2 = self.canvasX2 + self.xSliceMov, canvasY2 = self.canvasY2 + self.ySliceMov, knifeDistance = self.knifeDistance - self.itemThickness}
      })
    
    self.renderItem = false
    self.renderCanvas = true
    self.recalculateShadowCanvas = true
    self.allowInput = false
    
    
    self.shadowCanvas1 = self:createShadowCanvas(self.canvas1, self.itemThickness)
    self.shadowCanvas2 = self:createShadowCanvas(self.canvas2, self.itemThickness)
    
    if not (nPixels1 == 0 or nPixels2 == 0) then
      local itemSoundAdvanceTime = itemSoundsTime[self.level]
      self.itemSound:seek(itemSoundAdvanceTime)
      self.itemSound:play()
    end
    
    
    local knifeSoundAdvanceTime = 0.3
    local seekValue = knifeSoundAdvanceTime - self.cutTime
    if seekValue >= 0 then
      self.knifeSound:seek(seekValue)
      self.knifeSound:play()
    else
      Timer.after(-seekValue, function() self.knifeSound:play() end)
    end

    
  end
  
  
  if self.cutStarted then
    
    --self.knifeDistance = self.knifeDistance - dt*self.cutSpeed

    if (not self.cutPerformed) and self.knifeDistance <= -self.itemThickness then

      if self.itemSound:isPlaying() then
          self.itemSound:stop()
      end
      self:startWeight()
    end
  end

  
  
  if (not self.cutPerformed) and self.knifeDistance <= -self.itemThickness then
    self:startWeight()
  end
  
  
  if not self.allowInput then
    return
  end
  

  if not self.cutStarted then
    self.knifeX = x
    self.knifeY = y
  end
  
  
  if not self.cutStarted then
    if love.mouse.wasPressed(2) then
      self.rotating = true
    end
    
    if love.mouse.wasReleased(2) then
        self.rotating = false
    end
    
    --[[
    if love.mouse.wasPressed(1) then
        self.lowering = true
    end
    ]]
    if love.mouse.isDown(1) then
      self.lowering = true
    end
     
    
    if love.mouse.wasReleased(1) or (not self.cutAllowed) then
        self.lowering = false
    end
  end
  
  
  
  if self.rotating and self.lastMouseX then
    local deltaX = x - self.lastMouseX
    self.lineAng = self.lineAng + deltaX * 0.001
  end
  

  self.lineAng = math.min(self.lineAng, 0.45*math.pi)
  self.lineAng = math.max(self.lineAng, -0.45*math.pi)
  
  if not self.cutStarted then
    if not self.knifeDistance then
      --self.knifeDistance = math.max(25, math.min(100, 200 * (0.8 - yFactor)))
    elseif self.lowering then
      local lowerAmount = 50*dt
      self.knifeDistance = self.knifeDistance - lowerAmount
      self.lowerAmount = self.lowerAmount + lowerAmount
    elseif self.lowerAmount > 0 then
      local upAmount = math.min(100*dt, self.lowerAmount)
      self.knifeDistance = self.knifeDistance + upAmount
      self.lowerAmount = self.lowerAmount - upAmount
    else
      self.knifeDistance = math.max(25, math.min(100, 200 * (0.8 - yFactor)))
    end
    
    self.knifeDistance = math.min(100, self.knifeDistance)
  end
  
  
  
  
  
  self.lastMouseX = x
  self.lastMouseY = y
  
  --[[
  if love.keyboard.wasPressed('p') then
    self.itemSpace = self.itemSpace + 5
  end
  ]]
  
  
  
  if self.renderCanvas then
    return
  end
  

  
  
  -- intersection calculations
  local m = math.tan(self.lineAng + math.pi/2)
  local h = self.canvasHeight
  local w = self.canvasWidth
  
  local frameCornersLeft = {}
  local frameCornersRight = {}
  
  local coords1 = {}
  local coords2 = {}
  
  
  local x_intersect_upper = self.x + (self.canvasY - self.y) / m
  local x_intersect_lower = self.x + (self.canvasY + h - self.y) / m
  
  local intersectUpperPoint = {x = x_intersect_upper, y = self.canvasY}
  local intersectLowerPoint = {x = x_intersect_lower, y = self.canvasY + self.canvasHeight}
  


  -- Verificar si intersectUpperPoint está fuera del canvas
  if intersectUpperPoint.x < self.canvasX then
      -- Calcular intersección con el borde izquierdo del canvas (x = self.canvasX)
      local y_intersect_left = self.y + m * (self.canvasX - self.x)
      intersectUpperPoint = {x = self.canvasX, y = y_intersect_left}
  elseif intersectUpperPoint.x > self.canvasX + w then
      -- Calcular intersección con el borde derecho del canvas (x = self.canvasX + self.canvasWidth)
      local y_intersect_right = self.y + m * (self.canvasX + w - self.x)
      intersectUpperPoint = {x = self.canvasX + w, y = y_intersect_right}
  end

  -- Verificar si intersectLowerPoint está fuera del canvas
  if intersectLowerPoint.x < self.canvasX then
      -- Calcular intersección con el borde izquierdo del canvas (x = self.canvasX)
      local y_intersect_left = self.y + m * (self.canvasX - self.x)
      intersectLowerPoint = {x = self.canvasX, y = y_intersect_left}
  elseif intersectLowerPoint.x > self.canvasX + w then
      -- Calcular intersección con el borde derecho del canvas (x = self.canvasX + self.canvasWidth)
      local y_intersect_right = self.y + m * (self.canvasX + w - self.x)
      intersectLowerPoint = {x = self.canvasX + w, y = y_intersect_right}
  end
  


  self.upperCutPoint = intersectUpperPoint
  self.lowerCutPoint = intersectLowerPoint
  
  
  
  -- for left side, add x and y coordinates of any upper corners in clockwise order
  table.insert(coords2, intersectLowerPoint.x - self.canvasX)
  table.insert(coords2, intersectLowerPoint.y - self.canvasY)
  table.insert(coords2, intersectUpperPoint.x - self.canvasX)
  table.insert(coords2, intersectUpperPoint.y - self.canvasY)
  
  -- for right side, add both lower and upper (in that order) intersection points to coord2, and then add any upper corners in clockwise order
  for _, corner in pairs(self.upperCorners) do
    if corner.x < x_intersect_upper then
      table.insert(frameCornersLeft, corner)
      table.insert(coords1, corner.x - self.canvasX)
      table.insert(coords1, corner.y - self.canvasY)
    else
      table.insert(frameCornersRight, corner)
      table.insert(coords2, corner.x - self.canvasX)
      table.insert(coords2, corner.y - self.canvasY)
    end
  end
  
  -- now for left side, add both upper and lower (in that order) instersection points to coord1
  table.insert(coords1, intersectUpperPoint.x - self.canvasX)
  table.insert(coords1, intersectUpperPoint.y - self.canvasY)
  table.insert(coords1, intersectLowerPoint.x - self.canvasX)
  table.insert(coords1, intersectLowerPoint.y - self.canvasY)
  
  
  -- and for both sides, add any corner in its side in clockwise order
  for _, corner in pairs(self.lowerCorners) do
    if corner.x < x_intersect_lower then
      table.insert(frameCornersLeft, corner)
      table.insert(coords1, corner.x - self.canvasX)
      table.insert(coords1, corner.y - self.canvasY)
    else
      table.insert(frameCornersRight, corner)
      table.insert(coords2, corner.x - self.canvasX)
      table.insert(coords2, corner.y - self.canvasY)
    end
  end
  

  --print(#frameCornersLeft, #frameCornersRight)
  if #frameCornersLeft == 0 or #frameCornersRight == 0 then
    self.isCutAllowed = false
  else
    self.isCutAllowed = true
    self:divideCanvasByLine(coords1, coords2)
  end
  
  
end



function TestState:render()
  
  local renderKnife = self.renderKnife and (gStateStack:currentType() == 'Test')
  local x, y = push:toGame(love.mouse.getPosition())
  
  -- background
  --[[
  love.graphics.setColor(colors.grey)
  love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
  ]]
  
  -- render background
  love.graphics.setColor(colors.white)
  love.graphics.draw(gTextures['background'], self.backgroundX, 0)
  
  --render scales
  love.graphics.draw(self.scale, self.scaleX1, self.scaleY)
  love.graphics.draw(self.scale, self.scaleX2, self.scaleY)
  
  -- render shadow from knife to background
  if renderKnife then
    local function reverseStencilFunction()
      love.graphics.setShader(self.mask_shader)
      love.graphics.draw(self.woodShadowCanvas, self.woodentableX - self.itemThickness - 10, self.woodentableY) -- no idea why -10 extra in x axis
      love.graphics.setShader()
    end

    love.graphics.stencil(reverseStencilFunction, "replace", 1)
    love.graphics.setStencilTest("equal", 0)
      
    if self.knifeDistance then
      love.graphics.setColor(0,0,0,0.3)
      love.graphics.draw(self.knife, self.knifeX - self.knifeDistance - self.itemThickness - self.woodThickness, self.knifeY + self.knifeDistance + self.itemThickness + self.woodThickness, self.lineAng, 1, 1, self.knifeWidth/2, self.knifeHeight/2)
    end
    love.graphics.setStencilTest()
  end
  
  
  -- render wooden table and shadow
  love.graphics.setColor(0,0,0,0.3)
  love.graphics.draw(self.woodShadowCanvas, self.woodentableX - self.woodThickness, self.woodentableY)
  love.graphics.setColor(1,1,1,1)
  love.graphics.draw(self.woodCanvas, self.woodentableX, self.woodentableY)
  
  
  
  -- shadow from the item
  if self.renderItem then
    love.graphics.setColor(0,0,0,0.3)
    love.graphics.draw(self.shadowCanvas, self.canvasX - self.itemThickness - self.itemSpace, self.canvasY + self.itemSpace)
  end
  
  -- shadow from the halves
  if self.renderCanvas then
    love.graphics.setColor(0,0,0,0.3)
    love.graphics.draw(self.shadowCanvas1, self.canvasX1 - self.itemThickness - self.itemSpace, self.canvasY1 + self.itemSpace)
    
    -- if both shadowcanvas overlap, we apply a stencil corresponding to the first shadowcanvas to the rendering of the second shadowCanvas
    if self.recalculateShadowCanvas then
      local function reverseStencilFunction()
        love.graphics.setShader(self.mask_shader)
        love.graphics.draw(self.shadowCanvas1, self.canvasX1 - self.itemThickness - self.itemSpace, self.canvasY1 + self.itemSpace)
        love.graphics.setShader()
      end

      love.graphics.stencil(reverseStencilFunction, "replace", 1)
      love.graphics.setStencilTest("equal", 0)
    end
    
    love.graphics.draw(self.shadowCanvas2, self.canvasX2 - self.itemThickness - self.itemSpace, self.canvasY2 + self.itemSpace)

    if self.recalculateShadowCanvas then
      love.graphics.setStencilTest()
    end

    
  end
  
  
  

  -- shadow from the knife on the wooden table
  if renderKnife then
    
    
    local function StencilFunction()
      
      love.graphics.setShader(self.mask_shader)
      love.graphics.draw(self.woodCanvas, self.woodentableX, self.woodentableY)
      love.graphics.setShader()
    end
    

    local function reverseStencilFunction()
      love.graphics.setShader(self.mask_shader)
      
      if self.renderItem then
        love.graphics.draw(self.shadowCanvas, self.canvasX - self.itemThickness - self.itemSpace, self.canvasY + self.itemSpace)
      else
        love.graphics.draw(self.shadowCanvas1, self.canvasX1 - self.itemThickness - self.itemSpace, self.canvasY1 + self.itemSpace)
        love.graphics.draw(self.shadowCanvas2, self.canvasX2 - self.itemThickness - self.itemSpace, self.canvasY2 + self.itemSpace)
      end
        
        love.graphics.setShader()
    end

    love.graphics.stencil(StencilFunction, 'replace', 1)
    love.graphics.stencil(reverseStencilFunction, 'replace', 0, true)
    love.graphics.setStencilTest('equal', 1)
      
    if self.knifeDistance then
      love.graphics.setColor(0,0,0,0.3)
      love.graphics.draw(self.knife, self.knifeX - self.knifeDistance - self.itemThickness, self.knifeY + self.knifeDistance + self.itemThickness, self.lineAng, 1, 1, self.knifeWidth/2, self.knifeHeight/2)
    end
    love.graphics.setStencilTest()
    
  end
  

  -- render the item
  if self.renderItem then
    love.graphics.setColor(colors.white)
    love.graphics.draw(self.canvas, VIRTUAL_WIDTH/2 - self.canvasWidth/2, VIRTUAL_HEIGHT/2 - self.canvasHeight/2)
  end
  
  -- render the halves
  if self.renderCanvas then
    --[[
    love.graphics.circle('fill', self.upperCutPoint.x, self.upperCutPoint.y, 10)
    love.graphics.circle('fill', self.lowerCutPoint.x, self.lowerCutPoint.y, 10)

    love.graphics.setColor(1,0.2,0.2, 0.5)
    love.graphics.draw(self.canvas1)
    love.graphics.setColor(0.2,1,0.2, 0.5)
    love.graphics.draw(self.canvas2)
    ]]
    local pieceAlpha = 1
    
    love.graphics.setColor(1,1,1, pieceAlpha)
    love.graphics.draw(self.canvas1, self.canvasX1, self.canvasY1)
    --[[
    if self.centroid1 then
      love.graphics.circle('fill', self.centroid1.x + self.canvasX1, self.centroid1.y + self.canvasY1, 10)
    end
    ]]
    
    
    love.graphics.setColor(1,1,1, pieceAlpha)
    love.graphics.draw(self.canvas2, self.canvasX2, self.canvasY2)
    
    --[[
    if self.centroid2 then
      love.graphics.circle('fill', self.centroid2.x + self.canvasX1, self.centroid2.y + self.canvasY1, 10)
    end
    ]]
  end
  
  
  if renderKnife then
    
    -- render the shadow of the knife on top of the object...
    if self.knifeDistance > 0 then
      love.graphics.setColor(0, 0, 0, 0.3)
 
      local function stencilFunction()
        love.graphics.setShader(self.mask_shader)
        love.graphics.draw(self.mask, VIRTUAL_WIDTH/2 - self.canvasWidth/2, VIRTUAL_HEIGHT/2 - self.canvasHeight/2)
        love.graphics.setShader()
      end
      
      love.graphics.stencil(stencilFunction, "replace", 1)
      love.graphics.setStencilTest("greater", 0)
      
      love.graphics.setColor(0,0,0,0.3)
      if self.knifeDistance then
        love.graphics.draw(self.knife, self.knifeX - self.knifeDistance, self.knifeY + self.knifeDistance, self.lineAng, 1, 1, self.knifeWidth/2, self.knifeHeight/2)
      end

      love.graphics.setStencilTest()
    end
    
    --...and then render the knife itself
    if self.knifeDistance then
      love.graphics.setColor(colors.white)
    love.graphics.draw(self.knife, self.knifeX, self.knifeY, self.lineAng, 1, 1, self.knifeWidth/2, self.knifeHeight/2)
    end
  end
  
  
  -- render ui stuff
  love.graphics.setLineWidth(5)

  if self.symmetryScore then
      love.graphics.setColor(1, 1, 1)
      love.graphics.print("Simetría: " .. math.floor(self.symmetryScore * 100) .. "%", 1000, 10)
  end

  if self.isCutAllowed then
    love.graphics.setColor(0, 1, 0)
  else
    love.graphics.setColor(1, 0, 0)
  end
  --love.graphics.line(self.lineX1, 0, self.lineX2, VIRTUAL_HEIGHT)
  
  --[[
  if self.knifeX then
    love.graphics.circle('fill', self.knifeX, self.knifeY, 10, 10)
  end
  ]]

    --[[
    love.graphics.setColor(0,0,1)
    love.graphics.circle('fill', 0.25*VIRTUAL_WIDTH, 0.4*VIRTUAL_HEIGHT,5)
    love.graphics.circle('fill', 0.75*VIRTUAL_WIDTH, 0.4*VIRTUAL_HEIGHT,5)
    ]]
    
    self.showWeights = true
    if self.showWeights then
      love.graphics.setColor(colors.black)
      love.graphics.setFont(gFonts['scaleWeight'])
      local margin = 615
      love.graphics.printf(formatNumber(self.weight1), self.backgroundX + 1920, 750, margin, 'right')
      love.graphics.printf(formatNumber(self.weight2), self.backgroundX + 1920 + VIRTUAL_WIDTH/2, 750, margin, 'right')
    end
    
end



function TestState:divideCanvasByLine(coords1, coords2)
    
    local canvas1 = love.graphics.newCanvas(self.canvasWidth, self.canvasHeight)
    local canvas2 = love.graphics.newCanvas(self.canvasWidth, self.canvasHeight)
    
    local function drawStencil1()
      love.graphics.polygon('fill', coords1)
    end
    
    local function drawStencil2()
      love.graphics.polygon('fill', coords2)
    end
    
    love.graphics.setCanvas{canvas1, stencil = true}
    love.graphics.clear()
    love.graphics.stencil(drawStencil1, "replace", 1)
    love.graphics.setStencilTest("greater", 0)
    love.graphics.setColor(colors.white)
    love.graphics.draw(self.canvas)
    love.graphics.setStencilTest()
    love.graphics.setCanvas()
    
    love.graphics.setCanvas{canvas2, stencil = true}
    love.graphics.clear()
    love.graphics.stencil(drawStencil2, "replace", 1)
    love.graphics.setStencilTest("greater", 0)
    love.graphics.setColor(colors.white)
    love.graphics.draw(self.canvas)
    love.graphics.setStencilTest()
    love.graphics.setCanvas()
    
    self.canvas1 = canvas1
    self.canvas2 = canvas2
    
    --print(canvas1, canvas2)
    
    self.centroid1 = calculateCentroid(coords1)
    self.centroid2 = calculateCentroid(coords2)
    
    if self.centerStyle == 'corrected' then
      self.centroidOffset1 = {x = self.canvasWidth/2 - self.centroid1.x, y = self.canvasHeight/2 - self.centroid1.y}
      self.centroidOffset2 = {x = self.canvasWidth/2 - self.centroid2.x, y = self.canvasHeight/2 - self.centroid2.y}
    elseif self.centerStyle == 'default' then
      self.centroidOffset1 = {x = 0, y = 0}
      self.centroidOffset2 = {x = 0, y = 0}
    end
    
    --print(self.centroidOffset1.x, self.centroidOffset1.y)
end

function TestState:startWeight()

    --[[
    local h1pos = {x = 0.25*VIRTUAL_WIDTH - self.canvasWidth/2 , y1 = 0.04*VIRTUAL_HEIGHT, y2 = 0.6*VIRTUAL_HEIGHT}
    local h2pos = {x = 0.75*VIRTUAL_WIDTH - self.canvasWidth/2, y1 = 0.04*VIRTUAL_HEIGHT, y2 = 0.6*VIRTUAL_HEIGHT}
    ]]
    
    
    
    local objX1 = 0.25*VIRTUAL_WIDTH - self.canvasWidth/2 + self.centroidOffset1.x
    local objX2 = 0.75*VIRTUAL_WIDTH - self.canvasWidth/2 + self.centroidOffset2.x
    local objY1 = 0.4*VIRTUAL_HEIGHT - self.canvasHeight/2 + self.centroidOffset1.y
    local objY2 = 0.4*VIRTUAL_HEIGHT - self.canvasHeight/2 + self.centroidOffset2.y
    
    local h1pos = {x = objX1 , y1 = objY1, y2 = objY1}
    local h2pos = {x = objX2, y1 = objY2, y2 = objY2}
    
    
    self.weithAnimation = true
    self.allowInput = false
    self.cutPerformed = true
    

       local easingFunction = Easing.inOutQuad
  
  
  local calculateWeights = function()
    
    local nPixels1 = countNonTransparentPixels(self.canvas1)
    local nPixels2 = countNonTransparentPixels(self.canvas2)

    local totalWeight = itemWeights[self.level]

    self.finalWeight1 = roundToNDecimals(totalWeight * nPixels1 / (nPixels1 + nPixels2), 3)
    self.finalWeight2 = roundToNDecimals(totalWeight * nPixels2 / (nPixels1 + nPixels2), 3)
    
    local accuracy = 100 * (totalWeight - math.abs(self.finalWeight1 - self.finalWeight2)) / totalWeight
    local accuracyRounded = roundToNDecimals(accuracy, 2)
    local accuracyString = 'Accuracy: '..string.format("%.2f", accuracyRounded)..'%'
    
    self.testInfo = {
      accuracyRounded = accuracyRounded,
      accuracyString = accuracyString
      }

end


  local animTime = 0.6--1--0.1
  
  
  local showWeights = function()
    calculateWeights()
    self.showWeights = true
    Timer.tween(animTime, {
          [self] = {weight1 = self.finalWeight1, weight2 = self.finalWeight2}
          }):ease(easingFunction)
    
    Timer.after(animTime*2, function()
        gStateStack:push(OutLevelState({level = self.level, testInfo = self.testInfo}))
        end)
  end
  
  
  local itemSpaceDelta = 50
  
  local changeShadows = function()
    Timer.tween(animTime, {
          [self] = {itemSpace = self.itemSpace - itemSpaceDelta}
          }):ease(easingFunction):finish(showWeights)
  end

  local moveBackground = function()
    self.recalculateShadowCanvas = false
    Timer.tween(animTime, {
          [self] = {backgroundX = -1920, woodentableX = self.woodentableX - 1920, scaleX1 = self.scaleX1 - 1920, scaleX2 = self.scaleX2 - 1920}
          }):ease(easingFunction):finish(changeShadows)
    
  end

  local piecesUp = function()
    --print('piecesUp')
    self.renderKnife = false,
    Timer.tween(animTime, {
        [self] = {canvasX1 = h1pos.x, canvasY1 = h1pos.y1, canvasX2 = h2pos.x, canvasY2 = h2pos.y1, itemSpace = self.itemSpace + itemSpaceDelta}
        }):ease(easingFunction)--:finish(moveBackground)
    
    Timer.after(animTime/2, function() moveBackground() end)
  end
  
  local knifeDown = function()
    Timer.tween(animTime, {
        [self] = {knifeY = self.knifeY + 2000}
        }):ease(easingFunction):finish(piecesUp)
    
  end
  
  local knifeUp = function()
    Timer.tween(animTime, {
        [self] = {knifeY = self.knifeY - 50, knifeDistance = self.knifeDistance + 50}
        }):ease(easingFunction):finish(knifeDown)
  
  end
  
  
  music2:stop()
  local afterCutDelay = 0.5
  Timer.after(afterCutDelay, function()
        knifeUp()
        end)
  
  local drumrollDelay = 2.3
  local drumrollStopTime = 2.1
  Timer.after(drumrollDelay, function()
      gSounds['drumroll']:play()
    end)
  Timer.after(drumrollDelay + drumrollStopTime, function()
      gSounds['drumroll']:stop()
    end)
  
  
  
end


function TestState:createShadowCanvas(canvas, itemThickness)
  
  local width = canvas:getWidth() + itemThickness
  local height = canvas:getHeight() + itemThickness
  local shadowCanvas = love.graphics.newCanvas(width, height)
  
  love.graphics.setCanvas{shadowCanvas, stencil=true}
  
  love.graphics.setColor(colors.white)

  for i = 0, itemThickness do
    love.graphics.draw(canvas, (itemThickness - i), i)
  end

  love.graphics.setCanvas()
  
  return shadowCanvas
  
end




