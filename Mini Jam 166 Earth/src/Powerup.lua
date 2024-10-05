Powerup = Class{}

function Powerup:init(def)
  self.x = def.x or 0
  self.y = def.y or 0
  self.tier = def.tier or 1
  self.xRound = self.x
  self.yRound = self.y
  self.width = def.width or 4
  self.height = def.height or 4
  self.speed = def.speed or 50

  self.ally = def.ally
  self.hp = def.hp or 1
  
  self.damage = def.damage or 10
  
  --self.onHit = def.onHit or function() end
  self.onDestroy = def.onDestroy or function() end
  
  self.palette = enemyPalettes[self.tier]
  

end


function Powerup:update(dt)
  
  self.y = self.y + self.speed * dt
  
  
  self.xRound = math.floor(self.x)
  self.yRound = math.floor(self.y)
end



function Powerup:render()
  love.graphics.setColor(self.palette[4])
  love.graphics.rectangle('fill', self.xRound, self.yRound, self.width, self.height)
  
  love.graphics.setColor(self.palette[3])
  love.graphics.rectangle('fill', self.xRound + 1, self.yRound + 1, self.width - 2, self.height - 2)
  


end

function Powerup:collides(entity)
    if self.xRound + self.width >= entity.xRound and
    self.xRound <= entity.xRound + entity.width and
    self.yRound + self.height >= entity.yRound and
    self.yRound <= entity.yRound + entity.height then
      return true
    end

    return false
end