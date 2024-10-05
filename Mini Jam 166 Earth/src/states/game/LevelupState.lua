LevelupState = Class{__includes = BaseState}

function LevelupState:init(def)
  self.type = 'Levelup'
  
  self.player = def.player or Player{}
  
  self.upgrades = {}
  self.levels = {}
  self.upgradeDescriptions = {}
  self:selectUpgrades()
  self.position = 2
  
  gSounds['levelup']:play()

end





function LevelupState:update(dt)
  
  if love.keyboard.wasPressed('left') or love.keyboard.wasPressed('a') then
    self.position = math.max(1, self.position - 1)
    gSounds['changeselection']:stop()
    gSounds['changeselection']:play()
  elseif love.keyboard.wasPressed('right') or love.keyboard.wasPressed('d') then
    self.position = math.min(3, self.position + 1)
    gSounds['changeselection']:stop()
    gSounds['changeselection']:play()
  end
  
  if love.keyboard.wasPressed('w') or love.keyboard.wasPressed('space') or love.keyboard.wasPressed('up') or love.keyboard.wasPressed('return') then
    local upgrade = self.upgrades[self.position]
    self.player.levels[upgrade] = self.player.levels[upgrade] + 1
    gStateStack:pop()
    
    gSounds['ok']:play()
    gSounds['battle']:seek(battlePosition)
    gSounds['battle']:play()
  end
  
  
  
end



function LevelupState:render()
  
  --love.graphics.setColor(colors.white)
  --love.graphics.draw(gTextures['levelup'])
  
  --mockup for full exp bar
  love.graphics.setColor(palette[3])
  love.graphics.rectangle('fill', 4.5*tilesize + 1, VIRTUAL_HEIGHT - tilesize + 2, 2.5*tilesize-2, tilesize - 4)
  
  
  
  love.graphics.setFont(gFonts['big'])
  love.graphics.setColor(palette[3])
  love.graphics.printf('PICK AN UPGRADE', 4, 6,  VIRTUAL_WIDTH - 10, 'center')
  love.graphics.setColor(palette[2])
  love.graphics.printf('PICK AN UPGRADE', 5, 5,  VIRTUAL_WIDTH - 10, 'center')
  
  love.graphics.setColor(palette[2])
  local selectWidth = 2
  love.graphics.rectangle('fill', tilesize + 3*tilesize*(self.position - 1) - selectWidth, 3*tilesize - selectWidth + 8, 2*tilesize + 2*selectWidth, 2*tilesize + 2*selectWidth)
  
  love.graphics.setFont(gFonts['medium'])
  local textY = 6*tilesize
  local textOffset = 1
  
  love.graphics.setColor(palette[3])
  love.graphics.printf(self.upgradeDescriptions[self.position], 5 - textOffset, textY + textOffset,  VIRTUAL_WIDTH - 10, 'center')
  love.graphics.setColor(palette[2])
  love.graphics.printf(self.upgradeDescriptions[self.position], 5, textY,  VIRTUAL_WIDTH - 10, 'center')
  
  love.graphics.setColor(colors.white)
  for i = 1, 3 do
    
    local upgradeNumber = self.upgradesSelected[i]
    local levelNumber = self.levels[i] + 1
    love.graphics.draw(gTextures['icons'], gFrames['icons'][upgradeNumber],  tilesize + 3*tilesize*(i - 1), 3*tilesize + 8, 0, 2, 2)
    love.graphics.draw(gTextures['smallicons'], gFrames['smallicons'][levelNumber],  3*tilesize - 10 + 3*tilesize*(i - 1) , 5*tilesize - 10 + 8)
  end
  
  
  
  
  
  --[[
  -- background
  
  
  
  -- ground (ui)
  love.graphics.setColor(palette[2])
  love.graphics.rectangle('fill',0,VIRTUAL_HEIGHT - tilesize,VIRTUAL_WIDTH, tilesize)
  ]]
  
end

function LevelupState:selectUpgrades()
  
  --local upgradesSelected = {4,5,6} -- replace eventually with random numbers
  
  
  local upgradesSelected = {}
  
  local nUpgrades = #upgradeList
  local orderedArray = {}
  
  for i = 1, nUpgrades do
    local upgradeName = upgradeList[i]
    if self.player.levels[upgradeName] < maxLevel then
      table.insert(orderedArray, i)
    end
  end
  local randomArray = shuffleArray(orderedArray)
  
  for i = 1, 3 do
    table.insert(upgradesSelected, randomArray[i])
  end
  
  
  
  self.upgradesSelected = upgradesSelected
  
  for _, upgradeNumber in ipairs(upgradesSelected) do
    table.insert(self.upgrades, upgradeList[upgradeNumber])
  end
  
  for _, upgrade in ipairs(self.upgrades)  do
    table.insert(self.upgradeDescriptions, upgradeDescriptions[upgrade])
    table.insert(self.levels, self.player.levels[upgrade])
  end
  
end



