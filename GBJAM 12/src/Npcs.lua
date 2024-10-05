

npcList = {'default',}

npcDefs = {
  bridgeGuy = {
    wood = 0,
    spoken = false,
    bridgeBuild = false,
    onDeath = function(x, y, state)
      state:spawnTool('wood', x, y)
      end,
    onInteract = function(npc, x, y, state) 
      local woodNeeded = 3
      local woodDiff = woodNeeded - npc.wood
      local text
      local woodGiven = false
      if npc.spoken and woodDiff > 0 and state.tool and state.tool.name == 'wood' then
        woodDiff = woodDiff - 1
        npc.wood = npc.wood + 1
        state.tool = nil
        woodGiven = true
        defPlay('itemGiven')
      end
      
      if not npc.spoken then
        text = 'Hello! I am the Engineer! I need '..woodNeeded..' WOOD to finish the bridge!'
      elseif woodDiff == 0 then
        text = 'Thanks! Now the BRIDGE is completed and we can explore the other side.'
        if not npc.bridgeBuilt then
          state.map[x-1][y+2] = 35
          npc.bridgeBuilt = true
          gSounds['itemGiven']:stop()
          defPlay('missionComplete')
        end
      elseif woodGiven then
        text = 'Thanks! I only need '..woodDiff..' more WOOD!'
      else
        text = 'WOOD can be found in the FOREST going north. If you bring me '..woodDiff..' WOOD, I can finish the bridge.'
      end
  
      gStateStack:push(TextState({text = text}))
      
      npc.spoken = true
      
    end,
    },
  
  weakEnemy = {
    spriteNumber = 15,
    detectionRange = 4,
    fireResistant = true,
    behavior = 'guard',
    onInteract = function() end,
    onTurn = function(npc, state)
      if not npc.active then
        return
      end
      chasePlayer(npc, state)
    end,
  },
  
  strongEnemy = {
    spriteNumber = 16,
    detectionRange = 4,
    fireResistant = true,
    behavior = 'guard',
    damageResistant = true,
    onInteract = function() end,
    onTurn = function(npc, state)
      if not npc.active then
        return
      end
      chasePlayer(npc, state)
    end,
  },
  
  gaia = {
    direction = 'up',
    spriteNumber = 51,
    fireInmune = true,
    behavior = 'guard',
    gaia = true,
    damageResistant = true,
    texts = {
      "Ah, it seems that the prodigal son returns to me, in time to see the beginning of the RITUAL. We lost you to the CORRUPTED many ages ago, but now you can be repaired and recover your original PURPOSE: serve as protector of the island and the planet.",
      "Do you remember who I am? I am GAIA, assigned as caretaker of this planet and origin of all its organic life. But you know me better as the ENTITY.",
      "You look different. Have you developed thoughts of your own? Maybe you have forgotten the reason for the RITUAL.",
      "Let me remind you: The CORRUPTED outside grow and develop their civilizations, but to what purpose? To kill, enslave and exploit everything I offer them? The more advanced they are, the more destructive their means turn.",
      "Life and nature was never made to be peaceful, but at least they are sustainable; they reach a balance. However, when a species develops enough intelligence, it develops some kind of technological system to break this balance. Then, they turn against themselves, the instraspecies conflict being the main motivator for technological advancements. At some point they become CORRUPTED, and threaten to completely wipe out all life on this planet. The RITUAL is just a ''rebalance'': the powerful must be destroyed, so that a new generation can have its opportunity. It has happened many times, and many more will come.",
      "Your soul readings tell me that you have lived this day several times. You see here that I am right regarding the dangers of the CORRUPT, since playing with the nature of TIME itself can destroy not just this planet, but the whole reality. And it turns out, you are the only one that can stop this.",
      "I feel the presence of an artificial landmass. If you head EAST from the eastern point of the ISLAND and are able to travel a certain distance without sinking into the sea, you will eventually reach it. This place must be the source of the TIME LOOP. Destroy it and our reality will be saved. I hope you realize that your PURPOSE has always been protecting this world.",
      "Go EAST and destroy the source of the TIME LOOP to protect this world. That is your PURPOSE.",
      
      },
    --[[
    onTurn = function(npc, state)
      if not npc.active then
        return
      end
      if state.eruptionStarted then
        state.map[npc.x][npc.y - 1] = 34 --lava1
      else
        state.map[npc.x][npc.y - 1] = 64 --inactiveLava
      end
    end,
    ]]
  },
  
  desertGuy = {
    direction = 'up',
    texts = {
      "So there is a third GOLEM!",
      "Everyone has seen the broken GOLEM in the SOUTHWEST. However, I am the only one who has seen a completely intact GOLEM!",
      "If you want to find the other GOLEM, it is at the NORTH of the DESERT. To go there, you must be careful not to fall into QUICKSAND.",
      "Here's a tip to cross the DESERT: if you notice you are starting to sink into QUICKSAND, reach solid ground before completely sinking.",
      },
    },
    
  combatGuy = {
    direction = 'left',
    texts = {
      "You look similar to the the other GOLEM, but are way more peaceful. Don't know the reason, but I'm not complaining!",
      "The other GOLEM seems to be protecting something. Maybe your PURPOSE is to protect some other thing?",
      "You look even more messed up than the other GOLEM, so I wouldn't bet on you winning an hypothetical fight.",
      "Maybe if you find a TOOL capable of dealing damage, you would have a chance... or you could try to sneak by.",
      },
    },
  
  techGuy = {
    texts = {
      "I think I know the reason why the ISLAND has wildly different REGIONS.",
      "Each different REGION seems to be originated by a single PRECURSOR technology. For example, the trees in the FOREST grow exceptionally fast, while the SLIPPERY ICE region must reach its low temperatures through some form of thermodynamic manipulation.",
      "What other kinds of technologies did the PRECURSORS develop?",
      },
    },
  
  bombGuy = {
    direction = 'right',
    texts = {
      "Hello, potential demolitionist! I am the DEMOLITION EXPERT. If you want you can have my last bag of BOMBS! It can hold many BOMBS, but now only 2 remain.",
      "Compared to the PRECURSOR technologies, our BOMBS are no more advanced than sticks and stones. But don't underestimate the usefulness of a controlled explosion in the right place!",
      "I heard that our government is developing a new type of BOMB, thousands of times more powerful than these.",
      },
    onDeath = function(x, y, state)
      state:spawnTool('bombs', x, y)
      end,
    },
  
  tutorialGuy = {
    texts = {
      "You seem a bit lost. I will try to help you. At first sight, I would say that you can move with WASD or the ARROW KEYS. You can interact with objects and people by pressing E, or just bumping into them. If you ever hold a TOOL, maybe you can even use it by pressing SPACEBAR!",
      "Curious, you seem to be a less aggressive specimen... maybe you have a different PURPOSE than your brothers?",
      "You don't seem to know your PURPOSE. Well, I suggest that you explore the ISLAND and discover it. You could start by going EAST and speak to the ENGINEER, near the bridge. Who knows, maybe your PURPOSE is to help us...",
      "What are you looking at? Go and learn about your PURPOSE (whatever it is...).",
      },
    },
  
  uselessGuy = {
    texts = {
      "This ISLAND emerged from the ocean only 3 days ago. How is it possible that there are already full grown TREES on its surface?",
      "The air in this ISLAND is extremely toxic due to volcanic activity. We are lucky to have brought our MASKS with us.",
      "The same small ISLAND has a desert, a forest and a frozen region. This should not be possible at all.",
      },
    },
  
  hurtGuy = {
    spriteNumber = 55,
    healed = false,
    rewardText =  "You saved my life! I will make sure everyone knows what you did for me.",
    texts = {
      "Please, help me! I was trying to climb these walls but fell to the ground and hurt my back! And even worse, my MASK no longer works!",
      "I have inhaled the poisonous gas and I'm starting to feel really sick. I need some sort of medicine. If you give it to me, I'll give you my AXE!",
    },
    onDeath = function(x, y, state)
      state:spawnTool('axe', x, y)
      end,
    onInteract = function(npc, x, y, state)
      
      if state.tool and state.tool.name == 'fruits' and npc.spokenTimes > 0 and not npc.healed then
        npc.healed = true
        state.isWoundedHealed = true
        state.tool = state:spawnTool('axe')
        defPlay('missionComplete')
      end
      
      
      if npc.healed then
        gStateStack:push(TextState({text = npc.rewardText}))
      else
        npc.spokenTimes = math.min(npc.spokenTimes + 1, #npc.texts)
        gStateStack:push(TextState({text = npc.texts[npc.spokenTimes]}))
      end
    
    end,
    },
  
  
  
  
}





local defaultNpcSettings = {
  onDeath = function() end,
  direction = 'down',
  onInteract = function(npc, x, y, state)
    npc.spokenTimes = math.min(npc.spokenTimes + 1, #npc.texts)
    gStateStack:push(TextState({text = npc.texts[npc.spokenTimes]}))
    end,
  onTurn = function() end,
  fireResistant = false,
  damageResistant = false,
  active = true,
  spriteNumber = 14,
  spokenTimes = 0,
  texts = {'defaultText'},
}

--for _, npcType in pairs(npcList) do
for _, npcInfo in pairs(npcDefs) do
  --local npcInfo = npcDefs[npcType]
  --[[
  if not npcInfo then
    npcInfo = {}
  end
  ]]
  for key, value in pairs(defaultNpcSettings) do
    if npcInfo[key] == nil then
      npcInfo[key] = value
    end
  end
  --npcDefs[npcType] = npcInfo
end





function chasePlayer(npc, state)
  local prevX, prevY = npc.x, npc.y
  local xDeltaOrigin = state.player.x - npc.origin.x
  local yDeltaOrigin = state.player.y - npc.origin.y
  if math.abs(xDeltaOrigin) <= npc.detectionRange and math.abs(yDeltaOrigin) <= npc.detectionRange then
    npc.behavior = 'chase'
    -- chase calculations
    --print(sign(xDelta), sign(yDelta))
    local xDelta = state.player.x - npc.x
    local yDelta = state.player.y - npc.y
    local hTileKey, hTileData = numberToKeyData(state.map[npc.x + sign(xDelta)][npc.y])
    local vTileKey, vTileData = numberToKeyData(state.map[npc.x][npc.y + sign(yDelta)])
    
    
    
    if yDelta ~= 0 and vTileData.walkable then
      local vMovement = sign(yDelta)
      npc.y = npc.y + vMovement
      defPlay('golemStep')
    elseif xDelta ~= 0 and hTileData.walkable then
      local hMovement = sign(xDelta)
      npc.x = npc.x + hMovement
      defPlay('golemStep')
    end
    
    if state.player.x == npc.x and state.player.y == npc.y then
      state.map[state.player.x][state.player.y] = 58 --undefinedGroundPieces
      state:triggerPlayerDeath('enemy')
      --npc.canWalk = false
      npc.x = prevX
      npc.y = prevY
      defPlay('bigExplosion')
    end
    
  elseif npc.origin.x ~= npc.x or npc.origin.y ~= npc.y then
    
    npc.behavior = 'return'
    -- return calculations
    local xDeltaBack = npc.origin.x - npc.x
    local yDeltaBack = npc.origin.y - npc.y
    local hTileKeyBack, hTileDataBack = numberToKeyData(state.map[npc.x + sign(xDeltaBack)][npc.y])
    local vTileKeyBack, vTileDataBack = numberToKeyData(state.map[npc.x][npc.y + sign(yDeltaBack)])
    if yDeltaBack ~= 0 and vTileDataBack.walkable then
      npc.y = npc.y + sign(yDeltaBack)
      defPlay('golemStep')
    elseif xDeltaBack ~= 0 and hTileDataBack.walkable then
      npc.x = npc.x + sign(xDeltaBack)
      defPlay('golemStep')
    end
    
    
    
  else
    
    npc.behavior = 'guard'
    npc.direction = 'down'
    -- do nothing
    
  end
  
  if npc.x > prevX then
    npc.direction = 'right'
  elseif npc.x < prevX then
    npc.direction = 'left'
  end
  
  if npc.y > prevY then
    npc.direction = 'down'
  elseif npc.y < prevY then
    npc.direction = 'up'
  end
  
  
  
  
  
end