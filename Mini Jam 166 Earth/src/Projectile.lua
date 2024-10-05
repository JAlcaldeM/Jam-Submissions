Projectile = Class{}

function Projectile:init(def)
  self.x = def.x or 0
  self.y = def.y or 0
  self.xRound = self.x
  self.yRound = self.y
  self.width = def.width or 4
  self.height = def.height or 4
  self.speed = def.speed or 30
  self.ang = def.ang or 0
  self.ally = def.ally
  if self.ally == nil then
    self.ally = true
  end
  self.hp = def.hp or 1
  self.damage = def.damage or 10
  --self.onHit = def.onHit or function() end
  self.onDestroy = def.onDestroy or function() end
  
  self.tier = def.tier or false
  if self.tier then
    self.palette = enemyPalettes[self.tier]
  else
    self.palette = palette
  end
  
  
  
  self.canvas = love.graphics.newCanvas(self.width, self.height)
  love.graphics.setCanvas(self.canvas)
  
  love.graphics.setColor(self.palette[4])
  love.graphics.ellipse('fill', self.width/2, self.height/2, self.width/2, self.height/2)
  love.graphics.setColor(self.palette[2])
  love.graphics.ellipse('fill', self.width/2, self.height/2, self.width/2 - 1, self.height/2 - 1)
  
  --[[
  love.graphics.setColor(palette[4])
  love.graphics.rectangle('fill', 0, 0, self.width, self.height)
  ]]
  
  love.graphics.setCanvas()
  
  self.ID = def.ID or nextProjectileID
  nextProjectileID = nextProjectileID + 1
  
  self.explosion = def.explosion or false
  if self.explosion then
    self.alphaTimer = 0
    self.alphaTimerMax = 0.2
    self.alphaNChanges = 0
    self.alphaNChangesMax = 5
  end
  self.visible = true
  
  self.slowLevel = def.slowLevel or false
  

end


function Projectile:update(dt)
  
  self.x = self.x + self.speed * dt * math.sin(self.ang)
  
  local direction = 1
  if not self.ally then
    direction = -1
  end
  
  self.y = self.y + direction * self.speed * dt * -math.cos(self.ang)
  
  --[[
  if (not self.explosion) and self.y >= VIRTUAL_HEIGHT - tilesize or self.y <= 0 then
    self.onDestroy = function() end
    self.destroyedNext = true
  end
  ]]
  
  if self.explosion then
    self.alphaTimer = self.alphaTimer + dt
    if self.alphaTimer >= self.alphaTimerMax then
      self.alphaTimer = 0
      self.visible = not self.visible
      self.alphaNChanges = self.alphaNChanges + 1
      if self.alphaNChanges >= self.alphaNChangesMax then
        self.destroyedNext = true
      end
    end
  end
  
  
  
  
  
  self.xRound = math.floor(self.x)
  self.yRound = math.floor(self.y)
end



function Projectile:render()
  --love.graphics.setColor(palette[2])
  --love.graphics.rectangle('fill', self.xRound, self.yRound, self.width, self.height)
  --love.graphics.ellipse('fill', self.xRound + self.width/2, self.yRound + self.height/2, self.width/2, self.height/2)
  
  if self.visible then
    love.graphics.setColor(colors.white)
    love.graphics.draw(self.canvas, self.xRound, self.yRound)
  end
  
  


end

function Projectile:collides(entity)
    if self.xRound + self.width >= entity.xRound and
    self.xRound <= entity.xRound + entity.width and
    self.yRound + self.height >= entity.yRound and
    self.yRound <= entity.yRound + entity.height then
      return true
    end

    return false
end