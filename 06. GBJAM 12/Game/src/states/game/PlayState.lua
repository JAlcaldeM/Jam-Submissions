PlayState = Class{__includes = BaseState}

function PlayState:init(def)
    self.type = 'Play'
    
    -- main parameters
    self.cheatMode = true
    self.interactOnBump = true
    self.startAnimation = true
    self.moveDelay = 0.15
    self.minute = 1 --1
    self.minuteMax = 750
    
    
    self.eruptionStarted = false
    
    self.nTilesView = 4
    self.lastLowerClockSize = 0
    --self:gainTool('axe')
    
    
    self.timePassing = true
    
    local definitiveMap = true
    
    if definitiveMap then
      self.map = {}
      for x, column in ipairs(map) do
        local newColumn = {}
        for y, tileNumber in ipairs(column) do
          table.insert(newColumn, tileNumber)
        end
        table.insert(self.map, newColumn)
      end
    else
      local mapData = love.filesystem.read('map.txt')
      self.map = convertTextToMap(mapData)
    end
    
    
    
    
    
    
    --self.map = importedMap
    nRows = #self.map[1]
    nCols = #self.map
    --print('nRows:', nRows, 'nCols:', nCols)
    self.prevMap = {}
    
    --self.canvas = love.graphics.newCanvas(VIRTUAL_WIDTH,VIRTUAL_HEIGHT)
    self.canvases = {}
    
    
    self.player = {
      x = 80,
      y = 80,
      spriteNumber = 17,
      direction = 'down',
      floating = false,
      hasMoved = false,
      isAlive = true,
      sandSinkLevel = 0,
      burning = false,
      fallHeight = 0,
      step = 1,
    }
    
    self.sandSinkLevelMax = 4
    
    self.xScreenChar = 5
    self.yScreenChar = 5
    
    
    self.npcs = {}
    --[[
    local npc1 = {x = 13, y = 5}
    for key, value in pairs(npcDefs['default']) do
      npc1[key] = value
    end
    table.insert(self.npcs, npc1)
    ]]
    local npcData = {
      --[[
      {x = 14, y = 6, type = 'default'},
      {x = 19, y = 11, type = 'weakEnemy'},
      ]]
      {x = 56, y = 51, type = 'strongEnemy'},
      {x = 70, y = 82, type = 'weakEnemy'},
      {x = 80, y = 64, type = 'gaia'},
      {x = 109, y = 83, type = 'bridgeGuy'},
      {x = 57, y = 63, type = 'desertGuy'},
      {x = 75, y = 82, type = 'combatGuy'},
      {x = 105, y = 46, type = 'techGuy'},
      {x = 98, y = 70, type = 'bombGuy'},
      {x = 81, y = 83, type = 'tutorialGuy'},
      {x = 110, y = 71, type = 'uselessGuy'},
      {x = 42, y = 73, type = 'hurtGuy'},
    }
    
    --SPAWN NPCS
    
    for _, npcInfo in pairs(npcData) do
      local npc = {x = npcInfo.x, y = npcInfo.y, origin = {x = npcInfo.x, y = npcInfo.y},}
      for key, value in pairs(npcDefs[npcInfo.type]) do
        npc[key] = value
      end
      table.insert(self.npcs, npc)
    end
    --[[]]
    
    
    
    self.frozenTiles = {}
    --sample for frozenTile = {x = 0, y = 0, tileNumber = 0}
    
    
    self.tools = {}
    
    --SPAWN TOOLS
    self:spawnTool('wood', 105, 65)
    self:spawnTool('wood', 118, 65)
    self:spawnTool('wood', 98, 55)
    self:spawnTool('water', 29, 51)
    self:spawnTool('water', 32, 51)
    self:spawnTool('water', 29, 48)
    self:spawnTool('water', 32, 48)
    self:spawnTool('miniTree', 115, 49)
    self:spawnTool('bombs', 99, 70)
    self:spawnTool('floater', 120, 76)
    self:spawnTool('teleporter', 34, 70)
    self:spawnTool('freezer', 108, 30)

    
    self.directionSpriteOffset = {
      down = 0,
      left = 10,
      up = 20,
      right = 30,
      }
    
    self.moveTimer = 0
    self.moveAllowed = true
    self.moveKeys = moveKeys
    
    
    
    --def.skipIceAnimation = true
    
    
    
    if self.startAnimation then
      --self.renderCanvasPosition = 0
      self.allowInput = false
      self.skipIceAnimation = def.skipIceAnimation or false
      self.slowAnimation = def.slowAnimation or false
      local durationMult = 1
      if self.slowAnimation then
        durationMult = 2
      end
      
      --[[
      if self.skipIceAnimation then
        self.animationFrames = {gTextures['golemSleep'],gTextures['golemAwake1']}
        self.animationTimes = {0, 2}
      else
        self.animationFrames = {gTextures['ice1'],gTextures['ice2'],gTextures['ice3'],gTextures['golemSleep'],gTextures['golemAwake1']}
        self.animationTimes = {0, 1, 1, 1, 2} --delay until the corresponding image appears
      end
      ]]
      self.animationFrames = {gTextures['ice1'],gTextures['ice2'],gTextures['ice3'],gTextures['golemSleep'],gTextures['golemAwake1']}
      self.animationTimes = {0, 0.5*durationMult, 0.5*durationMult, 0.5*durationMult, 0.5*durationMult} --delay until the corresponding image appears
      local startDelay = 0*durationMult -- time between the game loads and the first delay (0) appears
      local currentAnimationDelay = 0*durationMult-- stores the total time that has passed for the next frames
      self.animationFrame = gTextures['blackScreen']
      for i, frame in ipairs(self.animationFrames) do
        
        local animationTime = self.animationTimes[i]
        local totalTime = startDelay + currentAnimationDelay + animationTime
        currentAnimationDelay = currentAnimationDelay + animationTime
        Timer.after(totalTime, function()
            defPlay('defrost', i)
            self.animationFrame = frame
          end)
      end
      local lastImageDelay = 1*durationMult
      local blackDelay = 1*durationMult
      --[[
      if self.skipIceAnimation then
        blackDelay = 1*durationMult
      end
      ]]
      Timer.after(currentAnimationDelay + lastImageDelay, function()
          self.animationFrame = gTextures['blackScreen']
        end)
      Timer.after(currentAnimationDelay + lastImageDelay + blackDelay, function()
          --self.renderCanvasPosition = 1
          self.animationFrame = nil
          self.allowInput = true
          defPlay('timeLoopStarts')
        end)
      
    else
      self.allowInput = true
    end
    
    self:updateTileOffset()
    self:recalculateCanvas()
    
    
    self.reverseTime = false
    self.revTimer = 0
    self.revDelay = 1
    self.revDelayMult = 0.85
    self.renderCanvasPosition = 1
    
    self.nTriggerOn = 0
    
    self.isGaiaAlive = true
    self.isWoundedHealed = false
    

end

function PlayState:triggerOn()
  local activatedTilesX = {68, 69, 70, 71, 72, 73}
  local activatedTilesY1 = 37
  local activatedTilesY2 = 38

  self.nTriggerOn = self.nTriggerOn + 1
  if self.nTriggerOn == 1 then
    for _, x in pairs(activatedTilesX) do
      self.map[x][activatedTilesY1] = 63 --blackbridge
    end
  elseif self.nTriggerOn == 2 then
    for _, x in pairs(activatedTilesX) do
      self.map[x][activatedTilesY2] = 63 --blackbridge
    end
  end
  
  
end






function PlayState:update(dt)
   
  
  if self.reverseTime then
    self.revTimer = self.revTimer + dt
    if self.revTimer >= self.revDelay then
      self.revTimer = 0
      local minTimeFrame = 0.01
      self.revDelay = math.max(minTimeFrame, self.revDelay * self.revDelayMult)
      self.renderCanvasPosition = self.renderCanvasPosition - 1
      defPlay('timeloopTemp')
      --defPlay('prang')
      if self.renderCanvasPosition <= 0 then
        self.reverseTime = false
        local newStateDelay = 1
        Timer.after(newStateDelay, function()
          gStateStack:pop()
          gStateStack:push(PlayState({skipIceAnimation = true}))
        end)
      end
    end
  end
  
  
  

  if not self.allowInput then
    return
  end
  
  
  
  local movCoords = {x = self.player.x, y = self.player.y}
  local checkMove = false
  
  --[[
  self.moveTimer = 0
    self.moveDelay = 0.5
    self.moveAllowed = true
    self.movekeys = {'w', 'a', 's', 'd', 'up', 'left', 'down', 'right'}
  ]]
  
  if self.moveAllowed then
    for _, key in pairs(self.moveKeys) do
      if love.keyboard.isDown(key) then
        checkMove = true
      end
    end
  else
    self.moveTimer = self.moveTimer + dt
    if self.moveTimer >= self.moveDelay then
      self.moveTimer = 0
      self.moveAllowed = true
    end
  end
  
  
  
  
  
  
  --[[
  if love.keyboard.wasPressed('w') or love.keyboard.isDown('up') then
    movCoords.y = movCoords.y - 1
    self.player.direction = 'up'
    checkMove = true
  elseif love.keyboard.wasPressed('a') or love.keyboard.isDown('left') then
    movCoords.x = movCoords.x - 1
    self.player.direction = 'left'
    checkMove = true
  elseif love.keyboard.wasPressed('s') or love.keyboard.isDown('down') then
    movCoords.y = movCoords.y + 1
    self.player.direction = 'down'
    checkMove = true
  elseif love.keyboard.wasPressed('d') or love.keyboard.isDown('right') then
    movCoords.x = movCoords.x + 1
    self.player.direction = 'right'
    checkMove = true
  end
  ]]
  
  --local hasInteracted = false
  if love.keyboard.wasPressed(aButton) or (love.keyboard.wasPressed(bButton)) then
      
    local lookCoords = {x = self.player.x, y = self.player.y}
    if self.player.direction == 'up' then
      lookCoords.y = lookCoords.y - 1
    elseif self.player.direction == 'left' then
      lookCoords.x = lookCoords.x - 1
    elseif self.player.direction == 'down' then
      lookCoords.y = lookCoords.y + 1
    elseif self.player.direction == 'right' then
      lookCoords.x = lookCoords.x + 1
    end
    
    if love.keyboard.wasPressed(aButton) then
      --hasInteracted = true
      local tileKey, tileData = numberToKeyData(self.map[lookCoords.x][lookCoords.y])
      local npc = searchNpc(lookCoords.x, lookCoords.y, self)
      local hasInteracted = false
      if npc and (npc.active and not npc.inactive) then
        npc:onInteract(lookCoords.x, lookCoords.y, self)
        npc.direction = directionSwap(self.player.direction)
        hasInteracted = true
      end
      if tileData.interactable then
        tileData.onInteract(lookCoords.x, lookCoords.y, self)
        hasInteracted = true
      end
      if not hasInteracted then
        defPlay('toolFailMini')
      else
        defPlay('ok')
      end
      
      
      
    elseif love.keyboard.wasPressed(bButton) then

      if self.tool and self.tool.charge >= self.tool.useCharge then
        if self.tool.useCharge == 0 then
          defPlay('toolFailMini')
        end
        self.tool.onUse(self, lookCoords)
        if self.tool then
          if not self.cheatMode then
            self.tool.charge = self.tool.charge - self.tool.useCharge
          end
          self.tool.justUsed = true
        end
      else
        defPlay('toolFailMini')
      end
    end

    self.turn = true
  end
  
  
  
  if checkMove then

    self.turn = true
    
    if love.keyboard.isDown('w') or love.keyboard.isDown('up') then
      movCoords.y = movCoords.y - 1
      self.player.direction = 'up'
    elseif love.keyboard.isDown('a') or love.keyboard.isDown('left') then
      movCoords.x = movCoords.x - 1
      self.player.direction = 'left'
    elseif love.keyboard.isDown('s') or love.keyboard.isDown('down') then
      movCoords.y = movCoords.y + 1
      self.player.direction = 'down'
    elseif love.keyboard.isDown('d') or love.keyboard.isDown('right') then
      movCoords.x = movCoords.x + 1
      self.player.direction = 'right'
    end
    
    local targetMapValue = self.map[movCoords.x][movCoords.y]
    local key = mapnumberToKey[targetMapValue]
    local tileData = tiledefs[key]
    
    local targetNpc
    for _, npc in pairs(self.npcs) do
      if npc.x == movCoords.x and npc.y == movCoords.y then
        targetNpc = npc
      end
    end
    
    local targetTool
    local targetToolIndex
    for i, tool in ipairs(self.tools) do
      if tool.x == movCoords.x and tool.y == movCoords.y then
        targetTool = tool
        targetToolIndex = i
      end
    end
    
    
    
    local function checkPickupTool()
      if targetTool and targetTool.pickable then
        if self.tool then
          self:depositTool(movCoords.x, movCoords.y)
        end
        self:pickupTool(targetTool, targetToolIndex)
      end
    end
    
    
    --self.player.hasMoved = false
    if targetNpc then
      -- interact with npc
      if self.interactOnBump and targetNpc.active and not targetNpc.inactive then
        --[[
        if npc and not npc.inactive then
        npc:onInteract(lookCoords.x, lookCoords.y, self)
        npc.direction = directionSwap(self.player.direction)
      end
      ]]
        targetNpc:onInteract(movCoords.x, movCoords.y, self)
        targetNpc.direction = directionSwap(self.player.direction)
      end
    elseif tileData.interactable then
      
      if self.interactOnBump then
        -- interaction logic
        tileData.onInteract(movCoords.x, movCoords.y, self)
      end
    elseif tileData.walkable or (self.player.floating and not tileData.solid) or self.cheatMode then
      self.player.hasMoved = true
      self:movePlayerTo(movCoords.x, movCoords.y, tileData)
    else
      -- bump sound
      defPlay('bump')
    end
    
    if (self.player.hasMoved and not self.tool) then-- or (self.interactOnBump and key == 'altar' )then
      checkPickupTool()
    end
    
    self.player.hasMoved = false
    
    self.moveAllowed = false
    
  end
  
  
  
  
  
  if self.turn then
    
    
    -- all npcs update
    self:npcUpdate()
    
    
    if self.timePassing then
      self.minute = self.minute + 1
      if self.minute >= self.minuteMax then
        -- VOLCAN HAPPENS
        self.timePassing = false
        self.eruptionStarted = true
        -- now GAIA turns tiles into active lava, and the central tile also becomes active
        if self.map[80][62] == 64 then --inactive lava
          self.map[80][62] = 34
        end
        
        defPlay('eruptionStarts')
      end
    end
    
    
    
    self:saveCurrentMap()
    --self.prevMap = copyTable(self.map)
    
    for x = 1, nCols do --
      local column = self.prevMap[x]--
      for y = 1, nRows do--
      --for y, tile in ipairs(column) do
        local tile = column[y]
        local iconNumber = tile
        local key = mapnumberToKey[iconNumber]
        local data = tiledefs[key]
        --print(tile, iconNumber, data, x, y, self)
        --print(x, y, tile, key)
        data.onTurn(x, y, self)
        if tile == 70 then
          print('hi')
        end
      end
    end
    
    if self.player.burned then
      self.player.burned = false
      self.player.burning = true
    end
    
    
    if self.tool then
      self.tool:onTurn(self)
      self.tool.justPicked = false
      self.tool.justUsed = false
    end
    
    for _, tool in pairs(self.tools) do
      if not tool.picked then
        tool:onGround(tool.x, tool.y, self)
      end
    end
    
    
    if self.eruptionStarted then
      defPlay('lava')
    end
    
    
    
    -- everything (tools, npc) checks if it is in lave, if true is destroyed
    for i = #self.tools, 1, -1 do
      local tool = self.tools[i]
      if self.map[tool.x][tool.y] == 34 then
        self:spawnTool('flames', tool.x, tool.y)
        if isVisible(tool, self) then
          defPlay('flames')
        end
        table.remove(self.tools, i)
      end
    end
    for i = #self.npcs, 1, -1 do
      local npc = self.npcs[i]
      if self.map[npc.x][npc.y] == 34 then
        if npc.fireResistant then
          npc.fireResistant = false
          npc.burning = true
          if isVisible(npc, self) then
            defPlay('fireShort')
          end
        else
          table.remove(self.npcs, i)
          if isVisible(npc, self) then
            defPlay('fireDeath')
          end
        end
      end
    end
    
    
    
    self:updateTileOffset()
    self:recalculateCanvas()
    
    if self.map[80][62] ~= 34 and self.map[80][62] ~= 64 then

      if self.isWoundedHealed then
        gStateStack:push(EndState({chosenEnding = 4}))
      else
        gStateStack:push(EndState({chosenEnding = 3}))
      end
      
      
    end
    
  end
  
  
  
  self.turn = false
  self.notFirstFrame = true
end


function PlayState:render()
  
  love.graphics.setColor(colors.white)
  --love.graphics.draw(self.canvas)
  if self.renderCanvasPosition > 0 then
    love.graphics.draw(self.canvases[self.renderCanvasPosition])
  end
  
  if self.animationFrame then
    love.graphics.draw(self.animationFrame)
  end
  
  
  
  
  
end




function PlayState:saveCurrentMap()
  
  self.prevMap = {}
  for x, column in ipairs(self.map) do
    self.prevMap[x] = {}
    for y, tile in ipairs(column) do
      self.prevMap[x][y] = tile
    end
  end
  
end




function PlayState:updateTileOffset()
  self.xTileOffset = -self.player.x --+ (self.xScreenChar - 1)
  self.yTileOffset = -self.player.y --+ (self.yScreenChar - 1)
end


function PlayState:recalculateCanvas()
  
  local newCanvas = love.graphics.newCanvas(VIRTUAL_WIDTH,VIRTUAL_HEIGHT)
  love.graphics.setCanvas({newCanvas, stencil=true})
  
  love.graphics.clear()

  love.graphics.setColor(colors.white)
  local xStart = math.max(1, self.player.x - self.nTilesView)   --1
  local xEnd = math.min(#self.map, self.player.x + self.nTilesView)  -- #self.map
  for x = xStart, xEnd do
    local column = self.map[x]
    local yStart = math.max(1, self.player.y - self.nTilesView) --1
    local yEnd = math.min(#column, self.player.y + self.nTilesView) --#column
    for y = yStart, yEnd do
      local tile = column[y]
      local iconNumber = tile
      love.graphics.draw(gTextures['spritesground'], gFrames['spritesground'][iconNumber], (x + self.xTileOffset + self.xScreenChar - 1) * tilesize, (y + self.yTileOffset + self.yScreenChar - 1) * tilesize)
    end
  end
  
  
  
  -- RENDER NPCS
  for _, npc in pairs(self.npcs) do
    love.graphics.setColor(colors.white)
    local xNpc = tilesize*(npc.x - 1 + self.xTileOffset + 1 + self.xScreenChar - 1)
    local yNpc = tilesize*(npc.y - 1 + self.yTileOffset + 1 + self.yScreenChar - 1)
    local icon = npc.spriteNumber + self.directionSpriteOffset[npc.direction]
    love.graphics.draw(gTextures['sprites16'], gFrames['sprites16'][icon], xNpc, yNpc)
    if npc.inactive then
      love.graphics.draw(gTextures['sprites16'], gFrames['sprites16'][npc.inactive], xNpc, yNpc)
    end
    if npc.burning then
      love.graphics.draw(gTextures['sprites16'], gFrames['sprites16'][3], xNpc, yNpc)
    end
  end
  
  
  -- RENDER TOOLS
  for _, tool in pairs(self.tools) do
    love.graphics.setColor(colors.white)
    local xTool = tilesize*(tool.x - 1 + self.xTileOffset + 1 + self.xScreenChar - 1) + 3
    local yTool = tilesize*(tool.y - 1 + self.yTileOffset + 1 + self.yScreenChar - 1) + 3
    local spriteNumber = toolDefs[tool.name].iconNumber
    love.graphics.draw(gTextures['sprites10'], gFrames['sprites10'][spriteNumber], xTool, yTool)
  end
  
  
  -- RENDER MAIN CHARACTER
  if self.player.isAlive then
    love.graphics.setColor(colors.white)
    --love.graphics.rectangle('fill', tilesize*(self.xScreenChar - 1), tilesize*(self.yScreenChar - 1), tilesize, tilesize)
    local xChar = tilesize*(self.player.x - 1 + self.xTileOffset + 1 + self.xScreenChar - 1)
    local yChar = tilesize*(self.player.y - 1 + self.yTileOffset + 1 + self.yScreenChar - 1)
    if self.player.floating then
      yChar = yChar - 4
      local floatOffsetItem = 10
      local itemNumber = toolDefs.floater.iconNumber
      love.graphics.draw(gTextures['sprites10'], gFrames['sprites10'][itemNumber], xChar + 3, yChar + floatOffsetItem)
    elseif self.player.sandSinkLevel > 0 then
      local sandSinkOffset = math.floor(self.player.sandSinkLevel * (tilesize/self.sandSinkLevelMax))
      local function stencilFunction()
        love.graphics.rectangle("fill", xChar, yChar + tilesize - sandSinkOffset/2, tilesize, tilesize)
      end
      love.graphics.stencil(stencilFunction, "replace", 1)
      love.graphics.setStencilTest("equal", 0)
      yChar = yChar + sandSinkOffset/2
    end
    local icon = self.player.spriteNumber + self.directionSpriteOffset[self.player.direction] + self.player.fallHeight
    love.graphics.draw(gTextures['sprites16'], gFrames['sprites16'][icon], xChar, yChar)
    if self.player.burning then
      love.graphics.draw(gTextures['sprites16'], gFrames['sprites16'][3], xChar, yChar)
    end
    love.graphics.setStencilTest()
  end
  
  


-- RENDER UI
  local xUI = VIRTUAL_WIDTH - tilesize
  local yUI = 0
  -- background
  love.graphics.setColor(palette[4])
  love.graphics.rectangle('fill', xUI, yUI, tilesize, VIRTUAL_WIDTH)
  -- tool icon and bar
  local tool = self.tool
  if tool then
    --local info = self.toolInfo
    --icon
    love.graphics.setColor(palette[2])
    love.graphics.rectangle('fill', xUI, yUI, tilesize, tilesize)
    local toolMargin = 3
    love.graphics.setColor(colors.white)
    --love.graphics.rectangle('fill', xUI + toolMargin, yUI + toolMargin, 10, 10)
    love.graphics.draw(gTextures['sprites10'], gFrames['sprites10'][tool.iconNumber], xUI + toolMargin, yUI + toolMargin)
    --bar
    local chargeBarSize = tool.charge
    local useBarSize = math.min(tool.useCharge,chargeBarSize)
    local barsY = 18
    love.graphics.setColor(palette[1])
    love.graphics.rectangle('fill', xUI, barsY, tilesize, chargeBarSize)
    love.graphics.setColor(palette[2])
    love.graphics.rectangle('fill', xUI, barsY, tilesize, useBarSize)
  end

  -- sand parameters
  local upperExtraTime = 11
  local clockY1 = 70
  local clockY2 = 138
  local clockMargin = 3
  local clockMaxSize = 33
  local upperClockSize = math.ceil(clockMaxSize * (1 - self.minute/self.minuteMax))
  local lowerClockSize = math.max(0, clockMaxSize - upperClockSize - upperExtraTime)
  lowerClockSize = math.ceil(lowerClockSize + upperExtraTime*(lowerClockSize/(clockMaxSize-upperExtraTime)))
  if lowerClockSize - self.lastLowerClockSize > 1 then
    lowerClockSize = self.lastLowerClockSize + 1
  end
  self.lastLowerClockSize = lowerClockSize
  -- falling sand
  local sandfallX = xUI + 7
  local sandfallY = clockY1 + 4 + math.min(33, self.minute)
  love.graphics.setColor(colors.white)
  if self.minute % 2 == 0 then
    love.graphics.draw(gTextures['sandfall'], sandfallX, sandfallY)
  else
    local width = 2
    love.graphics.draw(gTextures['sandfall'], sandfallX + width, sandfallY, 0, -1, 1)
  end
  --upper clock sand
  love.graphics.setColor(palette[1])
  love.graphics.rectangle('fill', xUI + clockMargin, clockY1 + clockMargin + (clockMaxSize - upperClockSize), 10, upperClockSize)
  -- lower clock sand
  love.graphics.setColor(palette[1])
  love.graphics.rectangle('fill', xUI + clockMargin, clockY2 + clockMargin - lowerClockSize, 10, lowerClockSize)
  -- UI itself
  love.graphics.setColor(colors.white)
  love.graphics.draw(gTextures['UI'], xUI, yUI)
  
  
  
  love.graphics.setCanvas()
  
  self.canvas = newCanvas
  table.insert(self.canvases, self.canvas)
  self.renderCanvasPosition = #self.canvases

end

function PlayState:spawnTool(name, x, y)
  
  local info = toolDefs[name]
  
  local tool = {
    name = name,
    x = x,
    y = y,
  }
  
  for key, value in pairs(info) do
    tool[key] = value
  end
  
  if x and y then
    table.insert(self.tools, tool)
    return tool, #self.tools
  else
    return tool
  end
  
  
  
end

function PlayState:pickupTool(tool, index)
  tool.picked = true
  tool.justPicked = true
  self.tool = tool
  table.remove(self.tools, index)
  defPlay('getTool')
end

function PlayState:depositTool(x, y)
  local tool = self.tool
  tool.picked = false
  tool.x = x
  tool.y = y
  table.insert(self.tools, tool)
  if tool.name == 'floater' then
    self.player.floating = false
  end
  self.tool = nil
  defPlay('loseTool')
end

function PlayState:removeTool(oldTool) -- if missing the tool index
  for i = #self.tools, 1, -1 do
    local tool = self.tools[i]
    if tool == oldTool then
      table.remove(self.tools, i)
    end
  end
end

function PlayState:movePlayerTo(x, y, tileData)
  self.player.x = x
  self.player.y = y
  if self.player.floating then
    return
  end
  --if self.player.hasMoved then
    tileData.onEnter(x, y, self)
    
  --end
  if tileData.sandSink then
    self.player.sandSinkLevel = math.min(self.sandSinkLevelMax, self.player.sandSinkLevel + 1)
    if self.player.sandSinkLevel >= self.sandSinkLevelMax then
      self:triggerPlayerDeath('sunk')
      defPlay('sandSink')
    end
  else
    self.player.sandSinkLevel = 0
  end
  
  defPlay(tileData.stepSound, self.player.step)
  if self.player.step == 1 then
    self.player.step = 2
  else
    self.player.step = 1
  end
  
  
end


function PlayState:triggerPlayerDeath(cause)
  if not self.cheatMode then
    self.allowInput = false
    if cause ~= 'restart' then
      self.player.isAlive = false
    end
    triggerPlayerDeathAnimation(self, cause)
  end
end

function PlayState:npcUpdate()
  
  for _, npc in pairs(self.npcs) do
    npc:onTurn(self)
  end
  
  
end

