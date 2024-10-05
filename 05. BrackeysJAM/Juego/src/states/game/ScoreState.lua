ScoreState = Class{__includes = BaseState}

function ScoreState:init(def)
  self.type = 'Score'
  
  self.score = def.score or 0
  self.percentage = (self.score / nPellets) * 100
  self.percentageText = string.format("%.2f%%", self.percentage)
  
  if self.percentage >= 100 then
     self.mainText = 'You beat the game!'
     self.adviceText = 'Thanks for playing!'
     self.sound = gSounds['applause']
  else
    self.mainText = 'Game Over'
    self.adviceText = 'Please try again!'
    self.sound = gSounds['fail']
  end
  self.sound:play()
  
  self.instructionsText = 'Click to go back to Main Menu'
  
  self.largeFont = gFonts['mainBig']
  self.mediumFont = gFonts['mainMedium']
  self.smallFont = gFonts['mainSmall']
  
  self.blackAlpha = 0
  self.blackTimer = 0
  
  self.input = true
  
end





function ScoreState:update(dt)
  
  if not self.input then
    self.blackTimer = self.blackTimer + dt
    self.blackAlpha = math.max(0, self.blackTimer/transitionTime)
    return
  end
  
  
  if love.mouse.wasPressed(1) then
    gSounds['ok']:play()
    self.input = false
    Timer.after(transitionTime, function()
        gStateStack:clear()
        gStateStack:push(MainMenuState({}))
      end
      )
    
  end
  
end





function ScoreState:render()
  
  --love.graphics.clear(0.1, 0.1, 0.1)

  love.graphics.setFont(self.largeFont)
  local mainTextWidth = self.largeFont:getWidth(self.mainText)
  love.graphics.setColor(colors.white)
  love.graphics.print(self.mainText, (VIRTUAL_WIDTH - mainTextWidth) / 2, VIRTUAL_HEIGHT / 3)

  love.graphics.setFont(self.mediumFont)
  local adviceTextWidth = self.mediumFont:getWidth(self.adviceText)
  love.graphics.setColor(colors.white)
  love.graphics.print(self.adviceText, (VIRTUAL_WIDTH - adviceTextWidth) / 2, VIRTUAL_HEIGHT / 2)

  love.graphics.setFont(self.smallFont)
  local instructionsTextWidth = self.smallFont:getWidth(self.instructionsText)
  love.graphics.setColor(colors.white)
  love.graphics.print(self.instructionsText, (VIRTUAL_WIDTH - instructionsTextWidth) / 2, VIRTUAL_HEIGHT * 2 / 3)
  
  if self.blackAlpha > 0 then
    love.graphics.setColor({0,0,0,self.blackAlpha})
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
  end
  
end


