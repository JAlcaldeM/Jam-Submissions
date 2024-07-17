PlayState = Class{__includes = BaseState}

function PlayState:init()
  self.type = 'Play'
  
  gSounds['mysterymusic']:play()
  
  self.offset = 10
  
  self.timerX = 0
  self.timerY = 0
  self.timerWidth = 0.25*VIRTUAL_WIDTH
  self.timerHeight = 0.1*VIRTUAL_HEIGHT
  self.timerBackground = colors.black --{0.2, 0.2, 0.2}
  
  self.sliderX = 0
  self.sliderY = self.timerY + self.timerHeight
  self.sliderWidth = self.timerWidth
  self.sliderHeight = VIRTUAL_HEIGHT - self.sliderY
  self.sliderBackground = colors.black --{0.2, 0.2, 0.6}
  
  self.resourceX = self.timerX + self.timerWidth
  self.resourceY = 0
  self.resourceWidth = VIRTUAL_WIDTH - self.resourceX
  self.resourceHeight = self.timerHeight
  self.resourceBackground = colors.black --{0.6, 0.2, 0.2}
  
  self.playX = self.resourceX
  self.playY = self.resourceY + self.resourceHeight
  self.playWidth = self.resourceWidth
  self.playHeight = VIRTUAL_HEIGHT - self.playY
  self.playBackground = {0.2, 0.6, 0.2}
  
  
  
  self.resourceLength = ((self.resourceWidth - self.offset) / #resourceList) - 100
  self.resources = {}
  self.resourceIcons = {}
  local resourceIconScale = 9
  for i, resource in ipairs(resourceList) do
    local x = self.resourceX + self.offset + self.resourceLength*(i-1)
    local y = self.resourceY + self.offset
    local icon = Icon{
      x = x,
      y = y,
      scale = resourceIconScale,
      iconNumber = resourceIcons[resource],
      }
    table.insert(self.resourceIcons, icon)
    self.resources[resource] = {x = x + 2*self.offset + resourceIconScale*10, y = y + 14, value = 5}
  end
  
  self.sliderLength = (self.sliderHeight - self.offset) / #workList
  self.sliders = {}
  self.workIcons = {}
  local workIconScale = 11
  for i, work in ipairs(workList) do
    local x = self.sliderX + self.offset
    local y = self.sliderY + self.offset + self.sliderLength*(i-1)
    local icon = Icon{
      x = x,
      y = y,
      scale = workIconScale,
      iconNumber = workIcons[work],
      active = false,
    }
    table.insert(self.workIcons, icon)
    
    local slider = Slider{
      x = x + workIconScale*10,
      y = y + self.offset,
      width = self.sliderWidth - self.offset - workIconScale*10,
      height = self.sliderLength - 2*self.offset, 
      backgroundScale = 0.4,
      buttonScale = 0.8,
      buttonWidthScale = 0.12,
      active = false,
    }
    slider.work = work
    table.insert(self.sliders, slider)
  end
  
  self.lockedIcon1 = Icon{
      x = 150,
      y = 600,
      scale = 20,
      iconNumber = 31,
      active = true,
    }
  table.insert(self.workIcons, self.lockedIcon1)
  
  self.lockedIcon2 = Icon{
      x = 150,
      y = 840,
      scale = 20,
      iconNumber = 31,
      active = true,
    }
  table.insert(self.workIcons, self.lockedIcon2)
  
  

  
 
  self.cellHeight = VIRTUAL_HEIGHT/7
  self.cellWidth = self.cellHeight
  
  self.xFirst = self.playX + self.playWidth/2 - self.cellWidth/2
  self.yFirst = self.playY + self.playHeight/2 - self.cellHeight/2
  
  self.cells = {}
  
  --self.startCell = {x = , y = }
  self.startCell = {x = self.xFirst, y = self.yFirst}
  table.insert(self.cells, self.startCell)
  self.startCell.building = 'townhall'
  self.tier = 1
  self.startCell.tier = self.tier
  
  
  self.tier1Cells = {
    {x = self.xFirst, y = self.yFirst - self.cellHeight},
    {x = self.xFirst, y = self.yFirst + self.cellHeight},
    {x = self.xFirst - self.cellWidth, y = self.yFirst - 0.5*self.cellHeight},
    {x = self.xFirst - self.cellWidth, y = self.yFirst + 0.5*self.cellHeight},
    {x = self.xFirst + self.cellWidth, y = self.yFirst - 0.5*self.cellHeight},
    {x = self.xFirst + self.cellWidth, y = self.yFirst + 0.5*self.cellHeight},
  }
  
  self.tier2Cells = {
    {x = self.xFirst, y = self.yFirst - 2*self.cellHeight},
    {x = self.xFirst, y = self.yFirst + 2*self.cellHeight},
    {x = self.xFirst - 2*self.cellWidth, y = self.yFirst - self.cellHeight},
    {x = self.xFirst - 2*self.cellWidth, y = self.yFirst},
    {x = self.xFirst - 2*self.cellWidth, y = self.yFirst + self.cellHeight},
    {x = self.xFirst - self.cellWidth, y = self.yFirst - 1.5*self.cellHeight},
    {x = self.xFirst - self.cellWidth, y = self.yFirst + 1.5*self.cellHeight},
    {x = self.xFirst + self.cellWidth, y = self.yFirst - 1.5*self.cellHeight},
    {x = self.xFirst + self.cellWidth, y = self.yFirst + 1.5*self.cellHeight},
    {x = self.xFirst + 2*self.cellWidth, y = self.yFirst - self.cellHeight},
    {x = self.xFirst + 2*self.cellWidth, y = self.yFirst},
    {x = self.xFirst + 2*self.cellWidth, y = self.yFirst + self.cellHeight},
  }
  
  self.tier3Cells = {
    {x = self.xFirst - 3*self.cellWidth, y = self.yFirst - 0.5*self.cellHeight},
    {x = self.xFirst - 3*self.cellWidth, y = self.yFirst + 0.5*self.cellHeight},
    {x = self.xFirst + 3*self.cellWidth, y = self.yFirst - 0.5*self.cellHeight},
    {x = self.xFirst + 3*self.cellWidth, y = self.yFirst + 0.5*self.cellHeight},
    {x = self.xFirst - 3*self.cellWidth, y = self.yFirst - 1.5*self.cellHeight},
    {x = self.xFirst - 3*self.cellWidth, y = self.yFirst + 1.5*self.cellHeight},
    {x = self.xFirst + 3*self.cellWidth, y = self.yFirst - 1.5*self.cellHeight},
    {x = self.xFirst + 3*self.cellWidth, y = self.yFirst + 1.5*self.cellHeight},
  }
  
  shuffleArray(self.tier1Cells)
  shuffleArray(self.tier2Cells)
  shuffleArray(self.tier3Cells)
  
  
  self.tier2Cells[1].building = 'forest'
  self.tier2Cells[2].building = 'quarry'
  self.tier2Cells[3].building = 'mine'
  --self.tier2Cells[4].building = 'farm'
  self.tier3Cells[1].building = 'forest'
  self.tier3Cells[2].building = 'quarry'
  self.tier3Cells[3].building = 'mine'
  --self.tier3Cells[4].building = 'farm'
  
  for i = 1, 3 do
    self.tier2Cells[i].tier = 1
    self.tier3Cells[i].tier = 1
  end
  
  
  
  for _, cell in ipairs(self.tier1Cells) do
    table.insert(self.cells, cell)
  end
  
  for _, cell in ipairs(self.tier2Cells) do
    table.insert(self.cells, cell)
  end
  
  for _, cell in ipairs(self.tier3Cells) do
    table.insert(self.cells, cell)
  end
  
  self.cells[2].building = 'farm'
  self.cells[2].tier = 1
  --[[
  self.cells[3].building = 'construction'
  self.cells[3].tier = 1
  ]]
  
  self.unitSize = 64
  
  self.positions = {}
  
  for _, cell in ipairs(self.cells) do
    cell.side = self.cellWidth
    cell.unitSize = self.unitSize
    cell.offset = (cell.side - 2*self.unitSize)/3
    if cell.building then
      assignWorkPositions(cell, self)
    end
  end
  
  createNewConstructionSite(self.cells, self)



  self.workers = {}
  local startingWorkers = 8
  local startingWorks = {'doctor', 'doctor', 'farmer', 'farmer', 'blacksmith', 'soldier', 'stonemason', 'builder'}
  for i = 1, startingWorkers do
    local worker = Worker{
      x = math.random(self.playX, self.playX + self.playWidth - self.unitSize),
      y = math.random(self.playY, self.playY + self.playHeight - self.unitSize),
      size = self.unitSize,
      work = startingWorks[i], 
      positions = self.positions,
      playState = self,
    }
    table.insert(self.workers, worker)
  end
  
  for _, worker in pairs(self.workers) do
    worker.behavior = 'roam'
    worker.lowLimitX = self.playX
    worker.highLimitX = self.playX + self.playWidth - self.unitSize
    worker.lowLimitY = self.playY
    worker.highLimitY = self.playY + self.playHeight - self.unitSize
  end
  
  
  activateSliders(self, self.tier)
  
  
  local nCosmetics = 20
  self.cosmetics = {}
  for i = 1, nCosmetics do
    local cosmeticType = cosmeticList[math.random(#cosmeticList)]
    local timeAnimation = 2 + math.random()
    local x = math.random(self.playX, self.playX + self.playWidth - self.unitSize)
    local y = math.random(self.playY, self.playY + self.playHeight - self.unitSize)
    local scale = 4
    local cosmetic = {x = x, y = y, scale = scale, type = cosmeticType, timeAnimation = timeAnimation, time = 0, currentFrame = 1, frames = cosmeticIcons[cosmeticType]}
    table.insert(self.cosmetics, cosmetic)
  end
  

    self.enemies = {}
    self.enemySpawnX = {self.playX, VIRTUAL_WIDTH}
    self.enemySpawnY = {self.playY, VIRTUAL_HEIGHT}
    self.enemySpawnCoordRandomizer = 100
    self.enemySpawnCurrentTime = 0
    self.enemySpawnTimeBase = 25
    self.enemySpawnTime = 25
    self.enemySpawnTimeRandomizer = 10
    self.enemyNumber = 1
    self.enemyNumberRandomizer = 2

  
  
 
  
  local nGrass = 50
  self.grass = {}
  for i = 1, nGrass do
    local x = math.random(self.playX, self.playX + self.playWidth - self.unitSize)
    local y = math.random(self.playY, self.playY + self.playHeight - self.unitSize)
    local scale = 3
    table.insert(self.grass, {x = x, y = y, scale = scale})
  end
  
  
  local mouseIcon = Icon{
      x = 1630,
      y = 18,
      scale = 8,
      iconNumber = 32,
      active = true,
    }
  table.insert(self.workIcons, mouseIcon)
  
  

  self.miscText = {}
  table.insert(self.miscText, {text = 'PAUSE:', x = 1526, y = 40,})
  table.insert(self.miscText, {text = '/ESC/SPACE', x = 1700, y = 40,})
  
  
  self.mainTimer = 300.99
  
end


function PlayState:update(dt)
  
  if self.mainTimer > 1 then
    self.mainTimer = self.mainTimer - dt
  else
    gStateStack:push(WinState())
  end
  
  
  local x, y = push:toGame(love.mouse.getPosition())
  for _, slider in pairs(self.sliders) do
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
  end
  
  if enemies then
    self.enemySpawnCurrentTime = self.enemySpawnCurrentTime + dt
    if self.enemySpawnCurrentTime >= self.enemySpawnTime then
      local enemiesSpawning = self.enemyNumber + math.random(self.enemyNumberRandomizer)
      --print(enemiesSpawning, 'enemies spawning')
      local baseX = self.enemySpawnX[math.random(#self.enemySpawnX)]
      local baseY = self.enemySpawnY[math.random(#self.enemySpawnY)]
      for i = 1, enemiesSpawning do
        local x = baseX + math.random(-self.enemySpawnCoordRandomizer, self.enemySpawnCoordRandomizer)
        local y = baseY + math.random(-self.enemySpawnCoordRandomizer, self.enemySpawnCoordRandomizer)
        local enemy = Enemy{
          x = x,
          y = y,
          size = self.unitSize,
          playstate = self,
        }
        table.insert(self.enemies, enemy)
      end
      
      self.enemySpawnCurrentTime = 0
      self.enemySpawnTime = self.enemySpawnTimeBase + math.random(self.enemySpawnTimeRandomizer)
      self.enemyNumber = self.enemyNumber + 1
    end
  end
  
  
  
  
  if self.dragging then
    distributeWorkers(self.workers, self.sliders)
  end
  
  for i, enemy in pairs(self.enemies) do
    enemy:update(dt)
  end
  
  
  for i, worker in pairs(self.workers) do
    worker:update(dt)
  end
  
  local nWorkers = 0
  for _, worker in pairs(self.workers) do
    if worker.isAlive then
      nWorkers = nWorkers + 1
    end
  end
  
  if self.resources.wheat.value >= nWorkers then
    self.resources.wheat.value = self.resources.wheat.value - math.ceil(nWorkers/2)
    local worker = Worker{
      x = self.playX + 0.5*self.playWidth - 0.5*self.unitSize,
      y = self.playY + 0.5*self.playHeight - 0.5*self.unitSize,
      size = self.unitSize,
      work = 'farmer', 
      positions = self.positions,
      playState = self,
    }
    table.insert(self.workers, worker)
    gSounds['pling']:play()
  end

  
  for _, cosmetic in pairs(self.cosmetics) do
    cosmetic.time = cosmetic.time + dt
    if cosmetic.time >= cosmetic.timeAnimation then
      if cosmetic.currentFrame == 1 then
        cosmetic.currentFrame = 2
      else
        cosmetic.currentFrame = 1
      end
      cosmetic.time = 0
    end
  end
  
  
  if love.mouse.wasPressed(2) or love.keyboard.wasPressed('escape') or love.keyboard.wasPressed('space') then
    gStateStack:push(PauseState())
    gSounds['mysterymusic']:pause()
  end
  
  --[[
  if love.keyboard.wasPressed('w') then
    gStateStack:push(WinState())
  end
  
  if love.keyboard.wasPressed('l') then
    gStateStack:push(LoseState())
  end
  
  if love.keyboard.wasPressed('t') then
    decideBuildingType(self)
  end
  ]]
  
  

end



function PlayState:render()
  
  love.graphics.setColor(self.playBackground)
  love.graphics.rectangle('fill', self.playX, self.playY, self.playWidth, self.playHeight)
  
  if cosmetics then
    love.graphics.setColor(colors.white)
    for _, cosmetic in pairs(self.cosmetics) do
      local iconNumber = cosmetic.frames[cosmetic.currentFrame]
      love.graphics.draw(gTextures['icons'], gFrames['icons'][iconNumber], cosmetic.x, cosmetic.y, 0, cosmetic.scale, cosmetic.scale)
    end
  end
  
  love.graphics.setColor(colors.white)
  for _, grass in pairs(self.grass) do
    love.graphics.draw(gTextures['icons'], gFrames['icons'][30], grass.x, grass.y, 0, grass.scale, grass.scale)
  end

  
  

  
  local buildingScale = 4.4
  for _, cell in ipairs(self.cells) do
    --love.graphics.setColor(colors.black)
    --love.graphics.rectangle('line', cell.x, cell.y, self.cellWidth, self.cellHeight)
    if cell.building then
      love.graphics.setColor(colors.white)
      local buildingNumber = buildingIcons[cell.building]
      love.graphics.draw(gTextures['buildings'], gFrames['buildings'][buildingNumber], cell.x, cell.y, 0, buildingScale, buildingScale)
      if cell.positions then
        for _, position in pairs(cell.positions) do
          if cell.building == 'construction' and position.constructed then
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(gTextures['icons'], gFrames['icons'][5], position.buildX, position.buildY, 0, (self.unitSize+15)/10, (self.unitSize+15)/10)
          end
          if position.icon then
            --local colorTier = colorTier[cell.tier]
            --local color = colors[colorTier]
            --[[
            local color = {0.5,0.5,0.5,0.5}
            love.graphics.setColor(color)
            love.graphics.rectangle('fill', position.x, position.y, self.unitSize, self.unitSize)
            ]]
            
            if cell.building == 'townhall' and position.icon ~= 'builder' then
              love.graphics.setColor(1, 1, 1, 1)
            else
              love.graphics.setColor(1, 1, 1, 0.7)
            end
            love.graphics.draw(gTextures['icons'], gFrames['icons'][position.iconNumber], position.x, position.y, 0, self.unitSize/10, self.unitSize/10)
            
            

            --love.graphics.setColor(0, 0, 0, 0.3)
            --love.graphics.rectangle('fill', position.x, position.y, self.unitSize, self.unitSize)
          end
        end
      end
    end
  end
  
  for _, enemy in ipairs(self.enemies) do
    if enemy.isAlive then
      enemy:render()
    end
  end
  
  for i, worker in ipairs(self.workers) do
    if worker.isAlive and (worker.work == 'blacksmith' or worker.work == 'doctor')then
      worker:render()
    end
  end
  
  for i, worker in ipairs(self.workers) do
    if worker.isAlive and (worker.work ~= 'blacksmith' and worker.work ~= 'doctor') then
      worker:render()
    end
  end
  
  
  love.graphics.setColor(self.timerBackground)
  love.graphics.rectangle('fill', self.timerX, self.timerY, self.timerWidth, self.timerHeight)
  
  love.graphics.setColor(self.sliderBackground)
  love.graphics.rectangle('fill', self.sliderX, self.sliderY, self.sliderWidth, self.sliderHeight)
  
  love.graphics.setColor(self.resourceBackground)
  love.graphics.rectangle('fill', self.resourceX, self.resourceY, self.resourceWidth, self.resourceHeight)
  
  
  
  
  
  
  
  love.graphics.setColor(colors.black)
  love.graphics.setFont(gFonts['medium'])
  for i, icon in pairs(self.resourceIcons) do
    icon:render()
  end
  for i, resource in pairs(self.resources) do
    love.graphics.print(resource.value,resource.x, resource.y)
  end
  
  
  for i, icon in pairs(self.workIcons) do
    if icon.active then
      icon:render()
    end
  end
  
  for i, slider in pairs(self.sliders) do
    if slider.active then
      slider:render()
    end
  end
  

  
  
  love.graphics.setColor(colors.white)
  love.graphics.setFont(gFonts['small'])
  for _, text in pairs(self.miscText) do
    love.graphics.print(text.text, text.x, text.y)
  end
  
  love.graphics.setFont(gFonts['medium'])
  if self.mainTimer > 0 then
    local minutes = math.floor(self.mainTimer / 60)
    local seconds = math.floor(self.mainTimer % 60)
    
    love.graphics.print(string.format("%02d:%02d", minutes, seconds), 160, 40)
  end
  
  
end
