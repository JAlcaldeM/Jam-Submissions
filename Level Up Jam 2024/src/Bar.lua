Bar = Class{}

function Bar:init(def)
  self.worker = def.worker
  self.xDiff = def.xDiff
  self.yDiff = def.yDiff
  self.width = def.width
  self.height = def.height
  self.value = def.value
  self.maxValue = def.maxValue
  self.color = def.color or colors.white
  self.backgroundColor = def.backgroundColor or colors.transparent

end

function Bar:render()
  local x = self.worker.x + self.xDiff
  local y = self.worker.y + self.yDiff
  love.graphics.setColor(self.backgroundColor)
  love.graphics.rectangle('fill', x, y, self.width, self.height)
  love.graphics.setColor(self.color)
  love.graphics.rectangle('fill', x, y, self.width*self.value/self.maxValue, self.height)
  
end

