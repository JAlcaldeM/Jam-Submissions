ScoreState = Class{__includes = BaseState}

function ScoreState:init(def)
  self.type = 'Score'
  
  self.items = def.items or {{}}
  
  self.money = def.money or 5555
  
  
  self.itemScore = 0
  for i, itemCol in ipairs(self.items) do
    for j, item in ipairs(itemCol) do
      self.itemScore = self.itemScore + item.value
    end
  end
  
  self.moneyScore = self.money
  self.totalScore = self.itemScore + self.moneyScore
  --[[
  if self.totalScore > highscore then

    local file = love.filesystem.newFile("src/highscore.txt", "w")
    file:write(tostring(self.totalScore))
    file:close()

    print('hi')
    love.filesystem.remove("src/highscore.txt")
    love.filesystem.write("src/highscore.txt", tostring(self.totalScore))
  end
  ]]
  
  self.buttons = {}
  
  self.closeButton = Button{
    x = 57,
    y = 2,
    size = 5,
    iconNumber = 4,
    active = false,
    onClick = function() 
      -- go to main menu and reset days, money...
      gSounds['ok']:stop()
      gSounds['ok']:play()
      gStateStack:clear()
      gStateStack:push(MainMenuState{})
      
      end
  }
  table.insert(self.buttons, self.closeButton)
  

  self.step = 0

  self.stepTimer = 0
  self.stepTimerMax = 0.5

  
  
end


function ScoreState:update(dt)


  local x, y = push:toGame(love.mouse.getPosition())
  
  
  
  
  for _, button in pairs(self.buttons) do
    if button.active and button:mouseIsOver(x, y) then
      button:onHover()
      if love.mouse.wasPressed(1) then
        button:onClick()
      end
    else
      button:notOnHover()
    end
  end
  
  self.stepTimer = self.stepTimer + dt
  if self.stepTimer >= self.stepTimerMax then
    if self.step <= 5 then
      gSounds['pow']:stop()
      gSounds['pow']:play()
    end
    
    
    self.stepTimer = 0
    self.step = self.step + 1
    if self.step >= 10 then

      self.closeButton.active = true
    end
  end
  
  
  
  
end



function ScoreState:render()
  
  --[[
  love.graphics.setColor(0.5, 0.5, 0.5, 0.8)
  love.graphics.rectangle('fill', 0, 0, 64, 64)
  ]]
  
  love.graphics.setColor(colors.white)
  --love.graphics.setColor(0.5,0.5,0.5,0.5)
  
  love.graphics.draw(gTextures['score'], 0, 0)
  
  if self.step >= 1 then
    love.graphics.draw(gTextures['icons'], gFrames['icons'][4], 5, 8)
  end
  
  if self.step >= 3 then
    love.graphics.draw(gTextures['icons'], gFrames['icons'][5], 5, 23)
  end
  
  
  

  

  for _, button in pairs(self.buttons) do
    if button.active then
      button:render()
    end
  end
  

  love.graphics.setColor(colors.black)
  
  love.graphics.setFont(gFonts['16'])
  if self.step >= 6 then
    love.graphics.printf(self.totalScore, 0, 48, 64, 'center')
  end
  
  
  love.graphics.setFont(gFonts['8'])
  
  if self.step >= 5 then
    love.graphics.printf('Total Score', 0, 40, 64, 'center')
    love.graphics.setLineWidth(1)
    love.graphics.setLineStyle('rough')
    love.graphics.line(8, 47.5, 55, 47.5)
  end
  
  if self.step >= 2 then
    love.graphics.print(self.moneyScore, 19, 9)
  end
  
  if self.step >= 4 then
    love.graphics.print(self.itemScore, 19, 24)
  end
  
  
  


  
end


