MainMenuState = Class{__includes = BaseState}

function MainMenuState:init(def)
    self.type = 'MainMenu'
    
    --self.returned = def.returned
    self.returned = true
    
    
    self.blackTimer = 0
    self.blackOpacity = 0
    self.allowInput = true
    if self.returned then
      self.blackOpacity = 1
      self.allowInput = false
    end

    self.blackTimerMax = transitionTime
    
    levelAccuracyRatings = defaultLevelAccuracyRatings
    
    self.moved = moved
    self.rotated = rotated
    self.cut = cut
    
    self.missionTimer = 0
    self.missionTimerMax = 0.35
    
    self.knife = gTextures['knife']
    self.knifeWidth = self.knife:getWidth()
    self.knifeHeight = self.knife:getHeight()
    self.lineAng = math.pi/-12
    self.titleThickness = 20
    self.lowerAmount = 0
    
    self.mask_shader = love.graphics.newShader[[
       vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
          if (Texel(texture, texture_coords).a == 0.0) {
             discard;
          }
          return vec4(1.0);
       }
    ]]
    
    music1:play()
    
    self.oksound = gSounds['ok']
    self.oksound:setVolume(0.1)
    self.oksound:setPitch(0.8)
end



function MainMenuState:update(dt)
  
  local x, y = push:toGame(love.mouse.getPosition())
  self.x = x
  self.y = y
  
  local yFactor = y / VIRTUAL_HEIGHT
  
  if love.mouse.wasPressed(2) then
    self.rotating = true
  end
  
  if love.mouse.wasReleased(2) then
    self.rotating = false
  end
  
  if love.mouse.isDown(1) then
    self.lowering = true
    self.hasClicked = true
  end
  
  if love.mouse.wasReleased(1) then
    self.lowering = false
  end
  
  if self.rotating and self.lastMouseX then
    local deltaX = x - self.lastMouseX
    self.lineAng = self.lineAng + deltaX * 0.001
  end
  
  
  
  if not self.knifeDistance then
    self.knifeDistance = math.max(25, math.min(100, 200 * (0.8 - yFactor)))
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
  
  
  if transitions and self.buttonPressed then
    self.blackTimer = self.blackTimer + dt
    if self.blackTimer >= self.blackTimerMax then
      self.blackTimer = self.blackTimerMax
      gStateStack:pop()
      gStateStack:push(TestState({level = 1,}))
      gStateStack:push(InLevelState({level = 1}))
      music1:stop()
    end
    self.blackOpacity = self.blackTimer / self.blackTimerMax
  end
  
  if self.returned then
    self.blackOpacity = self.blackOpacity - dt
    if self.blackOpacity < 0 then
      self.blackOpacity = 0
      self.allowInput = true
      self.returned = false
    end    
  end
  
  
  if not self.moved then
    
    if self.lastMouseX and (self.lastMouseX ~= x or self.lastMouseY ~= y) then
      self.missionTimer = self.missionTimer + dt
      if self.missionTimer >= self.missionTimerMax then
        self.oksound:stop()
        self.oksound:play()
        self.moved = true
        moved = true
        self.missionTimer = 0
      end
    else
      self.missionTimer = 0
    end

    
  elseif not self.rotated then
    
    if self.rotating then
      self.missionTimer = self.missionTimer + dt
      if self.missionTimer >= self.missionTimerMax then
        self.oksound:stop()
        self.oksound:play()
        self.rotated = true
        rotated = true
        self.missionTimer = 0
      end
    else
      self.missionTimer = 0
    end
    
  elseif not self.cut then
    
    if self.lowering then
      self.missionTimer = self.missionTimer + dt
      if self.missionTimer >= self.missionTimerMax then
        self.oksound:stop()
        self.oksound:play()
        self.cut = true
        cut = true
        self.missionTimer = 0
      end
    else
      self.missionTimer = 0
    end
    
  elseif self.hasClicked and not self.newStateStarting then
    self.newStateStarting = true
    transitionSound:seek(0.6)
    transitionSound:play()
    if transitions then
      self.allowInput = false
      self.buttonPressed = true
    else
      gStateStack:pop()
      gStateStack:push(TestState({level = 1,}))
      gStateStack:push(InLevelState({level = 1}))
      music1:stop()
    end
  end
  
  self.lastMouseX = x
  self.lastMouseY = y
  
end



function MainMenuState:render()
  
  -- draw
  
  
  --draw background
  love.graphics.setColor(colors.darkgrey2)
  love.graphics.rectangle('fill',0,0,VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
  
  
  
  

  love.graphics.setColor(1,1,1,0.85)

  love.graphics.setFont(gFonts['large'])
  love.graphics.print('Knife Instructions:',100, 500)
  
  
  love.graphics.setFont(gFonts['medium'])
  love.graphics.print('Mouse to Move',200, 700)
  love.graphics.print('Move and hold right click to Rotate',200, 800)
  love.graphics.print('Hold left click to Cut',200, 900)
  
  love.graphics.circle('fill', 170, 730, 10)
  love.graphics.circle('fill', 170, 830, 10)
  love.graphics.circle('fill', 170, 930, 10)
  
  --[[
  love.graphics.rectangle('fill', 700, 685, 100, 100)
  love.graphics.rectangle('fill', 1355, 785, 100, 100)
  love.graphics.rectangle('fill', 890, 885, 100, 100)
  ]]
  
  
  love.graphics.draw(gTextures['smallicons'], gFrames['smallicons'][1],700,685)
  love.graphics.draw(gTextures['smallicons'], gFrames['smallicons'][4],1355,785)
  love.graphics.draw(gTextures['smallicons'], gFrames['smallicons'][6],890,885)
  
  
  love.graphics.setColor(1,1,1,0.5)
  love.graphics.setFont(gFonts['small'])
  love.graphics.print('Made by JAlcaldeM',1600, 1020)
  
  

  
  
  love.graphics.setColor(colors.white)
  if self.moved then
    love.graphics.draw(gTextures['smallicons'], gFrames['smallicons'][2],700,685)
  end
  if self.rotated then
    love.graphics.draw(gTextures['smallicons'], gFrames['smallicons'][3],1355,785)
  end
  if self.cut then
    love.graphics.draw(gTextures['smallicons'], gFrames['smallicons'][5],890,885)
  end
  
  
  
  
  -- draw knife shadow to the background
  local function reverseStencilFunction()
    love.graphics.setShader(self.mask_shader)
    love.graphics.draw(gTextures['mainscreen'],0,-200)
    love.graphics.setShader()
  end

  love.graphics.stencil(reverseStencilFunction, "replace", 1)
  love.graphics.setStencilTest("equal", 0)
    
  if self.knifeDistance then
    love.graphics.setColor(0,0,0,0.3)
    love.graphics.draw(self.knife, self.x - self.knifeDistance - self.titleThickness, self.y + self.knifeDistance + self.titleThickness, self.lineAng, 1, 1, self.knifeWidth/2, self.knifeHeight/2)
  end
  love.graphics.setStencilTest()
  
  
  
  -- draw main title
  love.graphics.setColor(colors.white)
  love.graphics.draw(gTextures['mainscreen'],0,-200)
  
  
  
  -- draw knife shadow over main title
  local function maintitleStencilFunction()
    love.graphics.setShader(self.mask_shader)
    love.graphics.draw(gTextures['mainshadow'],0,-200)
    love.graphics.setShader()
  end

  love.graphics.stencil(maintitleStencilFunction, "replace", 1)
  love.graphics.setStencilTest("equal", 1)
    
  if self.knifeDistance then
    love.graphics.setColor(0,0,0,0.3)
    love.graphics.draw(self.knife, self.x - self.knifeDistance, self.y + self.knifeDistance, self.lineAng, 1, 1, self.knifeWidth/2, self.knifeHeight/2)
  end
  love.graphics.setStencilTest()
  
  
  
  
  -- draw the knife itself
  love.graphics.setColor(colors.white)
  love.graphics.draw(self.knife, self.x, self.y, self.lineAng, 1, 1, self.knifeWidth/2, self.knifeHeight/2)
  
  
  
  love.graphics.setColor(0, 0, 0, self.blackOpacity)
  love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
  
end


