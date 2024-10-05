Button = Class{}

function Button:init(def)
  self.x = def.x or 0
  self.y = def.y or 0
  self.iconNumber = def.iconNumber
  self.size = def.size or 10
  self.width = def.width or self.size
  self.height = def.height or self.size
  self.text = def.text or ''
  self.color = def.color or colors.transparent
  self.colorFont = def.colorFont or colors.black
  self.onHover = def.onHover or function() self.shadow = true end
  self.notOnHover = def.notOnHover or function() self.shadow = false end
  self.shadow = false
  self.onClick = def.onClick or function() end
  self.active = def.active
  if self.active == nil then
    self.active = true
  end
  
  if self.iconNumber then
    if self.size == 5 then
      self.tag = 'icons5'
    else
      self.tag = 'icons8'
    end
  end
  
  

end

function Button:mouseIsOver(xMouse, yMouse)
  if xMouse and yMouse then
    return (xMouse > self.x and xMouse < self.x + self.width and yMouse > self.y and yMouse < self.y + self.height)
  end
end


function Button:render()
  love.graphics.setColor(self.color)
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
  
  if self.tag then
    love.graphics.setColor(colors.white)
    love.graphics.draw(gTextures[self.tag], gFrames[self.tag][self.iconNumber], self.x, self.y)
  end
  
  
  
  if self.shadow then
    love.graphics.setColor(0,0,0,0.3)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
  end
  
  

  
  love.graphics.setColor(self.colorFont)
  love.graphics.printf(self.text, self.x, self.y, self.width, 'center')

end