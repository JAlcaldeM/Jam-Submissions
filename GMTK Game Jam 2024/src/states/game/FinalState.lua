FinalState = Class{__includes = BaseState}

function FinalState:init(def)
    self.type = 'FinalState'
    
    self.blackTimer = 0
    self.blackOpacity = 0
    self.allowInput = false

    self.blackTimerMax = transitionTime
    
    self.opacity = 0
    self.opacityTime = 0.5
    
    self.tipTimer = 0
    self.tipTimerMax = 5
    
    self.accuracyRatings = {}


    self.averageAccuracy = string.format("%.2f", mean(levelAccuracyRatings))
    
    self.mode = 2
    
    for i = 1, 10 do
      self.accuracyRatings[i] = i..'   '..levelNames[i]..'   '..string.format("%.2f", levelAccuracyRatings[i])
      if self.mode == 2 then
        self.accuracyRatings[i] = string.format("%.2f", levelAccuracyRatings[i])
      end
    end
    
    self.yValues = {}
    local startingPos = 200
    for i = 1, 5 do
      self.yValues[i] = startingPos + 100*(i-1)
      self.yValues[i+5] = startingPos + 100*(i-1)
    end
    
    self.sound = gSounds['applause']
    self.sound:play()
    
    self.soundTimer = 0
    self.soundTimerMax = 5
    self.hearingSound = true
    
    
    
    
    
    self.posValues = {
      {x = 320, y = 230},
      {x = 320, y = 450},
      {x = 320, y = 680},
      {x = 320, y = 880},
      {x = 900, y = 230},
      {x = 900, y = 450},
      {x = 900, y = 680},
      {x = 900, y = 880},
      {x = 1480, y = 230},
      {x = 1480, y = 450},
      {x = 1280, y = 750},
      }
    
end



function FinalState:update(dt)
  
  if self.hearingSound then
    self.soundTimer = self.soundTimer + dt
    if self.soundTimer > self.soundTimerMax then
      self.soundTimer = self.soundTimerMax
      self.hearingSound = false
    end
    local volume = (self.soundTimerMax - self.soundTimer)/self.soundTimerMax
    self.sound:setVolume(volume)
    
  end
  
  
  
  if love.mouse.wasPressed(1) and self.allowInput then
    if transitions then
      self.allowInput = false
      self.buttonPressed = true
    else
      self:mainMenu()
    end
  end
  
  
  if self.opacity < 1 then
    self.opacity = self.opacity + dt/self.opacityTime
  end
  
  
  if self.opacity > 1 or love.mouse.wasPressed(1) then
    self.opacity = 1
    self.allowInput = true
  end 
  

  
  if transitions and self.buttonPressed and self.canExit then
    self.blackTimer = self.blackTimer + dt
    if self.blackTimer >= self.blackTimerMax then
      self.blackTimer = self.blackTimerMax
      self:mainMenu()

    end
    self.blackOpacity = self.blackTimer / self.blackTimerMax
  end
  
  self.tipTimer = self.tipTimer + dt
  if self.tipTimer >= self.tipTimerMax and self.blackOpacity == 0 then
    self.printTip = true
    self.canExit = true
  end
  

  
end



function FinalState:render()
  
  if self.mode == 1 then
    
    love.graphics.setColor(0.5, 0.5, 0.5, 0.5*self.opacity)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    
    love.graphics.setFont(gFonts['mediumlarge'])
    love.graphics.setColor(1,1,1,self.opacity)
    love.graphics.printf('Congratulations! You beat the game!', 0, 50, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Average accuracy: '..self.averageAccuracy..' %', 0, 750, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    for i = 1,10 do
      local x = 0
      if i >= 6 then
        x = VIRTUAL_WIDTH/2
      end
      love.graphics.printf(self.accuracyRatings[i], x, self.yValues[i], VIRTUAL_WIDTH/2, 'center')
    end
    
    if self.printTip then
      love.graphics.printf('Click to continue', 0, 950, VIRTUAL_WIDTH, 'center')
    end
    
  elseif self.mode == 2 then
    
    love.graphics.setColor(1,1,1,self.opacity)
    love.graphics.draw(gTextures['finalscreen'])
    
    love.graphics.setFont(gFonts['mediumlarge'])
    for i = 1,10 do
      love.graphics.print(self.accuracyRatings[i], self.posValues[i].x, self.posValues[i].y)
    end
    
    
    love.graphics.setFont(gFonts['large'])
    love.graphics.print(self.averageAccuracy..' %', self.posValues[11].x,self.posValues[11].y)
  end

  
  

  love.graphics.setColor(0, 0, 0, self.blackOpacity)
  love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
  
end

function FinalState:mainMenu()
  gStateStack:pop()
  gStateStack:push(MainMenuState({returned = true}))
end

