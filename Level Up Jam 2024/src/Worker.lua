Worker = Class{}

function Worker:init(def)
  self.x = def.x
  self.y = def.y
  self.work = 'none'
  self.iconNumber = 15
  self.size = def.size or 100
  self.scale = self.size/10
  
  self.playState = def.playState
  
  self.speed = 100
  self.behavior = 'roam'
  self.lowLimitX = self.playState.playX
  self.highLimitX = self.playState.playX + self.playState.playWidth - self.playState.unitSize
  self.lowLimitY = self.playState.playY
  self.highLimitY = self.playState.playY + self.playState.playHeight - self.playState.unitSize
  
  if def.work then
    self:changeWork(def.work)
  end
  self.positions = def.positions
  
  
  
  self.damage = 40
  
  
  self.hp = 100
  self.maxHp = 100
  self.hpBar = Bar{
    worker = self,
    xDiff = 0,
    yDiff = 70,
    width = self.size,
    height = self.size/10,
    value = self.hp,
    maxValue = self.maxHp,
    color = colors.red,
    backgroundColor = colors.black,
  }
  
  self.armor = 0
  self.maxArmor = 50
  self.armorBar = Bar{
    worker = self,
    xDiff = 0,
    yDiff = 70,
    width = self.size/2,
    height = self.size/10,
    value = self.armor,
    maxValue = self.maxArmor,
    color = colors.grey,
  }
  
  self.exp = 0
  self.maxExp = 100
  self.expBar = Bar{
    worker = self,
    xDiff = 0,
    yDiff = 76,
    width = self.size,
    height = self.size/10,
    value = self.hp,
    maxValue = self.maxHp,
    color = colors.blue,
  }
  
  
  
  --[[
  self.exp = 0
  self.expBar =
  ]]
  self.workProgress = 0
  self.maxWorkProgress = 100
  self.workProgressBar = Bar{
    worker = self,
    xDiff = 0,
    yDiff = 0,
    width = self.size,
    height = self.size/10,
    value = self.workProgress,
    maxValue = self.maxWorkProgress,
    color = colors.yellow,
  }
  
  self.isAlive = true
  
  --self.onClick = def.onClick or function() end
  --self.onHover = def.onClick or function() end

end

--[[
function Worker:mouseIsOver(xMouse, yMouse)
    return (xMouse > self.x and xMouse < self.x + 10*self.scale and yMouse > self.y and yMouse < self.y + 10*self.scale)
end
]]

function Worker:update(dt)
  
  -- choose behaviour depending on work
  

  if self.work == 'farmer' or self.work == 'lumberjack' or self.work == 'stonemason' or self.work == 'miner' then
    
    
    if self.resource then
      self.destination = checkCloserPosition(self.positions, self, self.resource)
      self.behavior = 'deposit'
    else
      if self.workPosition then
        self.destination = self.workPosition
        self.behavior = 'move'
        if  (self.x == self.destination.x) and (self.y == self.destination.y) then
          if not self.plin then
            self.plin = true
            gSounds['plin']:play()
          end
          self.behavior = 'workResource'
        end
      else
        local closerPosition = checkCloserPosition(self.positions, self, self.work)
        if closerPosition then
          closerPosition.worker = self
          self.workPosition = closerPosition
        else
          self.behavior = 'roam'
        end
      end
    end
    --[[
    if self.resource then
      self.behavior = 'deposit'
    end
    ]]
    
  elseif self.work == 'builder' then
    if self.workPosition then
      local requiredResource = self.workPosition.buildMaterial
      if self.resource then
        if self.resource == requiredResource then
          self.destination = self.workPosition
          self.behavior = 'move'
          if  (self.x == self.destination.x) and (self.y == self.destination.y) then
            self.behavior = 'build'
          end
        else
          self.destination = checkCloserPosition(self.positions, self, self.resource)
          self.behavior = 'deposit'
        end
      else
        self.destination = checkCloserPosition(self.positions, self, requiredResource)
        self.behavior = 'move'
        if  (self.x == self.destination.x) and (self.y == self.destination.y) and (self.playState.resources[requiredResource].value > 0) then
          self.resource = requiredResource
          self.playState.resources[requiredResource].value = self.playState.resources[requiredResource].value - 1
        end
      end
      
      
    else
      local closerPosition = checkRandomPosition(self.positions, self, self.work) --checkCloserPosition(self.positions, self, self.work)
      if closerPosition then
        closerPosition.worker = self
        self.workPosition = closerPosition
      else
        self.behavior = 'roam'
      end
    end
    
  elseif self.work == 'soldier' then
    local currentTarget
    if self.rival then
        if self.rival.isAlive then
            currentTarget = self.rival
        else
            self.rival = nil
        end
    end

    if not self.rival then
        local currentCloserEnemy
        local minDistance = math.huge
        for _, enemy in pairs(self.playState.enemies) do
            if enemy.isAlive and not enemy.rival then
                local distance = calculateDistance(self.x, self.y, enemy.x, enemy.y)
                if distance < minDistance then
                    minDistance = distance
                    currentCloserEnemy = enemy
                end
            end
        end
        if currentCloserEnemy then
            self.rival = currentCloserEnemy
            currentCloserEnemy.rival = self
            currentTarget = currentCloserEnemy
        end
    end

    if currentTarget then
        self.destination = {x = currentTarget.x, y = currentTarget.y}
        self.behavior = 'move'
    else
        local blacksmith = checkBehavior('forge', self)
        if blacksmith and self.armor < self.maxArmor then
          blacksmith.friend = self
          self.destination = {x = blacksmith.x, y = blacksmith.y}
          self.behavior = 'move'
          if (self.x == self.destination.x) and (self.y == self.destination.y) then
            self.armor = self.armor + armorGainRate*dt
            if self.armor >= self.maxArmor then
              self.armor = self.maxArmor
              blacksmith.friend = nil
            end
          end
        elseif self.workPosition then
            self.destination = {x = self.workPosition.x, y = self.workPosition.y}
            self.behavior = 'move'
            if  (self.x == self.destination.x) and (self.y == self.destination.y) then
              self.behavior = 'train'
            end
        else
            local closerPosition = checkCloserPosition(self.positions, self, self.work)
            if closerPosition then
                closerPosition.worker = self
                self.workPosition = closerPosition
                self.destination = {x = closerPosition.x, y = closerPosition.y}
                self.behavior = 'move'
                
            else
                self.behavior = 'roam'
            end
        end
    end
    
  elseif self.work == 'doctor' or self.work == 'blacksmith' then
    if self.workPosition then
      self.destination = self.workPosition
      self.behavior = 'move'
      if  (self.x == self.destination.x) and (self.y == self.destination.y) then
        if self.work == 'doctor' then
          self.behavior = 'heal'
        else
          self.behavior = 'forge'
        end
      end
    else
      local closerPosition = checkCloserPosition(self.positions, self, self.work)
      if closerPosition then
        closerPosition.worker = self
        self.workPosition = closerPosition
      else
        self.behavior = 'roam'
      end
    end
  else
      self.behavior = 'roam'
  end

  if not (self.behavior == 'forge' or self.behavior == 'heal') then
    self.friend = nil
  end
  
  
  
  
  if self.behavior == 'workResource' then
    local workingResource = workToResource[self.work]
    --print(self.work, workingResource)
    if workingResource then
      self.workProgress = self.workProgress + baseResourceRate[workingResource]*dt
    end
    if self.workProgress >= self.maxWorkProgress then
      self.resource = workToResource[self.work]
      self.workPosition.worker = nil
      self.workPosition = nil
      self.workProgress = 0
      self.destination = checkCloserPosition(self.positions, self, self.resource)
      self.plin = false
      if self.resource == 'wood' then
        gSounds['wood']:play()
      elseif self.resource == 'wheat' then
        gSounds['unknown']:play()
      elseif self.resource == 'stone' then
        gSounds['stone']:play()
      elseif self.resource == 'iron' then
        gSounds['iron']:play()
      end
    end
  end
  
  if self.behavior == 'build' then
    --print(self.resource, self.work, self.destination.icon)
    if self.resource then
      self.workProgress = self.workProgress + baseBuildRate[self.resource]*dt
    end
    
    
    if self.workProgress >= self.maxWorkProgress then
      gSounds['saw']:play()
      self.resource = nil
      self.workPosition.worker = nil
      self.workPosition.constructed = true
      self.workPosition.icon = nil
      if isBuildingComplete(self.workPosition.cell) then
        if self.workPosition.cell.building == 'construction' then
          self.workPosition.cell.building = decideBuildingType(self.playState)
          createNewConstructionSite(self.playState.cells, self.playState)
        end
        
        if self.workPosition.cell.building == 'townhall' and self.workPosition.cell.townhallUpgrades >= townhallUpdatesNeeded then
          gSounds['fanfare']:play()
          self.workPosition.cell.townhallUpgrades = 1
          self.workPosition.cell.tier = self.workPosition.cell.tier + 1
          self.playState.tier = self.playState.tier + 1
          for _, cell in ipairs(self.playState.cells) do
            if cell.building then
              assignWorkPositions(cell, self.playState)
            end
          end
          activateSliders(self.playState, self.workPosition.cell.tier)
          
          
          
        elseif self.workPosition.cell.building == 'townhall' and self.workPosition.cell.townhallUpgrades < townhallUpdatesNeeded then
          self.workPosition.constructed = false
          self.workPosition.icon = 'builder'
          self.workPosition.cell.townhallUpgrades = self.workPosition.cell.townhallUpgrades + 1
        else
          self.workPosition.cell.tier = self.workPosition.cell.tier + 1
          assignWorkPositions(self.workPosition.cell, self.playState)
        end
      end
      self.workPosition = nil
      self.workProgress = 0
    end
  end
  
  if self.behavior == 'train' then
    self.exp = self.exp + expGainRate*dt
    self.exp = clamp(self.exp, 0, 100)
    self.speed = (100 + self.exp/2)
  end
  
  
  if self.hp < 0.5*self.maxHp then
    local doctor = checkBehavior('heal', self)
    if doctor then
      self.doctor = doctor
      doctor.friend = self
      self.destination = {x = doctor.x, y = doctor.y}
      self.behavior = 'goToHeal'
    end
  end
  

  if self.doctor then
    self.behavior = 'goToHeal'
  end
  
  if self.resource and self.work ~= 'builder' then
    self.destination = checkCloserPosition(self.positions, self, self.resource)
    self.behavior = 'deposit'
  end
  
  
  --[[
  if self.behavior == 'forge' then
    print('i am available to forge')
  end
  ]]
  
  if self.behavior == 'roam' or self.behavior == 'move' or self.behavior == 'deposit' or self.behavior == 'goToHeal' then
    if (not self.destination) then
      self.destination = {x = math.random(self.lowLimitX, self.highLimitX), y = math.random(self.lowLimitY, self.highLimitY)}
    end
    
    
    local diffX = self.destination.x - self.x
    local diffY = self.destination.y - self.y
    local movAng = math.atan2(diffY, diffX)
    
    local dX = self.speed * math.cos(movAng) * dt
    local dY = self.speed * math.sin(movAng) * dt
    
    if math.abs(dX) > math.abs(diffX) then
      dX = diffX
    end
    if math.abs(dY) > math.abs(diffY) then
      dY = diffY
    end
    
    
    
    
    self.x = self.x + dX
    self.y = self.y + dY
    
    
    if self.x == self.destination.x and self.y == self.destination.y then
      
      if self.behavior == 'goToHeal' then
        if  (self.x == self.destination.x) and (self.y == self.destination.y) then
          self.hp = self.hp + doctorHealRate*dt
          if self.hp >= self.maxHp then
            self.hp = self.maxHp
            self.doctor.friend = nil
            self.doctor = nil
          end
        end
      else
        self.destination = nil
      end
      
      
      
      if self.behavior == 'deposit' then
        self.playState.resources[self.resource].value = self.playState.resources[self.resource].value + 1
        self.resource = nil
        gSounds['reward']:stop()
        gSounds['reward']:play()
      end
      
      
    end
    
  end
  
  
  
  
  
  
  
  
  
  
  
  if self.hp < self.maxHp then
    local regenRate = 1
    self.hp = self.hp + regenRate*dt
  end
  
  self.workProgressBar.value = self.workProgress
  self.hpBar.value = self.hp
  self.expBar.value = self.exp
  self.armorBar.value = self.armor
  
end



function Worker:render()
  love.graphics.setColor(1, 1, 1, 1)
  
  if self.resource then
    local resourceIconNumber = resourceIcons[self.resource]
    love.graphics.draw(gTextures['icons'], gFrames['icons'][resourceIconNumber], math.floor(self.x + self.size/4), math.floor(self.y - self.size/4), 0, self.scale, self.scale)
  end
  
  
  love.graphics.draw(gTextures['icons'], gFrames['icons'][self.iconNumber], math.floor(self.x), math.floor(self.y), 0, self.scale, self.scale)
  
  --[[
  if self.destination then
    love.graphics.setColor(colors.blue)
    love.graphics.rectangle('fill', self.destination.x, self.destination.y, 10, 10)
  end
  ]]
  
  if self.behavior == 'workResource' or self.behavior == 'build' then
    self.workProgressBar:render()
  end
  
  if self.hp < self.maxHp then
    self.hpBar:render()
  end
  
  if self.exp > 0 then
    self.expBar:render()
  end
  
  if self.armor > 0 then
    self.armorBar:render()
  end
  
  
  --[[
  self.workProgressBar:render()
  self.hpBar:render()
  self.expBar:render()
  ]]

end

function Worker:changeWork(newWork)
  self.work = newWork
  self.iconNumber = workIcons[newWork]
  self.workProgress = 0
  if self.workPosition then
    self.workPosition.worker = nil
    self.workPosition = nil
  end
  --print('new work', newWork, 'new iconNumber', self.iconNumber)
end
