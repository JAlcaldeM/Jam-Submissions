LevelEditorState = Class{__includes = BaseState}

function LevelEditorState:init(def)
  self.type = 'LevelEditor'
  
  --[[
  self.map = {}
  for x = 1, nColsMap do
    local col = {}
    for y = 1, nRowsMap do
      col[y] = math.random(30)--1--'lgrass1'
    end
    self.map[x] = col
  end
  ]]
  
  local filePath = "map.txt"
  self:loadMap(filePath)
  
  self.moveTimer = 0
  self.moveTimerMax = 0.05
  self.moveMargin = 1--math.floor(0.1*VIRTUAL_WIDTH)
  
  self.xTileOffset = 0
  self.yTileOffset = 0
  
  self.marginSize = 40
  self.changeTile = false
  
  self.pencilTile = 16
  
  self.drawAllowed = true
  
  self.moveWithMargin = false

end





function LevelEditorState:loadMap(filePath)
    if love.filesystem.getInfo(filePath) then
        local mapData = love.filesystem.read(filePath)
        self.map = self:convertTextToMap(mapData)
    else
        self:generateMap()
        self:saveMap(filePath)
    end
end

function LevelEditorState:generateMap()
    self.map = {}
    for x = 1, nColsMap do
        local col = {}
        for y = 1, nRowsMap do
            col[y] = math.random(30)
        end
        self.map[x] = col
    end
end

function LevelEditorState:convertMapToText()
    local lines = {}
    for x = 1, nColsMap do
        local col = {}
        for y = 1, nRowsMap do
            table.insert(col, self.map[x][y])
        end
        table.insert(lines, "{" .. table.concat(col, ",") .. "},")
    end
    return table.concat(lines, "\n")
end

function LevelEditorState:saveMap(filePath)
    local mapData = self:convertMapToText()
    love.filesystem.write(filePath, mapData)
end

--[[
function LevelEditorState:convertTextToMap(data)
    local map = {}
    local lines = string.split(data, "\n")
    for x = 1, #lines do
        local col = {}
        local values = string.split(lines[x], ",")
        for y = 1, #values do
            col[y] = tonumber(values[y])
        end
        map[x] = col
    end
    return map
end
]]

function LevelEditorState:convertTextToMap(data)
    local map = {}
    local lines = string.gmatch(data, "{(.-)},")

    for line in lines do
        local col = {}
        for value in string.gmatch(line, "%d+") do
            table.insert(col, tonumber(value))
        end
        table.insert(map, col)
    end

    return map
end









function LevelEditorState:update(dt)
  
  local x, y = push:toGame(love.mouse.getPosition())
  if x == nil then x = VIRTUAL_WIDTH/2 end
  if y == nil then y = VIRTUAL_HEIGHT/2 end
  
  local moveUp, moveDown, moveRight, moveLeft
  
  if x >= VIRTUAL_WIDTH - self.marginSize and y <= self.marginSize then
    self.overMargin = true
  else
    self.overMargin = false
  end
  
  
  if self.changeTile then
    
    if love.mouse.wasPressed(1) then
      self.changeTile = false
      local row = 1 + math.floor(y / tilesize)
      local col = 1 + math.floor(x / tilesize)
      self.pencilTile = col + VIRTUAL_WIDTH / tilesize * (row - 1)
      self.drawAllowed = false
      Timer.after(0.5, function() self.drawAllowed = true end)
    end
    
    
  else
    
    
    if self.moveWithMargin then
      if x < self.moveMargin then
        moveLeft = true
      elseif x > VIRTUAL_WIDTH - self.moveMargin then
        moveRight = true
      end
      if y < self.moveMargin then
        moveUp = true
      elseif y > VIRTUAL_HEIGHT - self.moveMargin then
        moveDown = true
      end
    else
      if love.keyboard.isDown('w') or love.keyboard.isDown('up') then
        moveUp = true
      end
      if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
        moveLeft = true
      end
      if love.keyboard.isDown('s') or love.keyboard.isDown('down') then
        moveDown = true
      end
      if love.keyboard.isDown('d') or love.keyboard.isDown('right') then
        moveRight = true
      end
    end
    
    
    
    
    if (not self.overMargin) and (moveLeft or moveRight or moveUp or moveDown)  then
      self.moveTimer = self.moveTimer + dt
      if self.moveTimer >= self.moveTimerMax then
        self.moveTimer = 0
        if moveLeft then
          self.xTileOffset = self.xTileOffset + 1
        elseif moveRight then
          self.xTileOffset = self.xTileOffset - 1
        end
        if moveUp then
          self.yTileOffset = self.yTileOffset + 1
        elseif moveDown then
          self.yTileOffset = self.yTileOffset - 1
        end
      end
    else
      self.moveTimer = 0
    end
    
    local currentCol = 1 + math.floor(y/tilesize) - self.yTileOffset
    local currentRow = 1 + math.floor(x/tilesize) - self.xTileOffset
    if love.mouse.isDown(1) and self.drawAllowed and (not self.overMargin) and self.map[currentRow] and self.map[currentRow][currentCol] then
      if self.map[currentRow][currentCol] ~= self.pencilTile then
        self.map[currentRow][currentCol] = self.pencilTile
        gSounds['plop']:seek(0.776)
        gSounds['plop']:play()
      end
    end
    
    
    
    
    
    if self.overMargin and (not self.changeTile) and love.mouse.wasPressed(1) then
      self.changeTile = true
    end
    
  end
  
  
  if love.keyboard.wasPressed('s') then
    self:saveMap("map.txt")
  end
  
  
  
  
  

end



function LevelEditorState:render()
  
  love.graphics.setColor(colors.white)
  for x, column in ipairs(self.map) do
    for y, tile in ipairs(column) do
      --local tileName = tile
      --local iconNumber = groundToSprite[tileName]
      local iconNumber = tile
      love.graphics.draw(gTextures['spritesground'], gFrames['spritesground'][iconNumber], (x - 1 + self.xTileOffset) * tilesize, (y - 1 + self.yTileOffset) * tilesize)
    end
  end
  
  
  love.graphics.rectangle('fill', VIRTUAL_WIDTH - self.marginSize, 0, self.marginSize, self.marginSize)
  love.graphics.draw(gTextures['spritesground'], gFrames['spritesground'][self.pencilTile], VIRTUAL_WIDTH - self.marginSize + 4, 4, 0, 2, 2)
  
  if self.overMargin then
    love.graphics.setColor(colors.shadow)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - self.marginSize, 0, self.marginSize, self.marginSize)
  end
  

  if self.changeTile then
    love.graphics.setColor(colors.black)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    love.graphics.setColor(colors.white)
    local nRows = VIRTUAL_WIDTH / tilesize
    for i = 1, 60 do
      local row = 1 + math.floor((i - 1)/nRows)
      local col = 1 + (i - 1) % nRows
      love.graphics.draw(gTextures['spritesground'], gFrames['spritesground'][i], (col - 1) * tilesize, (row - 1) * tilesize)
    end
    
    
  end

  
  
end
