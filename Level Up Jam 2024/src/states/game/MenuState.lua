MenuState = Class{__includes = BaseState}

function MenuState:init()
  self.type = 'Menu'
  
  gSounds['chronomusic']:play()
  
  self.background = {0.2, 0.6, 0.2}
  
  self.signColorFront = {0.55, 0.35, 0.05}
  self.signColorBack = {0.3, 0.25, 0.15}
  
  self.colorFont = colors.white --self.signColorBack
  self.colorText1 = {1,0,0,0}
  self.colorText2 = {0,1,0,0}
  
  self.sliderX = VIRTUAL_WIDTH / 4
  self.sliderY = 760
  self.sliderWidth = VIRTUAL_WIDTH - 2*self.sliderX
  
  self.slider = Slider{
      x = self.sliderX,
      y = self.sliderY,
      width = self.sliderWidth,
      height = 100, 
      backgroundScale = 0.4,
      buttonScale = 0.8,
      buttonWidthScale = 0.12,
      colorButton = self.colorFont,
      colorBackground = self.colorFont,
    }
    self.mainText = '5-MIN CIV'
    self.textLeft = 'EXIT'
    self.textRight = 'PLAY'
    self.textWidth = 200
    
    
    self.signX = 100
    self.signY = 100
    self.signWidth = VIRTUAL_WIDTH - 2*self.signX
    self.signHeight = 600
    self.signOffset = 50
    self.signStickX = 800
    self.signStickWidth = VIRTUAL_WIDTH - 2*self.signStickX
    
    
    local nGrass = 50
    self.grass = {}
    for i = 1, nGrass do
      local x = math.random(0, VIRTUAL_WIDTH - 50)
      local y = math.random(0, VIRTUAL_HEIGHT - 50)
      local scale = 3
      table.insert(self.grass, {x = x, y = y, scale = scale})
    end
    
    
    self.iconScale = 16
    self.icons = {}

    table.insert(self.icons, {x = 400, y = 450, number = 2,})
    table.insert(self.icons, {x = 700, y = 450, number = 1,})
    table.insert(self.icons, {x = 1000, y = 450, number = 3,})
    table.insert(self.icons, {x = 1300, y = 450, number = 4,})

    
    
    
end


function MenuState:update(dt)
  
  local slider = self.slider
  
  local x, y = push:toGame(love.mouse.getPosition())
  
  if slider.active and (slider.dragging or (slider:mouseIsOverButton(x,y) and (not self.dragging))) then
    slider.buttonShadow = true
    if love.mouse.wasPressed(1) then
      self.dragging = true
      slider.dragging = true
      slider.offsetDrag = x - slider.buttonX
      gSounds['pick']:play()
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
    gStateStack:clear()
    gStateStack:push(InstructionsState())
    gSounds['ok']:play()
    gSounds['chronomusic']:stop()
  elseif slider.value < 5 then
    love.event.quit()
    gSounds['out']:play()
  end
  
end



function MenuState:render()
  
  love.graphics.setColor(self.background)
  love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
  
  
  
  love.graphics.setColor(colors.white)
  for _, grass in pairs(self.grass) do
    love.graphics.draw(gTextures['icons'], gFrames['icons'][30], grass.x, grass.y, 0, grass.scale, grass.scale)
  end
  
  for _, icon in pairs(self.icons) do
    love.graphics.draw(gTextures['icons'], gFrames['icons'][icon.number], icon.x, icon.y, 0, self.iconScale, self.iconScale)
  end
  
  
  --[[
  love.graphics.setColor(self.signColorBack)
  love.graphics.rectangle('fill', self.signStickX, self.signY, self.signStickWidth, VIRTUAL_HEIGHT)
  love.graphics.setColor(self.signColorFront)
  love.graphics.rectangle('fill', self.signStickX + self.signOffset, self.signY + self.signOffset, self.signStickWidth - 2*self.signOffset, VIRTUAL_HEIGHT)
  
  love.graphics.setColor(self.signColorBack)
  love.graphics.rectangle('fill', self.signX, self.signY, self.signWidth, self.signHeight)
  love.graphics.setColor(self.signColorFront)
  love.graphics.rectangle('fill', self.signX + self.signOffset, self.signY + self.signOffset, self.signWidth - 2*self.signOffset, self.signHeight - 2*self.signOffset)
  ]]
  local offset1 = 10
  local offset2 = 5
  
  love.graphics.setFont(gFonts['title'])
  love.graphics.setColor(colors.black)
  love.graphics.printf(self.mainText, offset1, 200 - offset1, VIRTUAL_WIDTH + offset1, 'center')
  love.graphics.setColor(self.colorFont)
  love.graphics.printf(self.mainText, 0, 200, VIRTUAL_WIDTH, 'center')
  love.graphics.setFont(gFonts['medium'])
  love.graphics.setColor(colors.black)
  love.graphics.printf(self.textLeft, self.sliderX - self.textWidth + offset2, self.sliderY + 20 - offset2, self.textWidth + offset2, 'center')
  love.graphics.printf(self.textRight, self.sliderX + self.sliderWidth + offset2, self.sliderY + 20 - offset2, self.textWidth + offset2, 'center')
  love.graphics.setColor(self.colorFont)
  love.graphics.printf(self.textLeft, self.sliderX - self.textWidth, self.sliderY + 20, self.textWidth, 'center')
  love.graphics.printf(self.textRight, self.sliderX + self.sliderWidth, self.sliderY + 20, self.textWidth, 'center')
  love.graphics.setColor(self.colorText1)
  love.graphics.printf(self.textLeft, self.sliderX - self.textWidth, self.sliderY + 20, self.textWidth, 'center')
  love.graphics.setColor(self.colorText2)
  love.graphics.printf(self.textRight, self.sliderX + self.sliderWidth, self.sliderY + 20, self.textWidth, 'center')
  
  self.slider:render()
  
end
