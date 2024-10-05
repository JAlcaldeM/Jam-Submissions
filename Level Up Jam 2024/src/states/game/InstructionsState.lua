InstructionsState = Class{__includes = BaseState}

function InstructionsState:init()
  self.type = 'Instructions'
  
  self.background = colors.black
  
  self.colorFont = colors.white
  self.colorText1 = {1,0,0,0}
  self.colorText2 = {0,1,0,0}

  
  self.sliderX = VIRTUAL_WIDTH / 4
  self.sliderY = 960
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
    self.mainText = 'INSTRUCTIONS'
    self.textLeft = 'BACK'
    self.textRight = 'START!'
    self.textWidth = 200
    
    self.subText = 'lorem Ipsum '
    
    self.icons = {}
    local iconScale = 10
    local offsetX = 84
    local offsetY = 24
    
    local icon1Y = 360
    local icon1b = Icon{x = 100 + offsetX, y = icon1Y - offsetY, scale = iconScale, iconNumber = 2}
    table.insert(self.icons, icon1b)
    local icon1 = Icon{x = 100, y = icon1Y, scale = iconScale, iconNumber = 7}
    table.insert(self.icons, icon1)
    
    
    local icon2Y = 490
    local icon2b = Icon{x = 100 + offsetX, y = icon2Y - offsetY, scale = iconScale, iconNumber = 1}
    table.insert(self.icons, icon2b)
    local icon2 = Icon{x = 100, y = icon2Y, scale = iconScale, iconNumber = 6}
    table.insert(self.icons, icon2)
    

    local icon3Y = 620
    local icon3b = Icon{x = 100 + offsetX, y = icon3Y - offsetY, scale = iconScale, iconNumber = 27}
    table.insert(self.icons, icon3b)
    local icon3 = Icon{x = 100, y = icon3Y, scale = iconScale, iconNumber = 11}
    table.insert(self.icons, icon3)
    
    local icon4Y = 750
    local icon4b = Icon{x = 100 + offsetX, y = icon4Y - offsetY, scale = iconScale, iconNumber = 5}
    table.insert(self.icons, icon4b)
    local icon4 = Icon{x = 100, y = icon4Y, scale = iconScale, iconNumber = 14}
    table.insert(self.icons, icon4)
    
    
    self.centerTexts = {}
    self.leftTexts = {}
    
    local mainInstruction = {y = 150, text = 'Your objective is to last 5 minutes against the attackers. Your workers operate independently. Use the sliders to adjust job priorities.'}
    local lastTip = {y = 880, text = 'More jobs are unlocked after upgrading the town hall!'}
    table.insert(self.centerTexts, mainInstruction)
    table.insert(self.centerTexts, lastTip)
    
    local leftText1 = {y = icon1Y, text = "Farmers' wheat feeds new workers"}
    local leftText2 = {y = icon2Y, text = "Lumberjacks collect wood for buildings"}
    local leftText3 = {y = icon3Y, text = "Soldiers fight enemy attackers"}
    local leftText4 = {y = icon4Y, text = "Builders upgrade and build constructions"}
    table.insert(self.leftTexts, leftText1)
    table.insert(self.leftTexts, leftText2)
    table.insert(self.leftTexts, leftText3)
    table.insert(self.leftTexts, leftText4)
    
    self.moveDistance = 3
    local leftText5 = {y = icon1Y + self.moveDistance, text = "Farmers", color = colors.gold, move = true}
    local leftText6 = {y = icon2Y + self.moveDistance, text = "Lumberjacks", color = colors.brown, move = true}
    local leftText7 = {y = icon3Y + self.moveDistance, text = "Soldiers", color = colors.red, move = true}
    local leftText8 = {y = icon4Y + self.moveDistance, text = "Builders", color = colors.green, move = true}
    table.insert(self.leftTexts, leftText5)
    table.insert(self.leftTexts, leftText6)
    table.insert(self.leftTexts, leftText7)
    table.insert(self.leftTexts, leftText8)
    
    
    
    
end


function InstructionsState:update(dt)
  
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
    gStateStack:push(PlayState())
    gSounds['ok']:play()
  elseif slider.value < 5 then
    gStateStack:clear()
    gStateStack:push(MenuState())
    gSounds['out']:play()
  end
  
  
  
  
end



function InstructionsState:render()
  
  love.graphics.setColor(self.background)
  love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
  
  
  love.graphics.setColor(self.colorFont)
  love.graphics.setFont(gFonts['mediumLarge'])
  love.graphics.printf(self.mainText, 0, 30, VIRTUAL_WIDTH, 'center')
  
  love.graphics.setFont(gFonts['medium'])
  --love.graphics.printf(self.subText, 0, 300, VIRTUAL_WIDTH, 'center')
  for _, text in ipairs(self.centerTexts) do
    love.graphics.printf(text.text, 0, text.y, VIRTUAL_WIDTH, 'center')
  end
  
  
  for _, text in ipairs(self.leftTexts) do
    if text.color then
      love.graphics.setColor(text.color)
    end
    local x = 340
    if text.move then
      x = x - self.moveDistance
    end
    love.graphics.print(text.text, x, text.y + 20)
  end
  
  love.graphics.setColor(self.colorFont)
  love.graphics.setFont(gFonts['medium'])
  love.graphics.printf(self.textLeft, self.sliderX - self.textWidth, self.sliderY + 20, self.textWidth, 'center')
  love.graphics.printf(self.textRight, self.sliderX + self.sliderWidth, self.sliderY + 20, self.textWidth, 'center')
  love.graphics.setColor(self.colorText1)
  love.graphics.printf(self.textLeft, self.sliderX - self.textWidth, self.sliderY + 20, self.textWidth, 'center')
  love.graphics.setColor(self.colorText2)
  love.graphics.printf(self.textRight, self.sliderX + self.sliderWidth, self.sliderY + 20, self.textWidth, 'center')
  
  self.slider:render()
  
  for _, icon in ipairs(self.icons) do
    icon:render()
  end
  
end