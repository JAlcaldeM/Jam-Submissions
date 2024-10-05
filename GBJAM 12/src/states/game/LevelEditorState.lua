LevelEditorState = Class{__includes = BaseState}

function LevelEditorState:init(def)
  self.type = 'LevelEditor'
  
  self.emptyTileNumber = 29 --water1
  
  local filePath = "map.txt"
  self:loadMap(filePath)
  
  self.moveTimer = 0
  self.moveTimerMax = 0.05
  self.moveMargin = 1--math.floor(0.1*VIRTUAL_WIDTH)
  
  self.xTileOffset = 0
  self.yTileOffset = 0
  
  self.marginSize = 40
  self.changeTile = false
  self.changeTileScale = 4
  self.nCols = math.floor((VIRTUAL_WIDTH/tilesize)/self.changeTileScale)
  self.maxPencilTile = #gFrames['spritesground']
  
  self.pencilTile = 15
  
  self.drawAllowed = true
  
  self.moveWithMargin = false
  

end



function LevelEditorState:loadMap(filePath)
    if love.filesystem.getInfo(filePath) then
        local mapData = love.filesystem.read(filePath)
        self.map = convertTextToMap(mapData)
        -- if loaded map is smaller than parameters, addstiles to fill    THE EDITOR PROBABLY CRASHES IF THE MAP IS BIGGER!!
        for x = 1, nColsMap do
          if not self.map[x] then
            self.map[x] = {}
          end
          for y = 1, nRowsMap do
            if not self.map[x][y] then
              self.map[x][y] = self.emptyTileNumber
            end
          end
        end
        
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
            col[y] = self.emptyTileNumber
        end
        self.map[x] = col
    end
end

function LevelEditorState:saveMap(filePath)
    local mapData = convertMapToText(self.map)
    love.filesystem.write(filePath, mapData)
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
      local row = 1 + math.floor(y / (tilesize * self.changeTileScale))
      local col = math.min(self.nCols, 1 + math.floor(x / (tilesize * self.changeTileScale)))
      self.pencilTile = col + self.nCols * (row - 1)
      if self.pencilTile <= self.maxPencilTile then
        self.changeTile = false
        self.drawAllowed = false
        Timer.after(0.5, function() self.drawAllowed = true end)
      end
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
    
    local currentRow = 1 + math.floor(y/tilesize) - self.yTileOffset
    local currentCol = 1 + math.floor(x/tilesize) - self.xTileOffset
    self.currentCol = currentCol
    self.currentRow = currentRow
    if love.mouse.isDown(1) and self.drawAllowed and (not self.overMargin) and self.map[currentCol] and self.map[currentCol][currentRow] then
      if self.map[currentCol][currentRow] ~= self.pencilTile then
        self.map[currentCol][currentRow] = self.pencilTile
        gSounds['plop']:seek(0.776)
        gSounds['plop']:play()
      end
    end
    
    
    
    
    
    if self.overMargin and (not self.changeTile) and love.mouse.wasPressed(1) then
      self.changeTile = true
    end
    
  end
  
  
  if love.keyboard.wasPressed('z') then
    self:saveMap("map.txt")
  end
  
  
  
  
  

end



function LevelEditorState:render()
  
  
  love.graphics.setColor(colors.white)
  
  --for x, column in ipairs(self.map) do
  local xStart = math.max(1, -self.xTileOffset)
  local xEnd = math.min(nColsMap, nColsMapScreen - self.xTileOffset)
  for x = xStart, xEnd do
    --for y, tile in ipairs(column) do
    local column = self.map[x]
    local yStart = math.max(1, -self.yTileOffset)
    local yEnd = math.min(nRowsMap, nRowsMapScreen - self.yTileOffset)
    for y = yStart, yEnd do
      --[[
      print(xStart, xEnd, yStart, yEnd)
      print(x, y)
      ]]
      local tile = column[y]
      --local tileName = tile
      --local iconNumber = groundToSprite[tileName]
      local iconNumber = tile
      love.graphics.draw(gTextures['spritesground'], gFrames['spritesground'][iconNumber], (x - 1 + self.xTileOffset) * tilesize, (y - 1 + self.yTileOffset) * tilesize)
      --love.graphics.draw(gTextures['spritesground'], gFrames['spritesground'][iconNumber], (x - 1 + self.xTileOffset) * tilesize, (y - 1 + self.yTileOffset) * tilesize)
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
    local scale = self.changeTileScale
    local nRows = self.nCols
    for i = 1, self.maxPencilTile do
      local row = 1 + math.floor((i - 1)/nRows)
      local col = 1 + (i - 1) % nRows
      love.graphics.draw(gTextures['spritesground'], gFrames['spritesground'][i], (col - 1) * scale * tilesize, (row - 1) * scale * tilesize, 0, scale, scale)
    end
    
    
  end
  
  
  love.graphics.setColor(colors.black)
  love.graphics.rectangle('fill', 2, 18, 100, 34)
  love.graphics.setFont(gFonts['small'])
  love.graphics.setColor(colors.cyan)
  if self.currentRow and self.currentCol then
    love.graphics.print('Press Z to save map', 5, 20)
    love.graphics.print('X (currentCol): '..self.currentCol, 5, 30)
    love.graphics.print('Y (currentRow): '..self.currentRow, 5, 40)
  end
  
end
