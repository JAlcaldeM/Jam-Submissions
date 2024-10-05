Item = Class{}

function Item:init(def)
  self.x1 = def.x1 or 0
  self.y1 = def.y1 or 0
  self.x2 = def.x2 or 0
  self.y2 = def.y2 or 0
  
  self.size = 10

  self.type = def.type or 'empty'
  self.tags = itemTags[self.type]
  self.iconNumber = itemIcon[self.type]
  self.iconBigNumber = itemBigIcon[self.type]
  
  self.value = defaultItemValue[self.type]
  self.sellValue = math.floor(self.value*(cut/100 + 1))

  self.opacity = def.opacity or 1
  
  self.printBig = def.printBig or false
  self.selected = false
  

end

--[[

function Item:update(dt)
  
  
  
end
]]


function Item:mouseIsOver(xMouse, yMouse)
  if xMouse and yMouse then
    return (xMouse > self.x1 and xMouse < self.x1 + self.size and yMouse > self.y1 and yMouse < self.y1 + self.size)
  end
end

function Item:render()
  --[[
  love.graphics.setColor(colors.white)
  love.graphics.draw(gTextures['characters'], gFrames['characters'][self.iconNumber], math.floor(self.x), math.floor(self.y))
  
  love.graphics.setColor(colors.white)
  if self.bubble then
    love.graphics.draw(gTextures['bubble'], 20, 9)
  end
  ]]
  
  if self.selected then
    local selectedWidth = 1
    local offset = selectedWidth / 2
    love.graphics.setLineWidth(selectedWidth)
    love.graphics.setColor(colors.yellow)
    love.graphics.rectangle('line', self.x1 + offset, self.y1 + offset, self.size - selectedWidth, self.size - selectedWidth)
  end
  
  --[[
  love.graphics.setColor(1, 0, 0, 0.8)
  love.graphics.rectangle('fill', self.x1, self.y1, self.size, self.size)
  ]]
  
  
  love.graphics.setColor(colors.white)
  love.graphics.draw(gTextures['items'], gFrames['items'][self.iconNumber], self.x1, self.y1)
  
  if self.printBig then
    love.graphics.draw(gTextures['itemsbig'], gFrames['itemsbig'][self.iconBigNumber],self.x2, self.y2)
  end
  
  

end
