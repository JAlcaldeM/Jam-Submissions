Enemy = Class{}

function Enemy:init(def)
  self.x = def.x
  self.y = def.y
  self.size = def.size or 100
  self.scale = self.size/10
  --self.objective = nil
  
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
  
  
  self.speed = 110
  self.damage = 10
  
  self.isAlive = true
  
  self.playstate = def.playstate
  
  self.lowLimitX = self.playstate.playX
  self.highLimitX = self.playstate.playX + self.playstate.playWidth - self.playstate.unitSize
  self.lowLimitY = self.playstate.playY
  self.highLimitY = self.playstate.playY + self.playstate.playHeight - self.playstate.unitSize
  
  self.maxTimer = 1
  self.currentTimer = 0
  

end

function Enemy:update(dt)
  
  if not self.isAlive then
    return
  end
  
  
  --[[
  if (not self.destination) then
    self.destination = {x = math.random(self.lowLimitX, self.highLimitX), y = math.random(self.lowLimitY, self.highLimitY)}
  end
  ]]
  if (not self.destination) then
    self.destination = getCloserAvailableWorker(self.playstate, self, true)
    if self.destination then
      self.destination.isTarget = true
    else
      self.destination = getCloserAvailableWorker(self.playstate, self, false)
      if self.destination then
        self.destination.isTarget = true
      end
    end
  end
  
  
  
  
  
  self.currentTimer = self.currentTimer + dt
  if self.currentTimer >= self.maxTimer then
    self.destination = getCloserAvailableWorker(self.playstate, self, true)
    if self.destination then
      self.destination.isTarget = true
    else
      self.destination = getCloserAvailableWorker(self.playstate, self, false)
      if self.destination then
        self.destination.isTarget = true
      end
    end
    self.currentTimer = 0
  end
  
  if self.destination == nil then
    return
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
  
  for _, worker in pairs(self.playstate.workers) do
    if worker.isAlive then
      local distance = calculateDistance(self.x, self.y, worker.x, worker.y)
      if distance < self.size then
        if worker.armor > 0 then
          worker.armor = worker.armor - self.damage*dt
        else
          worker.hp = worker.hp - self.damage*dt
          if worker.hp < 0 then
            worker.isAlive = false
            if worker.workPosition then
              worker.workPosition.worker = nil
              worker.workPosition = nil
            end
            gSounds['clong']:play()
          end
        end
        if worker.work == 'soldier' then
          self.hp = self.hp - worker.damage*(1 + worker.exp/200)*dt
          if self.hp < 0 then
            self.isAlive = false
            self.destination.isTarget = false
            gSounds['clang']:play()
          end
        end
      end
    end
  end
  
  self.hpBar.value = self.hp
  
  
end


function Enemy:render()
  love.graphics.setColor(colors.white)
  love.graphics.draw(gTextures['icons'], gFrames['icons'][27], math.floor(self.x), math.floor(self.y), 0, self.scale, self.scale)
  
  if self.hp < self.maxHp then
    self.hpBar:render()
  end
end
