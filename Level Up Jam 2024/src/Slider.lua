Slider = Class{}

function Slider:init(def)
  self.x = def.x
  self.y = def.y
  
  if def.active == false then
    self.active = false
  else
    self.active = true
  end
  
  self.scale = def.scale or 100
  self.startPosition = def.startPosition or 0.5
  self.value = self.startPosition * self.scale
  
  self.width = def.width
  self.height = def.height
  
  self.colorButton = def.colorButton or colors.white
  self.colorBackground = def.colorBackground or colors.white
  
  self.bold = def.bold or true
  if self.bold then
    self.boldColorButton = def.boldColor or colors.black
    self.boldColorBackground = def.boldColor or colors.black
  else
    self.boldColorButton = self.colorButton
    self.boldColorBackground = self.colorBackground
  end
  
  
  self.buttonWidthScale = def.buttonWidthScale or 0.1
  self.buttonWidth = self.buttonWidthScale*self.width
  self.buttonX = self.x + (self.width - self.buttonWidth)/2
  
  self.backgroundX = self.x + self.buttonWidth/2
  self.backgroundWidth = self.width - self.buttonWidth
  
  self.buttonScale = def.buttonScale or 1
  self.buttonHeight = self.buttonScale * self.height
  self.buttonY = self.y + (self.height - self.buttonHeight)/2
  
  self.backgroundScale = def.backgroundScale or 0.5
  self.backgroundHeight = self.backgroundScale * self.height
  self.backgroundY = self.y + (self.height - self.backgroundHeight)/2
  
  self.offset = def.offset or 10
  
  self.buttonShadow = false
  
  --self.iconNumber0 = self.iconNumber
  --self.onClick = def.onClick or function() end
  --self.onHover = def.onClick or function() end

end

--[[
function Slider:mouseIsOver(xMouse, yMouse)
    return (xMouse > self.x and xMouse < self.x + 10*self.scale and yMouse > self.y and yMouse < self.y + 10*self.scale)
end
]]

function Slider:mouseIsOverButton(xMouse, yMouse)
    return (xMouse > self.buttonX and xMouse < self.buttonX + self.buttonWidth and yMouse > self.buttonY and yMouse < self.buttonY + self.buttonHeight)
end


function Slider:render()
  --[[
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(gTextures['icons'], gFrames['icons'][self.iconNumber], self.x, self.y, 0, self.scale, self.scale)
  ]]
  love.graphics.setColor(self.boldColorBackground)
  love.graphics.rectangle('fill', self.backgroundX, self.backgroundY, self.backgroundWidth, self.backgroundHeight)
  love.graphics.setColor(self.colorBackground)
  love.graphics.rectangle('fill', self.backgroundX + self.offset, self.backgroundY + self.offset, self.backgroundWidth - 2*self.offset, self.backgroundHeight - 2*self.offset)
  
  love.graphics.setColor(self.boldColorButton)
  love.graphics.rectangle('fill', self.buttonX, self.buttonY, self.buttonWidth, self.buttonHeight)
  love.graphics.setColor(self.colorButton)
  love.graphics.rectangle('fill', self.buttonX + self.offset, self.buttonY + self.offset, self.buttonWidth - 2*self.offset, self.buttonHeight - 2*self.offset)
  if self.buttonShadow then
    love.graphics.setColor(0, 0, 0, 0.2)
    love.graphics.rectangle('fill', self.buttonX, self.buttonY, self.buttonWidth, self.buttonHeight)
  end
  
  --love.graphics.print(self.value, self.x + self.width, self.y)
  
  
end