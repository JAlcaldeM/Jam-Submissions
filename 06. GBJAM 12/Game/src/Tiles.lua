


-- vector with the keys equivalent to the numbers
mapnumberToKey = {
  "wgrass1", "wgrass2", "wgrass3", "wgrass4", "wgrass5", --5
  "wplants1", "wplants2", "wplants3", "wplants4", --9
  "wbricks", "wfloor1", "wfloor2", "wfloor3", "wfloor4", --14
  "ggrass1", "ggrass2", "ggrass3", "ggrass4", "ggrass5", --19
  "gplants1", "gplants2", "gplants3", "gplants4", --23
  "gbricks", "gfloor1", "gfloor2", "gfloor3", "gfloor4", --28
  "water1", "water2", "tree", "rock", "mineral", --33
  "lava1", "bridge", "woodwall", "lava2", "moon", --38
  "desert1", "desert2", "desert3", "desert4", "desert5", "desert6", --44
  "altar", "blackstone", "blackstoneInfo", "garden", "crater", "void", --50
  "fruitTree", "recharger", "ice1", "ice2", "iceSolid", --55
  "emptyCrater", "undefinedGround", "undefinedGroundPieces", "sandWater", "sand", --60
  "triggerOff", "triggerOn", "blackBridge", "inactiveLava", "resistantIce", --65
  "guideGreen", "guideYellow", "guideBeach", "volcanoCore", 'blackCrystal', "timeBubble", --71
  "blackBridgeHoriz", "emptyRecharger", 
}


function numberToKeyData(tileNumber)
  local tileKey = mapnumberToKey[tileNumber]
  local tileData = tiledefs[tileKey]
  return tileKey, tileData
end



tiledefs = {
  
  timeBubble = {
    solid = true,
    interactable = true,
    onInteract = function(x, y, state)
      
      
      if state.isGaiaAlive then
         -- trigger ending 1
         gStateStack:push(EndState({chosenEnding = 1}))
      else
        -- trigger ending 2
        gStateStack:push(EndState({chosenEnding = 2}))
      end
      
    end,
    onTurn = function(x, y, state)
      if state.map[x-1][y] == 34 then -- lava1
        state:triggerPlayerDeath('restart')
      end
    end,
    
    
  },
  
  guideGreen = {
    stepSound = 'hard',
  },
  
  guideYellow = {
    stepSound = 'hard',
  },
  
  guideBeach = {
    stepSound = 'hard',
  },
  
  volcanoCore = {
    stepSound = 'hard',
    },
  
  triggerOff = {
    stepSound = 'hard',
    onEnter = function(x, y, state)
      state:triggerOn()
      state.map[x][y] = 62 --triggerOn
      end,
    },
    
  blackBridge = {
    stepSound = 'hard',
    },
  
  blackBridgeHoriz = {
    stepSound = 'hard',
  },
  
  wfloor2 = {
    stepSound = 'hard',
    },
  
  desert1 = {
    stepSound = 'sand',
    sandSink = true,
    },
  
  sandWater = {
    stepSound = 'sand',
  },
  
  sand = {
    stepSound = 'sand',
  },
  
  water1 = {
    walkable = false,
    bombProtected = true,
    triggerEnterOnFall = true,
    onEnter = function(x, y, state)
      if state.cheatMode then
        return
      end
      state.allowInput = false
      local timeFall = 0.5
      Timer.after(timeFall, function()
          state.player.sandSinkLevel = 1
          state:recalculateCanvas()
          defPlay('sinking1')
          end)
      Timer.after(2*timeFall, function()
          state.player.sandSinkLevel = 2
          state:recalculateCanvas()
          defPlay('sinking2')
          end)
      Timer.after(3*timeFall, function() 
          state.player.sandSinkLevel = 3
          state:recalculateCanvas()
          defPlay('sinking3')
        end)
      Timer.after(4*timeFall, function() 
          state.player.sandSinkLevel = 4
          state:recalculateCanvas()
          defPlay('sinking4')
        end)
      Timer.after(5*timeFall, function() 
          state:triggerPlayerDeath('drowned')
          defPlay('waterSink')
          end)
    end,
  },
  
  blackstone = {
    walkable = false,
    solid = true,
    lavaProtected = true,
  },
  
  
  ice1 = {
    stepSound = 'ice',
    onEnter = function(x, y, state)
      state.map[x][y] = 54 --ice2
      if state.player.hasMoved then
        iceSlide(x, y, state)
      end
    end,
  },
  
  resistantIce = {
    stepSound = 'ice',
    onEnter = function(x, y, state)
      if state.player.hasMoved then
        iceSlide(x, y, state)
      end
    end,
  },
  
  ice2 = {
    stepSound = 'iceCrack',
    onEnter = function(x, y, state)
      local frozenTileNewNumber = 50 --void
      for i = #state.frozenTiles, 1, -1 do
        local frozenTile = state.frozenTiles[i]
        if frozenTile.x == x and frozenTile.y == y then
          --print('x == x and y == y: ice2 destroyed. frozenTileNumber: ', frozenTile.tileNumber)
          frozenTileNewNumber = frozenTile.tileNumber
          table.remove(state.frozenTiles, i)
        end
      end
      state.map[x][y] = frozenTileNewNumber
      local tileKey, tileData = numberToKeyData(frozenTileNewNumber)
      tileData.onEnter(x, y, state)
      --iceSlide(x, y, state)
    end,
  },
  
  iceSolid = {
    walkable = false,
    solid = true,
    lavaProtected = true,
    axeDestructible = true,
    onAxeDestruction = function(x, y, state)
      state.map[x][y] = 53 --ice1
      end,
  },
  
  fruitTree = {
    walkable = false,
    solid = true,
    interactable = true,
    axeDestructible = true,
    onInteract = function(x, y, state)
      defPlay('getTool')
      if not state.tool then
        local fruits, index = state:spawnTool('fruits', x, y)
        state:pickupTool(fruits, index)
      end
    end,
    onAxeDestruction = function(x, y, state)
      state.map[x][y] = 48 --garden
      state:spawnTool('wood', x, y)
      end,
  },
  
  blackstoneInfo = {
    walkable = false,
    solid = true,
    lavaProtected = true,
    interactable = true,
    onInteract = function(x, y, state)
      for _, text in pairs(tilesText) do
        if text.x == x and text.y == y then
          gStateStack:push(TextState({text = text.text}))
        end
      end
      
    end,
  },
  
  recharger = {
    walkable = false,
    solid = true,
    interactable = true,
    onInteract = function(x, y, state)
      if state.tool and state.tool.rechargable then
        state.tool.charge = 50
        defPlay('tool2')
        --state.map[x][y] = 73 --emptyrecharger
      else
        defPlay('toolFailMini')
      end
      
    end,
  },
  
  emptyRecharger = {
    walkable = false,
    solid = true,
  },
  
  altar = {
    walkable = false,
    solid = true,
    lavaProtected = true,
    interactable = true,
    onInteract = function(x, y, state)
      local stateTool = state.tool
      local altarTool, toolIndex = searchTool(x, y, state)
      
      if stateTool then
        state:depositTool(x, y)
      end
      if altarTool then
        state:pickupTool(altarTool, toolIndex)
      end
      
      
      
      --[[
      if stateTool and not stateTool.justPicked then
        local depositTool = true
        for i, tool in ipairs(state.tools) do
          if tool.x == x and tool.y == y then
            depositTool = false
          end
        end
        if depositTool then
          state:depositTool(x, y)
        end
      end
      ]]
    end,
  },
  
  tree = {
    solid = true,
    walkable = false,
    axeDestructible = true,
    onAxeDestruction = function(x, y, state)
      state.map[x][y] = 15 --grass
      state:spawnTool('wood', x, y)
      end,
    },
  
  rock = {
    solid = true,
    walkable = false,
  },
  
  
  inactiveLava = {
    walkable = false,
    bombProtected = true,
    triggerEnterOnFall = true,
    onEnter = function(x, y, state)
        if state.cheatMode then
          return
        end
        if not state.player.burning then
          state.player.burning = true
          state.player.burned = true
          defPlay('fireShort')
        end
      end,
    },
  
  lava1 = {
    bombProtected = true,
    lavaProtected = true,
    --iceProtected = true,
    triggerEnterOnFall = true,
    onEnter = function(x, y, state)
        if state.cheatMode then
          return
        end
        if not state.player.burning then
          state.player.burning = true
          state.player.burned = true
          defPlay('fireShort')
        end
      end,
    onTurn = function(x, y, state)
      if x <= 1 or x >= nCols or y <= 1 or y >= nRows then
        return
      end
      local newLavaCoords = {
        {x = x-1, y = y},
        {x = x+1, y = y},
        {x = x, y = y-1},
        {x = x, y = y+1},
      }
      
      for _, coord in pairs(newLavaCoords) do
        local tileKey, tileData = numberToKeyData(state.map[coord.x][coord.y])
        if not tileData.lavaProtected then
          state.map[coord.x][coord.y] = 34 --lava
        end
        if state.player.x == coord.x and state.player.y == coord.y and (not state.player.floating) and (not state.player.burned) and not (state.cheatMode) then
          state.player.burned = true
          defPlay('fireShort')
          if state.player.burning then
            state:triggerPlayerDeath('lava')
            gSounds['fireShort']:stop()
            defPlay('fireDeath')
          end
        end
      end
      
      --[[
      state.map[x-1][y] = 34
      state.map[x+1][y] = 34
      state.map[x][y-1] = 34
      state.map[x][y+1] = 34
      ]]
    end
    },
  
  void = {
    walkable = false,
    bombProtected = true,
    iceProtected = true,
    triggerEnterOnFall = true,
    canSlideOnto = true,
    onEnter = function(x, y, state)
      if state.cheatMode then
        return
      end

      state.allowInput = false
      local timeFall = 0.5
      Timer.after(timeFall, function()
          defPlay('fall')
          state.player.fallHeight = 1
          state:recalculateCanvas()
          end)
      Timer.after(2*timeFall, function()
          state.player.fallHeight = 2
          state:recalculateCanvas()
          end)
      Timer.after(3*timeFall, function() 
          state.player.fallHeight = 3
          state:recalculateCanvas()
        end)
      Timer.after(5*timeFall, function() 
          state:triggerPlayerDeath('fallen')
          end)
    end,
    },

}
--[[
local defaultTileSettings = {
  {key = 'walkable', value = true},
  {key = 'onTurn', value = function() end},
  }

for i, key in ipairs(mapnumberToKey) do
  if not tiledefs[key] then
    tiledefs[key] = {}
  end
  for _, setting in ipairs(defaultTileSettings) do
    if tiledefs[key][setting.key] == nil then
      tiledefs[key][setting.key] = setting.value
    end
  end
end
]]


local defaultTileSettings = {
  walkable = true,
  solid = false,
  onTurn = function() end,
  --onInteract = function() end,
  onEnter = function(x, y, state) end,
  axeDestructible = false,
  text = false,
  bombProtected = false,
  iceProtected = false,
  sandSink = false,
  interactable = false,
  lavaProtected = false,
  triggerEnterOnFall = false,
  stepSound = 'grass',
  canFallOnto = false,
  }

for i, tiletype in ipairs(mapnumberToKey) do
  local tileinfo = tiledefs[tiletype]
  if not tileinfo then
    tileinfo = {}
  end
  for key, value in pairs(defaultTileSettings) do
    if tileinfo[key] == nil then
      tileinfo[key] = value
    end
  end
  tiledefs[tiletype] = tileinfo
end


--[[
guide for new tiles:
- walkable?
- solid? (you cannot teleport inside solid tiles or float over them, and they leave a crater when destroyed by bombs)
- axeDestructible, bombProtected, iceProtected? something specific happens when destroyed by one of these means (axeDestruction)?
- onEnter? (step into the tile)
- onInteract? (bump into the tile)
- onTurn (each turn this tile exists this happens)

]]
