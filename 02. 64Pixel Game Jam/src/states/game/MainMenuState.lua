MainMenuState = Class{__includes = BaseState}

function MainMenuState:init(def)
  self.type = 'MainMenu'
  
  gSounds['purpledream']:play()
  
  self:reset()
  self.buttons = {}
  

  --local file = love.filesystem.read("src/highscore.txt")
  --highscore = tonumber(file) or 0
  --self.highscore = 'COMING SOON'--highscore

  
  
  local playButton = Button{
    x = 42,
    y = 45,
    width = 20,
    height = 7,
    onClick = function()
      gSounds['purpledream']:stop()
      gSounds['ok']:stop()
      gSounds['ok']:play()
      if self.job == 1 then
        job = 'owner'
      else
        job = normalCharacterList[self.job - 1]
      end
      skin = self.skin
      gStateStack:pop()
      gStateStack:push(StoreState({}))
      end
  }
  table.insert(self.buttons, playButton)
  
  local plusButton = Button{
    x = 35,
    y = 43,
    size = 5,
    onClick = function()
      gSounds['tip']:stop()
      gSounds['tip']:play()
      self.cutIncrease = true
      cut = cut + 0.5
      end
  }
  table.insert(self.buttons, plusButton)
  
  local minusButton = Button{
    x = 35,
    y = 48,
    size = 5,
    onClick = function() 
      gSounds['tip']:stop()
      gSounds['tip']:play()
      self.cutDecrease = true
      end
  }
  table.insert(self.buttons, minusButton)
  
  local arrow1Button = Button{
    x = 12,
    y = 22,
    size = 8,
    onClick = function()
      gSounds['tip']:stop()
      gSounds['tip']:play()
      self.job = self.job - 1
      if self.job <= 0 then
        self.job = 10
      end
    end
  }
  table.insert(self.buttons, arrow1Button)
  
  local arrow2Button = Button{
    x = 44,
    y = 22,
    size = 8,
    onClick = function() 
      gSounds['tip']:stop()
      gSounds['tip']:play()
      self.job = self.job + 1
      if self.job >= 11 then
        self.job = 1
      end
    end
  }
  table.insert(self.buttons, arrow2Button)
  
  local arrow3Button = Button{
    x = 12,
    y = 32,
    size = 8,
    onClick = function() 
      gSounds['tip']:stop()
      gSounds['tip']:play()
      self.skin = self.skin - 1
      if self.skin <= 0 then
        self.skin = 10
      end
    end
  }
  table.insert(self.buttons, arrow3Button)
  
  local arrow4Button = Button{
    x = 44,
    y = 32,
    size = 8,
    onClick = function()
      gSounds['tip']:stop()
      gSounds['tip']:play()
      self.skin = self.skin + 1
      if self.skin >= 11 then
        self.skin = 1
      end
    end
  }
  table.insert(self.buttons, arrow4Button)
  
  self.skin = 1
  self.job = 1
  
  
  self.cutChangeRate = 10
  
  
  
  
  
  
  --self.jobs = {'owner','magician','soldier','ranger','wizard','paladin','priest','rogue','bard','barbarian'}
  
  
  
  --[[
  
  self.items = def.items or {}
  day = day or 9
  spent = spent or 999
  earnt = earnt or 999
  
  self.money = def.money or 5555
  
  
 
  local storageButton = Button{
    x = 8,
    y = 41,
    size = 20,
    onClick = function() 
      self:nextDay()
      gStateStack:clear()
      gStateStack:push(StorageState({items = self.items, money = self.money}))
      
      end
  }
  table.insert(self.buttons, storageButton)
  
  
  local storeButton = Button{
    x = 36,
    y = 41,
    size = 20,
    onClick = function()
      self:nextDay()
      gStateStack:clear()
      gStateStack:push(StoreState({items = self.items, money = self.money}))
      end
  }
  table.insert(self.buttons, storeButton)
  

  ]]

  
  
end


function MainMenuState:update(dt)
  
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

  if love.mouse.wasReleased(1) then
    self.cutIncrease = false
    self.cutDecrease = false
  end
  
  if self.cutIncrease then
    cut = math.min(99,cut + self.cutChangeRate*dt)
  elseif self.cutDecrease then
    cut = math.max(0,cut - self.cutChangeRate*dt)
  end

end



function MainMenuState:render()

  

  
  love.graphics.setColor(colors.white)
  love.graphics.draw(gTextures['mainmenu'], 0, 0)
  
  --22, 21
  love.graphics.draw(gTextures['characters'], gFrames['characters'][50 + self.skin], 22, 20, 0, 2, 2)
  love.graphics.draw(gTextures['characters'], gFrames['characters'][self.job], 22, 20, 0, 2, 2)

  for _, button in pairs(self.buttons) do
    button:render()
  end
  
  love.graphics.setColor(colors.black)
  love.graphics.printf(math.floor(cut)..'%', 0, 44, 20, 'right')
  --love.graphics.print(self.highscore, 34, 55)
  
    --[[
  
  love.graphics.setFont(gFonts['16'])
  
  love.graphics.setFont(gFonts['8'])
  love.graphics.print(spent, 39, 19)
  love.graphics.print(earnt, 37, 32)
  ]]
  
end

function MainMenuState:reset()
  currentSpecialCharacterList = specialCharacterList
  day = 1
  cut = 20
end

