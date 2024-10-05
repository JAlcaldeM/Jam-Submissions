OutLevelState = Class{__includes = BaseState}

function OutLevelState:init(def)
    self.type = 'OutLevelState'
    
    self.level = def.level
    local presetAccuracyRounded = roundToNDecimals(50, 2)
    self.testInfo = def.testInfo or {
      accuracyRounded = presetAccuracyRounded,
      accuracyString = 'Accuracy: '..string.format("%.2f", presetAccuracyRounded)..'%'
    }
    
    levelAccuracyRatings[self.level] = self.testInfo.accuracyRounded
    
    local thresholdValue = 95
    if self.testInfo.accuracyRounded >= thresholdValue then
      self.victory = true
    else
      self.victory = false
    end
    
    
    self.blackTimer = 0
    self.blackOpacity = 0
    self.allowInput = false

     
    self.blackTimerMax = transitionTime
    
    self.opacity = 0
    self.opacityTime = 0.5
    
    self.tipTimer = 0
    self.tipTimerMax = 2
    
    
    if self.victory then
      local drumrollStopTime = 2.17
      self.sound = gSounds['drumroll']
      self.sound:seek(drumrollStopTime)
      
    else
      self.sound = gSounds['fail']
    end
    self.sound:play()
    
end



function OutLevelState:update(dt)
  
  
  if love.mouse.wasPressed(1) and self.allowInput then
    if transitions then
      self.allowInput = false
      self.buttonPressed = true
    else
      self:nextLevel()
    end
  end
  
  
  if self.opacity < 1 then
    self.opacity = self.opacity + dt/self.opacityTime
  end
  
  
  if self.opacity > 1 or love.mouse.wasPressed(1) then
    self.opacity = 1
    self.allowInput = true
  end 
  
  
  
  if transitions and self.buttonPressed then
    self.blackTimer = self.blackTimer + dt
    if self.blackTimer >= self.blackTimerMax then
      self.blackTimer = self.blackTimerMax
      self:nextLevel()
    end
    self.blackOpacity = self.blackTimer / self.blackTimerMax
  end
  
  self.tipTimer = self.tipTimer + dt
  if self.tipTimer >= self.tipTimerMax and self.blackOpacity == 0 then
    self.printTip = true
  end
  
end



function OutLevelState:render()
  
  
  
  if self.victory then
    love.graphics.setColor(0.2, 0.8, 0.2, 0.5*self.opacity)
  else
    love.graphics.setColor(0.8, 0.2, 0.2, 0.5*self.opacity)
  end
  
  love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
  
  
  love.graphics.setFont(gFonts['large'])
  love.graphics.setColor(1,1,1,self.opacity)
  local text = 'Level '..self.level
  if self.level == 10 then
    text = 'Final Level'
  end
  love.graphics.printf(text, 0, 100, VIRTUAL_WIDTH, 'center')
  love.graphics.printf(levelNames[self.level], 0, 300, VIRTUAL_WIDTH, 'center')
  love.graphics.printf(self.testInfo.accuracyString, 0, 600, VIRTUAL_WIDTH, 'center')
  
  
  
  
  love.graphics.setFont(gFonts['smallmedium'])
  love.graphics.printf('Required accuracy: 95%', 0, 750, VIRTUAL_WIDTH, 'center')
  
  
  love.graphics.setFont(gFonts['medium'])
  if self.printTip then
    love.graphics.printf('Click to continue', 0, 900, VIRTUAL_WIDTH, 'center')
  end
  
  love.graphics.setColor(0, 0, 0, self.blackOpacity)
  love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
  
end

function OutLevelState:nextLevel()
  gStateStack:pop()
  gStateStack:pop()
  
  transitionSound:seek(0.6)
  transitionSound:play()
    
  if self.victory then
    if self.level < 10 then
      gStateStack:push(TestState({level = self.level + 1}))
      gStateStack:push(InLevelState({level = self.level + 1}))
    else
      gStateStack:push(FinalState({}))
    end
  else
    gStateStack:push(MainMenuState({}))
  end
  

end

