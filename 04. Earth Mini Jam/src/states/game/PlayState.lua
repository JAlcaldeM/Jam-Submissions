PlayState = Class{__includes = BaseState}

function PlayState:init(def)
    self.type = 'Play'
    
    self.enemies = {}
    --[[
    local testEnemy = Enemy{
      y = tilesize,
    }
    table.insert(self.enemies, testEnemy)
    ]]
    
    self.player = Player{
      y = VIRTUAL_HEIGHT - tilesize - 6,--2*tilesize,
      shootingAllowed = true,
    }
    
    
    
    
    self.projectiles = {}
    local testProjectile = Projectile{
      x = 50,
      y = 50,
    }
    table.insert(self.projectiles, testProjectile)
    
    self.powerups = {}
    
    self.nextWaveEnemies = 2
    self.enemySpawnFactor = 0.8 --0.25
    self.minEnemyY = VIRTUAL_HEIGHT
    self.minEnemyYLimit = 5
    
    
    self.baseDamage = 10
    
    self.mainTimer = 60.99
    
    gSounds['battle']:play()
    
    
    self.enemyTier = 1
    
    self.shotTimer = 0
    self:calculateShotTimerMax()
    
    
end

function PlayState:calculateShotTimerMax()
  self.shotTimerMax = 3 + math.random()
end

function PlayState:enemyShots()
  local enemy = self.enemies[math.random(#self.enemies)]
  local projectileSize = 8
  
  local x = enemy.xRound + enemy.width/2 - projectileSize/2
  local y = enemy.yRound + enemy.height
  local damage = self.baseDamage * (1 + 0.5*enemy.tier)
  
  local projectile = Projectile{
    x = x,
    y = y,
    ally = false,
    damage = damage,
    hp = 1,
    tier = enemy.tier,
    width = projectileSize,
    height = projectileSize,
  }
  table.insert(self.projectiles, projectile)
  gSounds['enemyshoot']:play()

end






function PlayState:update(dt)
  
  if self.mainTimer > 1 then
    self.mainTimer = self.mainTimer - dt
  else
    gStateStack:push(WinState())
  end
  
  if self.mainTimer <= 30 then
    self.enemyTier = 4
  elseif self.mainTimer <= 60 then
    self.enemyTier = 3
  elseif self.mainTimer <= 90 then
    self.enemyTier = 2
  end
  
  self.shotTimer = self.shotTimer + dt
  if self.shotTimer >= self.shotTimerMax then
    self:enemyShots()
    self.shotTimer = 0
    self:calculateShotTimerMax()
  end
  
  
  
   -- player
  self.player:update(dt)
  if self.player.shootingAllowed and self.player.isShooting then
    self:spawnProjectile('normal')
  end
  
  
  -- enemies
  for _, enemy in ipairs(self.enemies) do
    enemy:update(dt)
    
    for _, enemy2 in ipairs(self.enemies) do
      if enemy:collides(enemy2) and enemy2.yRound > enemy.yRound then
        local yNew = enemy2.yRound - enemy.height
        enemy.y = yNew
        enemy.yRound = yNew
      end
    end
    
    if enemy:collides(self.player) or enemy.yRound >= VIRTUAL_HEIGHT - tilesize - enemy.height then
      self:dealDamage(self.player, self.player.hp)
    end
    
    
  end
  

  -- projectiles
  for _, projectile in ipairs(self.projectiles) do
    projectile:update(dt)
    if projectile.ally then
      for _, enemy in ipairs(self.enemies) do
        self:checkProjectileEntity(projectile, enemy)
      end
    else
      self:checkProjectileEntity(projectile, self.player)
      if projectile.y >= VIRTUAL_HEIGHT - tilesize - 8 then
        projectile.destroyedNext = true
        gSounds['hit']:stop()
        gSounds['hit']:play()
      end
    end
  end
  
  local vLimit = VIRTUAL_HEIGHT - tilesize - 4
  for _, powerup in ipairs(self.powerups) do
    powerup:update(dt)
    

    
    if powerup.y >= vLimit then
      powerup.grounded = true
      powerup.y = vLimit
      powerup.yRound = vLimit
    end
    
    --[[
    if not powerup.grounded
    for _, powerup2 in pairs(self.powerups) do
      local vlimit2 = powerup2.yRound - 4
      if (powerup2.grounded or powerup2.overPowerup) and powerup.y >= vlimit2 then
        powerup.y = vlimit2
        powerup.yRound = vlimit2
      end
    end
    ]]

    
    if (not powerup.destroyedNext) and powerup:collides(self.player) then
      powerup.destroyedNext = true
    end
  end
  
  
  
  self.nextWaveEnemies = self.nextWaveEnemies + self.enemySpawnFactor * dt * (3 - 2*self.mainTimer/120) --* (0.5 + 0.1* (5 - self.enemyTier))
  
  for _, enemy in pairs(self.enemies) do
    if enemy.yRound < self.minEnemyY then
      self.minEnemyY = enemy.yRound
    end
  end
  
  if self.minEnemyY >= self.minEnemyYLimit then
    self:spawnWave()
  end
  
  if self.nextWaveEnemies >= 8 then
    for _, enemy in pairs(self.enemies) do
      if enemy.y < 0 then
        enemy.destroyed = true
      end
    end
    self:spawnWave()
  end
  

  
  
  self.minEnemyY = VIRTUAL_HEIGHT
  
  self:deleteDestroyed()
  
  --[[
  if love.keyboard.wasPressed('space') then
    gStateStack:push(PauseState({}))
  end
  
  if love.keyboard.wasPressed('w') then
    gStateStack:push(WinState({}))
  end
  
  if love.keyboard.wasPressed('l') then
    gStateStack:push(LoseState({}))
  end
  ]]

end



function PlayState:render()
  
  -- background
  love.graphics.setColor(palette[1])
  love.graphics.rectangle('fill',0,0,VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
  
  
  -- ground (ui)
  love.graphics.setColor(palette[2])
  love.graphics.rectangle('fill',0,VIRTUAL_HEIGHT - tilesize,VIRTUAL_WIDTH, tilesize)
  
  -- HP AND EXP BARS
  love.graphics.setColor(palette[4])
  love.graphics.rectangle('fill', tilesize, VIRTUAL_HEIGHT - tilesize + 1, 2.5*tilesize, tilesize - 2)
  love.graphics.rectangle('fill', 4.5*tilesize, VIRTUAL_HEIGHT - tilesize + 1, 2.5*tilesize, tilesize - 2)
  love.graphics.setColor(palette[1])
  love.graphics.rectangle('fill', tilesize + 1, VIRTUAL_HEIGHT - tilesize + 2, 2.5*tilesize - 2, tilesize - 4)
  love.graphics.rectangle('fill', 4.5*tilesize + 1, VIRTUAL_HEIGHT - tilesize + 2, 2.5*tilesize - 2, tilesize - 4)
  love.graphics.setColor(palette[3])
  love.graphics.rectangle('fill', tilesize + 1, VIRTUAL_HEIGHT - tilesize + 2, math.floor((2.5*tilesize-2)*(self.player.hp/self.player.hpMax)), tilesize - 4)
  love.graphics.rectangle('fill', 4.5*tilesize + 1, VIRTUAL_HEIGHT - tilesize + 2, math.floor((2.5*tilesize-2)*(self.player.exp/self.player.expMax)), tilesize - 4)
  
  
  --HP AND EXP ICONS
  love.graphics.setColor(colors.white)
  love.graphics.draw(gTextures['playsprites'], gFrames['playsprites'][8], 0, VIRTUAL_HEIGHT - tilesize)
  love.graphics.draw(gTextures['playsprites'], gFrames['playsprites'][9], 3.5*tilesize, VIRTUAL_HEIGHT - tilesize)
  
  --grass
  love.graphics.setColor(colors.white)
  for i = 1, 10 do
    love.graphics.draw(gTextures['playsprites'], gFrames['playsprites'][1], tilesize * (i - 1), VIRTUAL_HEIGHT - 2*tilesize)
  end
  
  -- clouds
  love.graphics.draw(gTextures['clouds'], 40 - math.floor(self.mainTimer/5), 50)
  

  
  
  -- powerups
  for _, powerup in ipairs(self.powerups) do
    powerup:render()
  end

  
  -- enemies
  for _, enemy in ipairs(self.enemies) do
    enemy:render()
  end
  
  -- projectiles
  for _, projectile in ipairs(self.projectiles) do
    projectile:render()
  end
  
  
   -- player
  self.player:render()
  
  
  --timer
  love.graphics.setColor(palette[3])
  love.graphics.setFont(gFonts['medium'])
  if self.mainTimer > 0 then
    local minutes = math.floor(self.mainTimer / 60)
    local seconds = math.floor(self.mainTimer % 60)
    
    love.graphics.printf(string.format("%02d:%02d", minutes, seconds), 0, 129, VIRTUAL_WIDTH - 1, 'right')
  end
  
  
  
  --[[
  
  love.graphics.setColor(0.5,0.5,0.5)
  love.graphics.rectangle('fill', 0,0,VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
  
  
  
  
  
  -- mainChar Coordinates
  love.graphics.setColor(colors.white)
  love.graphics.setFont(gFonts['small'])
  love.graphics.print('mainChar.x = '..self.mainChar.x, 10,1000)
  love.graphics.print('mainChar.y = '..self.mainChar.y, 10, 1040)
  ]]
  
  
end



function PlayState:checkProjectileEntity(projectile, entity)
  
  local projectileImpacts = true

  for _, ID in pairs(entity.inmuneToID) do
    if ID == projectile.ID then
      projectileImpacts = false
    end
  end

  
  if projectileImpacts and entity.vulnerable and projectile:collides(entity) then
    self:dealDamage(entity, projectile.damage)
    self:dealDamage(projectile, 1)
    -- additional effects??
    table.insert(entity.inmuneToID, projectile.ID)
    gSounds['hit']:stop()
    gSounds['hit']:play()
    
    if projectile.slowLevel then
      entity.slowTimer = entity.slowTimer + 2
      if projectile.slowLevel > entity.slowLevel then
        entity.slowLevel = projectile.slowLevel
      end
    end
  end

end




function PlayState:dealDamage(entity, damage)
  entity.hp = entity.hp - damage
  if entity.hp <= 0 then
    entity.destroyedNext = true
    if entity.player == true then
      gStateStack:push(LoseState({}))
    end
  end
end





function PlayState:deleteDestroyed()
  
  local matrices = {self.projectiles, self.enemies, self.powerups}
  
  -- Handle player separately
  if self.player.destroyed then
    self.player = nil
    -- self.player.onDestroy()
  elseif self.player.destroyedNext then
    self.player.destroyed = true
  end
  
  for _, matrix in ipairs(matrices) do
    for i = #matrix, 1, -1 do
      local element = matrix[i]
      if element.destroyed then
        element.onDestroy()
        table.remove(matrix, i)
        if element.enemy then
          gSounds['destroyed']:play()
        end
      elseif element.destroyedNext then
        element.destroyed = true
      end
    end
  end
  
end

function PlayState:spawnWave()
  
  local nColumns = 8
  local spawnEnemies = math.min(nColumns, math.floor(self.nextWaveEnemies))

  local orderedArray = {}
  for i = 1, nColumns do
    table.insert(orderedArray, i)
  end
  local randomArray = shuffleArray(orderedArray)
  
  --local spawnColumns = {}
  for i = 1, spawnEnemies do
    --table.insert(spawnColumns, randomArray[i])
    local enemy = Enemy{
      x = 2 + (tilesize + 4)*(randomArray[i] - 1),    --(randomArray[i] - 0.5) * tilesize,
      y = - tilesize,
      tier = self.enemyTier,
      speed = 10,
      --speed = 4 * (3 - 2*self.mainTimer/120)
      
    }
    enemy.onDestroy = function()
      local tier = enemy.tier
      local powerup = Powerup{
        x = enemy.xRound + enemy.width/2 - 4 + math.random(-2, 2),
        y = enemy.yRound + enemy.height/2,
        tier = tier,
        onDestroy = function()
          self.player.exp = self.player.exp + 0.5 + 0.5*tier
          if self.player.exp >= self.player.expMax then
            self.player:levelUp()
          end
          gSounds['powerup']:stop()
          gSounds['powerup']:play()
        end
        
      }
      table.insert(self.powerups, powerup)
    end
    
    table.insert(self.enemies, enemy)
  end
  
  self.nextWaveEnemies = self.nextWaveEnemies - spawnEnemies + math.random(0,2)
  
end



function PlayState:spawnProjectile(type)
  
  local x = self.player.x + self.player.width/2 - self.player.projectile.size/2
  local y = self.player.y - 4
  local damage = self.baseDamage * (1 + 0.5*self.player.levels.damage) / (1 + self.player.levels.pellet)
  
  local projectile = Projectile{
    x = x,
    y = y,
    ally = true,
    damage = damage,
    hp = 1 + self.player.levels.pierce,
    slowLevel = self.player.levels.slow
  }
  
  --if self.player.levels.explosion > 0 then
    projectile.onDestroy = function()
      local size = 10 * (self.player.levels.explosion + 1)
      local explosion = Projectile{
        x = projectile.xRound + projectile.width/2 - size/2,
        y = projectile.yRound + projectile.height/2 - size/2,
        width = size,
        height = size,
        speed = 0,
        damage = damage,
        ally = true,
        ID = projectile.ID,
        hp = 999,
        explosion = true,
      }
      table.insert(self.projectiles, explosion)
      gSounds['explosion']:stop()
      gSounds['explosion']:play()
    end
  -- end
  
  table.insert(self.projectiles, projectile)
  self.player.isShooting = false
  gSounds['shoot']:stop()
  gSounds['shoot']:play()
  
  local extraProjectiles = self.player.levels.pellet
  if type == 'normal' and extraProjectiles > 0 then
    for i = 1, extraProjectiles do
      Timer.after(0.1*i, function()
          self:spawnProjectile('pellet')
        end)
    end
  end
  
end
