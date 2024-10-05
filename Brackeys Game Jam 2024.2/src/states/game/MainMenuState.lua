MainMenuState = Class{__includes = BaseState}

function MainMenuState:init(def)
  self.type = 'MainMenu'
  
  self.gameName = 'Zen Fish'
  self.option1 = 'Play'
  self.option2 = 'Close game'
  
  self.selectedOption = nil
  
  self.largeFont = gFonts['mainTitle']
  self.mediumFont = gFonts['mainMedium']
  
  self.highlightColor = {1, 1, 0}
  self.normalColor = {1, 1, 1}
  
  
  self.parallaxFactor = 4
  self.areaSize = 5000
  self.background = gTextures['ocean3blur']
  self.backgroundWidth = self.background:getWidth()
  self.backgroundHeight = self.background:getHeight()
  self.backgroundScale = self.areaSize / self.backgroundWidth
  
  local mouseX, mouseY = push:toGame(love.mouse.getPosition())
  self.mouseX = mouseX
  self.mouseY = mouseY 
  
  self.textOffset = 150
  
  self.blackAlpha = 1
  self.blackTimer = 0
  
  self.input = true
end

function MainMenuState:update(dt)
  
  if not self.input then
    self.blackTimer = self.blackTimer + dt
    self.blackAlpha = math.max(0, self.blackTimer/transitionTime)
    return
  end
  
  
  
  if self.blackTimer < transitionTime then
    self.blackTimer = self.blackTimer + dt
    self.blackAlpha = math.max(0, 1 - self.blackTimer/transitionTime)
  end
  
  
  --[[
  local mouseX, mouseY = push:toGame(love.mouse.getPosition())
  self.mouseX = mouseX
  self.mouseY = mouseY
  ]]
  
  local mouseX, mouseY = x, y
  
  self.mouseX = mouseX
  self.mouseY = mouseY
  
  local option1Width = self.mediumFont:getWidth(self.option1)
  local option1Height = self.mediumFont:getHeight()
  local option1X = (VIRTUAL_WIDTH - option1Width) / 2
  local option1Y = VIRTUAL_HEIGHT / 2 + self.textOffset
  
  local option2Width = self.mediumFont:getWidth(self.option2)
  local option2Height = self.mediumFont:getHeight()
  local option2X = (VIRTUAL_WIDTH - option2Width) / 2
  local option2Y = VIRTUAL_HEIGHT / 2 + option1Height + 10 + self.textOffset
  
  if mouseX > option1X and mouseX < option1X + option1Width and mouseY > option1Y and mouseY < option1Y + option1Height then
    self.selectedOption = 'Play'
    if love.mouse.wasPressed(1) then
      gSounds['ok']:stop()
      gSounds['ok']:play()
      self.input = false
      self.blackTimer = 0
      Timer.after(transitionTime, function()
          gStateStack:clear()
          gStateStack:push(PlayState({}))
        end
        )
      
    end
  elseif mouseX > option2X and mouseX < option2X + option2Width and mouseY > option2Y and mouseY < option2Y + option2Height then
    self.selectedOption = 'Close game'
    if love.mouse.wasPressed(1) then
      love.event.quit()
    end
  else
    self.selectedOption = nil
  end
end

function MainMenuState:render()
  --love.graphics.clear(0.1, 0.1, 0.1)
  
  love.graphics.setColor(colors.white)
  local scale = self.backgroundScale
  local pFactor = self.parallaxFactor
  local backgroundX = (-self.backgroundWidth + self.mouseX/pFactor) / scale
  local backgroundY = (-self.backgroundHeight + self.mouseY/pFactor) / scale
  love.graphics.draw(self.background, backgroundX, backgroundY, 0, scale, scale)

  love.graphics.setFont(self.largeFont)
  local mainTextWidth = self.largeFont:getWidth(self.gameName)
  love.graphics.setColor(self.normalColor)
  love.graphics.print(self.gameName, (VIRTUAL_WIDTH - mainTextWidth) / 2, VIRTUAL_HEIGHT / 3)

  love.graphics.setFont(self.mediumFont)
  local option1Width = self.mediumFont:getWidth(self.option1)
  local option1Height = self.mediumFont:getHeight()
  local option1X = (VIRTUAL_WIDTH - option1Width) / 2
  local option1Y = VIRTUAL_HEIGHT / 2 + self.textOffset
  
  if self.selectedOption == 'Play' then
    love.graphics.setColor(self.highlightColor)
  else
    love.graphics.setColor(self.normalColor)
  end
  love.graphics.print(self.option1, option1X, option1Y)
  
  local option2Width = self.mediumFont:getWidth(self.option2)
  local option2Height = self.mediumFont:getHeight()
  local option2X = (VIRTUAL_WIDTH - option2Width) / 2
  local option2Y = VIRTUAL_HEIGHT / 2 + option1Height + 10 + self.textOffset
  
  if self.selectedOption == 'Close game' then
    love.graphics.setColor(self.highlightColor)
  else
    love.graphics.setColor(self.normalColor)
  end
  love.graphics.print(self.option2, option2X, option2Y)
  
  if self.blackAlpha > 0 then
    love.graphics.setColor({0,0,0,self.blackAlpha})
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
  end
  
end

