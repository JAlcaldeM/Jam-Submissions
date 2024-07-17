PauseState = Class{__includes = BaseState}

function PauseState:init()
  self.type = 'Menu'
  
  gSounds['pause']:play()
  
  self.background = {0,0,0,0.5}
  
  self.colorFont = colors.white
  self.colorText1 = {0,1,0,0}
  self.colorText2 = {1,0,0,0}

  
  self.sliderX = VIRTUAL_WIDTH / 4
  self.sliderY = VIRTUAL_HEIGHT / 2
  self.sliderWidth = VIRTUAL_WIDTH - 2*self.sliderX
  
  self.slider = Slider{
      x = self.sliderX,
      y = self.sliderY,
      width = self.sliderWidth,
      height = 100, 
      backgroundScale = 0.4,
      buttonScale = 0.8,
      buttonWidthScale = 0.12,
    }
    self.mainText = 'PAUSE'
    self.textLeft = 'RESUME PLAY'
    self.textRight = 'EXIT GAME'
    self.textWidth = 250
end


function PauseState:update(dt)
  
  local slider = self.slider
  
  local x, y = push:toGame(love.mouse.getPosition())
  
  if slider.active and (slider.dragging or (slider:mouseIsOverButton(x,y) and (not self.dragging))) then
    slider.buttonShadow = true
    if love.mouse.wasPressed(1) then
      gSounds['pick']:play()
      self.dragging = true
      slider.dragging = true
      slider.offsetDrag = x - slider.buttonX
    end
  else
    slider.buttonShadow = false
  end
  if slider.dragging then
    slider.buttonX = clamp(x - slider.offsetDrag, slider.x, slider.x + slider.backgroundWidth)
    slider.value = math.floor(slider.scale * (slider.buttonX - slider.x) / slider.backgroundWidth)
  end
  if love.mouse.wasReleased(1) then
    if self.dragging then
      gSounds['release']:play()
    end
    self.dragging = false
    slider.dragging = false
    
  end
  
  local alphaText1, alphaText2
  if slider.value < 50 then
    alphaText1 = (50 - slider.value)/50
    alphaText2 = 0
  else
    alphaText1 = 0
    alphaText2 = (slider.value - 50)/50
  end
  
  self.colorText1[4] = alphaText1
  self.colorText2[4] = alphaText2
  
  
  if slider.value > 95 then
    love.event.quit()
    gSounds['ok']:play()
  elseif slider.value < 5 then
    gStateStack:pop()
    gSounds['unpause']:play()
    gSounds['mysterymusic']:play()
  end
  
  if love.mouse.wasPressed(2) or love.keyboard.wasPressed('escape') or love.keyboard.wasPressed('space') then
    gStateStack:pop()
    gSounds['unpause']:play()
    gSounds['mysterymusic']:play()
  end
  
end



function PauseState:render()
  
  love.graphics.setColor(self.background)
  love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
  
  
  love.graphics.setColor(self.colorFont)
  love.graphics.setFont(gFonts['large'])
  love.graphics.printf(self.mainText, 0, 200, VIRTUAL_WIDTH, 'center')
  
  love.graphics.setColor(self.colorFont)
  love.graphics.setFont(gFonts['medium'])
  love.graphics.printf(self.textLeft, self.sliderX - self.textWidth, self.sliderY, self.textWidth, 'center')
  love.graphics.printf(self.textRight, self.sliderX + self.sliderWidth, self.sliderY, self.textWidth, 'center')
  love.graphics.setColor(self.colorText1)
  love.graphics.printf(self.textLeft, self.sliderX - self.textWidth, self.sliderY, self.textWidth, 'center')
  love.graphics.setColor(self.colorText2)
  love.graphics.printf(self.textRight, self.sliderX + self.sliderWidth, self.sliderY, self.textWidth, 'center')
  
  self.slider:render()
  
end