


toolList = {'axe', 'wood', 'bombs', 'bomb', 'miniTree', 'water', 'fruits', 'floater', 'teleporter', 'freezer', 'recharger'}

toolDefs = { -- THE MAX CHARGE FOR ALL ITEMS IS 50
  
  axe = {
    iconNumber = 1,
    charge = 25,
    useCharge = 5,
    onUse = function(state, lookCoords)
      local x, y = lookCoords.x, lookCoords.y
      --[[
      local lookTileNumber = state.map[x][y]
      local lookTileKey = mapnumberToKey[lookTileNumber]
      local lookTileData = tiledefs[lookTileKey]
      ]]
      local tileKey, tileData = numberToKeyData(state.map[x][y])
      if tileData.axeDestructible then
        tileData.onAxeDestruction(x, y, state)
        defPlay('axe')
      end
      local npc, index = searchNpc(x, y, state)
      if npc and not npc.damageResistant then
        npc.onDeath(x, y, state)
        table.remove(state.npcs, index)
        state.map[x][y] = 58 --undefinedGroundPieces
        defPlay('axe')
      end
    end,
    },
    
  wood = {
    iconNumber = 2,
    rechargable = false,
  },
  
  flames = {
    iconNumber = 25,
    pickable = false,
    onGround = function(tool, x, y, state)
      state:removeTool(tool)
      if isVisible(tool, state) then
        defPlay('flames')
      end
    end
    
  },
  
  water = {
    iconNumber = 4,
    charge = 15,
    useCharge = 5,
    onUse = function(state, coords)
      local tool = state.tool
      local tileNumber = state.map[coords.x][coords.y]
      --if mapnumberToKey[tileNumber] == 'fruitTree' then
      local waterUsed = false
      
      local tileKey, tileData = numberToKeyData(tileNumber)
      if tileData.walkable and not tileData.lavaResistant then
        state.map[coords.x][coords.y] = 48 --garden
        waterUsed = true
      end
      
      
      for i, tool in ipairs(state.tools) do
        if tool.name == 'miniTree' and tool.planted and tool.x == coords.x and tool.y == coords.y then
          local plant = tool
          plant.size = plant.sizeMax
          plant:onGround(coords.x, coords.y, state)
          --state.tool = nil
          defPlay('useWater')
          defPlay('missionComplete')
          waterUsed = true
          return
        end
      end
      local npc = searchNpc(coords.x, coords.y, state)
      if npc and npc.behavior then
        npc.active = false
        defPlay('useWater')
        if npc.gaia then
          npc.spriteNumber = 52
          state.isGaiaAlive = false
          npc.active = false
          npc.damageResistant = false
        else
          local tileOffset = state.directionSpriteOffset[npc.direction]
          npc.inactive = 53 + tileOffset
          waterUsed = true
        end
      end
      if not waterUsed then
        defPlay('toolFail')
      end
    end,
  },
  
  fruits = {
    iconNumber = 5,
  },
  
  miniTree = {
    iconNumber = 3,
    size = 0,
    sizeMax = 100,
    planted = false,
    rechargable = false,
    onUse = function(state, coords)
      local tileNumber = state.map[coords.x][coords.y]
      if mapnumberToKey[tileNumber] == 'garden' then
        state.tool.planted = true
        state.tool.pickable = false
        state:depositTool(coords.x, coords.y)
        defPlay('missionComplete')
      else
        defPlay('toolFail')
      end
    end,
    onGround = function(tool, x, y, state)
      if tool.planted then
        tool.size = tool.size + 1
        if tool.size >= tool.sizeMax then
          state.map[x][y] = 51 --maxiTree
          state:removeTool(tool)
        end
      end
      
    end,
  },
  
  bombs = {
    iconNumber = 6,
    charge = 20,
    useCharge = 10,
    consumible = true,
    onUse = function(state, coords)
      state:spawnTool('bomb', coords.x, coords.y)
      defPlay('putBomb')
    end,
  },
  
  bomb = {
    iconNumber = 23,
    pickable = false,
    timer = 2,
    onGround = function(tool, x, y, state)
      tool.timer = tool.timer - 1
      if tool.timer <= 0 then
        -- bomb explodes, kills everything in adjacent tiles and turn them into ruins
        state:removeTool(tool)
        --[[
        local tileNumber = state.map[x][y]
        local tileKey = mapnumberToKey[tileNumber]
        local tileData = tiledefs[tileKey]
        ]]
        local tileKey, tileData = numberToKeyData(state.map[x][y])
        
        defPlay('smallExplosions', 1)
        
        local npc, index = searchNpc(x, y, state)
        if npc and not npc.damageResistant then
          npc.onDeath(x, y, state)
          table.remove(state.npcs, index)
          defPlay('smallExplosions', 2)
        end
        
        if x == state.player.x and y == state.player.y then
          state:triggerPlayerDeath('bomb')
          defPlay('smallExplosions', 2)
        end
        
        
        if tileData.bombProtected then
          return
        end
        
        if tileData.solid then
          state.map[x][y] = 49 --crater
        else
          state.map[x][y] = 56 --emptyCrater
        end
        
        if npc then
          state.map[x][y] = 58 -- undefined ground pieces
        end
        
        
        
      end
    end,
  },
  
  floater = {
    iconNumber = 7,
    charge = 25,
    useCharge = 0,
    useChargeTurn = 5,
    onUse = function(state, coords)
      if state.tool.charge > 0 and not state.player.burning then
        state.player.floating = not state.player.floating
        if state.player.floating then
          defPlay('hover', 1)
        else
          defPlay('hover', 3)
        end
      end
    end,
    onTurn = function(tool, state)
      if state.player.floating and (not state.tool.justUsed) then
        if not state.cheatMode then
          state.tool.charge = math.max(0, state.tool.charge - tool.useChargeTurn)
        end
        defPlay('hover', 2)
        if state.tool.charge <= 0 then
          state.player.floating = false
          defPlay('hover', 3)
          local tileKey, tileData = numberToKeyData(state.map[state.player.x][state.player.y])
          if tileData.triggerEnterOnFall then
            tileData.onEnter(state.player.x, state.player.y, state)
          end
          
          
        end
      end
    end,
      
  },
  
  teleporter = {
    iconNumber = 8,
    charge = 25,
    useCharge = 5,
    onUse = function(state, coords)
      local player = state.player
      local xDiff = coords.x - player.x
      local yDiff = coords.y - player.y
      local travelDistance = 3
      local teleportX = player.x + xDiff*travelDistance
      local teleportY = player.y + yDiff*travelDistance
      local tileKey, tileData = numberToKeyData(state.map[teleportX][teleportY])
      if tileData.walkable then
        state:movePlayerTo(teleportX, teleportY, tileData)
        defPlay('tool3')
      else
        defPlay('toolFail')
      end
    end,
  },
  
  
  freezer = {
    iconNumber = 9,
    charge = 25,
    useCharge = 5,
    onUse = function(state, coords)
      local tileNumber = state.map[coords.x][coords.y]
      local tileKey, tileData = numberToKeyData(tileNumber)
      
      local npc, index = searchNpc(coords.x, coords.y, state)

      if npc then
        --npc.onDeath(x, y, state)
        if npc.gaia then
          state.isGaiaAlive = false
        end
        table.remove(state.npcs, index)
      end
      
      if tileData.iceProtected then
        defPlay('toolFail')
        return
      end
      if tileData.solid or npc then
        state.map[coords.x][coords.y] = 55 --iceSolid
      else
        state.map[coords.x][coords.y] = 53 --ice1
      end
      defPlay('iceTool')
      table.insert(state.frozenTiles, {x = coords.x, y = coords.y, tileNumber = tileNumber})
    end,
    
    },
  
  --[[
  recharger = {
    iconNumber = 10,
    pickable = false,
    
    
    }
    ]]
}
  
  
local defaultToolSettings = {
  pickable = true,
  onUse = function(state, coords) end,
  onTurn = function(tool, state) end,
  onGround = function(tool, x, y, state) end,
  charge = 0,
  useCharge = 0,
  rechargable = true,
  consumible = false,
  
}

for _, toolType in pairs(toolList) do
  local toolInfo = toolDefs[toolType]
  if not toolInfo then
    toolInfo = {}
  end
  for key, value in pairs(defaultToolSettings) do
    if toolInfo[key] == nil then
      toolInfo[key] = value
    end
  end
  toolDefs[toolType] = toolInfo
end