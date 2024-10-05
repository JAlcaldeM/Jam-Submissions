Player = Class{}

function Player:init(def)
  
  
  self.width = def.width or tilesize
  self.height = def.height or 6
  
  self.x = def.x or VIRTUAL_WIDTH/2 - self.width/2
  self.y = def.y or 0
  self.xRound = self.x
  self.yRound = self.y
  
  self.speed = def.speed or 70
  self.hp = def.hp or 100
  self.hpMax = self.hp
  self.onDestroy = def.onDestroy or function() end
  self.shootingAllowed = def.shootingAllowed
  
  self.shootTimer = 0
  self.shootCD = 0.75
  
  self.projectile = {}
  self.projectile.size = 4
  
  self.level = def.level or 1
  self.exp = 0
  self.expMatrix = {}
  for i = 1, 30 do
    table.insert(self.expMatrix, 5*i)
  end

  self.expMax = self.expMatrix[self.level]
  
  self.levels = {}
  for _, upgrade in ipairs(upgradeList) do
    self.levels[upgrade] = 0
  end
  
  --self.levels.slow = 5
  
  self.inmuneToID = {}
  
  self.vulnerable = true
  
  self.player = true
  
  
end


function Player:update(dt)
  
  if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
    self.x = self.x - self.speed * dt * (1 + 0.5*self.levels.movespeed)
  elseif love.keyboard.isDown('right') or love.keyboard.isDown('d')then
    self.x = self.x + self.speed * dt * (1 + 0.5*self.levels.movespeed)
  end
  
  self.shootTimer = self.shootTimer + dt
  if self.shootTimer >= self.shootCD/(1 + 0.25*self.levels.firerate) then
    self.isShooting = true
    self.shootTimer = 0
  end
  
  
  self.x = math.min(VIRTUAL_WIDTH - self.width,math.max(0,self.x))
  
  self.xRound = math.floor(self.x)
  self.yRound = math.floor(self.y)
  
end





--[[
function Player:mouseIsOver(xMouse, yMouse)
  if xMouse and yMouse then
    return (xMouse > self.x and xMouse < self.x + self.width and yMouse > self.y and yMouse < self.y + self.height)
  end
end
]]


function Player:render()
  --[[
  love.graphics.setColor(palette[3])
  love.graphics.rectangle('fill', self.xRound, self.yRound, self.width, self.height)
  ]]
  love.graphics.setColor(colors.white)
  love.graphics.draw(gTextures['playsprites'], gFrames['playsprites'][3], self.xRound, self.yRound - 10)
  


end


function Player:levelUp()
  self.exp = self.exp - self.expMax
  self.level = self.level + 1
  self.expMax = self.expMatrix[self.level]
  gStateStack:push(LevelupState({player = self}))
  battlePosition = 1.05 * gSounds['battle']:tell()
  gSounds['battle']:pause()
end


