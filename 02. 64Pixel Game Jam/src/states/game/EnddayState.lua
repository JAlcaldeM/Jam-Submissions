EnddayState = Class{__includes = BaseState}

function EnddayState:init(def)
  self.type = 'Endday'
  
  self.items = def.items or {}
  day = day or 9
  spent = spent or 999
  earnt = earnt or 999
  
  self.money = def.money or 5555
  
  
  self.buttons = {}
  
  local storageButton = Button{
    x = 8,
    y = 41,
    size = 20,
    onClick = function() 
      gSounds['ok']:stop()
      gSounds['ok']:play()
      self:nextDay()
      gStateStack:clear()
      gStateStack:push(StorageState({items = self.items, money = self.money, source = 'endday',}))
      
      end
  }
  table.insert(self.buttons, storageButton)
  
  
  local storeButton = Button{
    x = 36,
    y = 41,
    size = 20,
    onClick = function()
      gSounds['ok']:stop()
      gSounds['ok']:play()
      self:nextDay()
      gStateStack:clear()
      if day <= 2 then
        gStateStack:push(StoreState({items = self.items, money = self.money}))
      else
        gStateStack:push(ScoreState({items = self.items, money = self.money}))
      end
    end
  }
  table.insert(self.buttons, storeButton)
  

  

  
  
end


function EnddayState:update(dt)


  local x, y = push:toGame(love.mouse.getPosition())
  
  
  
  
  for _, button in pairs(self.buttons) do
    if button:mouseIsOver(x, y) then
      button:onHover()
      if love.mouse.wasPressed(1) then
        button:onClick()
      end
    else
      button:notOnHover()
    end
  end
  

  
  
end



function EnddayState:render()
  
  love.graphics.setColor(0.5, 0.5, 0.5, 0.8)
  love.graphics.rectangle('fill', 0, 0, 64, 64)
  
  love.graphics.setColor(colors.white)
  love.graphics.draw(gTextures['endday'], 0, 0)
  

  for _, button in pairs(self.buttons) do
    button:render()
  end
  
  love.graphics.setColor(colors.black)
  love.graphics.setFont(gFonts['16'])
  love.graphics.print(day, 43, 2)
  love.graphics.setFont(gFonts['8'])
  love.graphics.print(spent, 39, 19)
  love.graphics.print(earnt, 37, 32)

  
end

function EnddayState:nextDay()
  day = day + 1
  spent = 0
  earnt = 0
end




