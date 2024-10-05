Enemy = Class{}

function Enemy:init(def)
  
  self.tier = def.tier or 1
  
  self.x = def.x or 0
  self.y = def.y or 0
  self.xRound = self.x
  self.yRound = self.y
  self.width = def.width or tilesize
  self.height = def.height or tilesize
  self.speed = def.speed or 10
  --self.hp = def.hp or 20
  --self.speed = 7 + 3 * self.tier
  self.hp = 5 + 5 * self.tier
  self.damage = def.damage or 10
  self.onDestroy = def.onDestroy or function() end
  
  self.inmuneToID = {}
  
  self.vulnerable = false
  Timer.after(0.8, function() self.vulnerable = true end)
  
  self.slowTimer = 0
  self.slowLevel = 0
  
  self.enemy = true
  
  

end


function Enemy:update(dt)
  
  local slowFactor = 1
  if self.slowTimer > 0 then
    self.slowTimer = self.slowTimer - dt
    slowFactor = 1 - 0.5*self.slowLevel
  elseif self.slowTimer < 0 then
    self.slowTimer = 0
  end

  
  self.y = self.y + self.speed * dt * slowFactor
  
  self.xRound = math.floor(self.x)
  self.yRound = math.floor(self.y)
end





function Enemy:render()
  --[[
  love.graphics.setColor(palette[4])
  love.graphics.rectangle('fill', self.xRound, self.yRound, self.width, self.height)
  ]]
  love.graphics.setColor(colors.white)
  love.graphics.draw(gTextures['playsprites'], gFrames['playsprites'][3 + self.tier], self.xRound, self.yRound)


end

function Enemy:collides(entity)
    if self.xRound + self.width >= entity.xRound and
    self.xRound <= entity.xRound + entity.width and
    self.yRound + self.height >= entity.yRound and
    self.yRound <= entity.yRound + entity.height then
      return true
    end

    return false
end