InLevelState = Class{__includes = BaseState}

function InLevelState:init(def)
    self.type = 'InLevelState'
    
    self.level = def.level
    
    self.blackTimer = 0
    if transitions then
      self.blackOpacity = 1
      self.allowInput = false
    else
      self.blackOpacity = 0
      self.allowInput = true
    end
     
    self.blackTimerMax = transitionTime
    
    self.printNumberX = - VIRTUAL_WIDTH
    self.printNameX = - VIRTUAL_WIDTH
    
    self.opacity = 1
    self.opacityTime = 0.5
    
    local animationSpeed = 1
    local delay = 0.2
    
    self.opacityFunction2 = function()
      Timer.tween(animationSpeed, {
        [self] = {printNumberX = VIRTUAL_WIDTH}
        }):ease(Easing.inExpo)
    
    Timer.after(delay, function()
        Timer.tween(animationSpeed, {
        [self] = {printNameX = VIRTUAL_WIDTH}
        }):ease(Easing.inExpo):finish(function()
        gStateStack:pop()
        music2:play()
        end)--self.allowInput = true end)
      end)
    
    end
    
    self.opacityFunction1 = function()
      Timer.tween(animationSpeed, {
        [self] = {printNumberX = 0}
        }):ease(Easing.outExpo):finish(self.opacityFunction2)
      
      Timer.after(delay, function()
        Timer.tween(animationSpeed, {
        [self] = {printNameX = 0}
        }):ease(Easing.outExpo)
        end)
    end
    
    self.opacityFunction1()
    
    local slideSound = gSounds['slide']
    slideSound:setVolume(0.5)
    local slideStopTime = 0.54
    local slideDelay = 1.6
    slideSound:play()
    Timer.after(slideStopTime, function() slideSound:stop() end)
    Timer.after(slideDelay, function()
        slideSound:play()
        Timer.after(slideStopTime, function() slideSound:stop() end)
        end)
    
end



function InLevelState:update(dt)

  
  if transitions and not self.allowInput then
    self.blackTimer = self.blackTimer + dt
    if self.blackTimer >= self.blackTimerMax then
      self.blackTimer = self.blackTimerMax
      --self.allowInput = true
    end
    self.blackOpacity = 1 - (self.blackTimer / self.blackTimerMax)
  end
  
  if not self.allowInput then
    return
  end

  
end



function InLevelState:render()
  

  
  
  love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
  --love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
  
  local shadowOffset = 10
  love.graphics.setFont(gFonts['movinglarge'])
  
  love.graphics.setColor(0,0,0,0.8)
  local text = 'Level '..self.level
  if self.level == 10 then
    text = 'Final Level'
  end
  love.graphics.printf(text, self.printNumberX - shadowOffset, 300 + shadowOffset, self.printNumberX + VIRTUAL_WIDTH - shadowOffset, 'center')
  love.graphics.printf(levelNames[self.level], self.printNameX - shadowOffset, 600 + shadowOffset, self.printNameX + VIRTUAL_WIDTH - shadowOffset, 'center')
  
  love.graphics.setColor(colors.white)
  love.graphics.printf(text, self.printNumberX, 300, self.printNumberX + VIRTUAL_WIDTH, 'center')
  love.graphics.printf(levelNames[self.level], self.printNameX, 600, self.printNameX + VIRTUAL_WIDTH, 'center')

  
  love.graphics.setColor(0, 0, 0, self.blackOpacity)
  love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

end


