-- This file contains generic and specific FUNCTIONS that may be used during the game

function nElements(table) -- returns the number of elements in an array, useful if key-value
  local count = 0
  for _, _ in pairs(table) do
      count = count + 1
  end
  return count
end

function copyTable(table) -- creates a copy of a table
  local newTable = {}
  for key, value in pairs(table) do
    newTable[key] = value
  end
  return newTable
end

function copyArray(array) -- creates a copy of an array
  local newArray = {}
    for i, v in ipairs(array) do
        newArray[i] = v
    end
    return newArray
end

function tileMap(source, tileWidth, tileHeight) -- used for segmenging a tilemap into the individual sprites
    
    local offset = 0.001
    local totalWidth = source:getWidth()
    local totalHeight = source:getHeight()
    local nRows = totalWidth / tileWidth
    local nColumns = totalHeight / tileHeight
  
    local sheetNumber = 1
    local spriteSheet = {}

    for y = 0, nColumns - 1 do
        for x = 0, nRows - 1 do
            spriteSheet[sheetNumber] = love.graphics.newQuad(x * tileWidth + offset, y * tileHeight + offset, tileWidth - offset, tileHeight - offset, totalWidth, totalHeight)
            sheetNumber = sheetNumber + 1
        end
    end

    return spriteSheet
end


function swap(array, pos1, pos2) -- swap 2 index in an array
    local temp = array[pos1]
    array[pos1] = array[pos2]
    array[pos2] = temp
end

function shuffleArray(array) -- randomize the positions in an array
    local n = #array
    for i = 1, n do
        local j = math.random(n)
        array[i], array[j] = array[j], array[i]
    end
end

function clamp(value, min, max) -- limit a variable within a max-min limit
    return math.min(math.max(value, min), max)
end

function isEven(number) -- is this number even?
    return number % 2 == 0
end

function calculateDistance(x1, y1, x2, y2) -- calculate distance between 2 points
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end





function love.wheelmoved(x, y)
  wheelMovY = y or 0
end









function getKeyMax(array)
  local maxKey
  local maxValue = -math.huge

  for key, value in pairs(array) do
    if value > maxValue then
      maxValue = value
      maxKey = key
    end
  end
  
  return maxKey
end

function isStringInArray(stringSearched, array)
  for _, string in pairs(array) do
    if string == stringSearched then
      return true
    end
  end
  return false
end


--[[

function playSound(name)
  
  local sound = gSounds[name]
  local type = soundType[name]
  local volume = volumeValues[type]/10
  
  
  
  for soundName, soundFile in pairs(gSounds) do
    if soundType[soundName] == type then
      soundFile:stop()
    end
  end
  --sound:stop()
  
  sound:setVolume(volume)
  
  if type == 'music' and musicLoop[name] then
    sound:setLooping(true)
  end
  
  love.audio.play(sound)
  
end

function changeSoundSpeed(ffmode)
  local speed = 1
  if ffmode then
    speed = 2
  end
  for _, sound in pairs(gSounds) do
    sound:setPitch(speed)
  end
end
]]

function playSoundForDuration(sound, duration)
    sound:play()
    love.timer.sleep(duration)
    sound:stop()
end













-- specific functions
function assignWorkPositions(cell, playstate)
  local buildingName = cell.building
  local icons = {}
  local iconNumbers = {}
  
  
  if playstate.tier <= 1 and buildingName == 'quarry' then
    return
  end
  
  if playstate.tier <= 2 and buildingName == 'mine' then
    return
  end
  
  if buildingName == 'townhall' and (not cell.townhallUpgrades) then
    cell.townhallUpgrades = 1
  end
  
  
  for i = 1, 4 do
    if buildingName == 'townhall' then
      local icon = resourceList[i]
      icons[i] = icon
      iconNumbers[i] = resourceIcons[icon]
    else
      local icon = buildingToWork[buildingName]
      icons[i] = icon
      iconNumbers[i] = workIcons[icon]
    end
  end
  
  local iconScale = 10
  
  local p1type, p2type, p3type, p4type, p1number, p2number, p3number, p4number
  
  --[[
  if buildingName == 'townhall' then
    
  else
    
  end
  ]]
  
  p1type = icons[1]
  p2type = icons[2]
  p3type = nil
  p4type = nil
  
  p1number = iconNumbers[1]
  p2number = iconNumbers[2]
  p3number = nil
  p4number = nil
  
  

  -- position 3
  if playstate.tier >= 2 then
    if cell.tier == 1 then
      p3type = 'builder'
      p3number = workIcons['builder']
    else
      p3type = icons[3]
      p3number = iconNumbers[3]
    end
  end
  
  -- position 4
  if playstate.tier >= 3 then
    if cell.tier == 2 then
      p4type = 'builder'
      p4number = workIcons['builder']
    elseif cell.tier == 3 then
      p4type = icons[3]
      p4number = iconNumbers[3]
    end
  end
  
  if cell.building == 'townhall' then
    if playstate.tier == 1 then
      p3type = 'builder'
      p3number = workIcons['builder']
    elseif playstate.tier == 2 then
      p3type = 'stone'
      p3number = resourceIcons['stone']
      p4type = 'builder'
      p4number = workIcons['builder']
    elseif playstate.tier == 3 then
      p3type = 'stone'
      p3number = resourceIcons['stone']
      p4type = 'iron'
      p4number = resourceIcons['iron']
    end
  end
  
  
  
  
  if cell.building == 'construction' then
    p1type = 'builder'
    p2type = 'builder'
    p3type = 'builder'
    p4type = 'builder'
    
    p1number = workIcons['builder']
    p2number = workIcons['builder']
    p3number = workIcons['builder']
    p4number = workIcons['builder']
  end
  
  
  
  
  local p1 = {cell = cell, x = cell.x + cell.offset, y = cell.y + cell.offset, icon = p1type, iconNumber = p1number, scale = iconScale, tier = cell.tier, filled = false, buildX = cell.x, buildY = cell.y,}
  local p2 = {cell = cell, x = cell.x + 2*cell.offset + cell.unitSize, y = cell.y + cell.offset, icon = p2type, iconNumber = p2number, scale = iconScale, tier = cell.tier, filled = false, buildX = cell.x + 1.5*cell.offset + cell.unitSize, buildY = cell.y,}
  local p3 = {cell = cell, x = cell.x + cell.offset, y = cell.y + 2*cell.offset + cell.unitSize, icon = p3type, iconNumber = p3number, scale = iconScale, tier = cell.tier, filled = false, buildX = cell.x, buildY = cell.y + 1.5*cell.offset + cell.unitSize,}
  local p4 = {cell = cell, x = cell.x + 2*cell.offset + cell.unitSize, y = cell.y + 2*cell.offset + cell.unitSize, icon = p4type, iconNumber = p4number, scale = iconScale, tier = cell.tier, buildX = cell.x + 1.5*cell.offset + cell.unitSize, buildY = cell.y + 1.5*cell.offset + cell.unitSize,}
  
  if not cell.positions then
    cell.positions = {}
  end
  
  --cell.positions = {p1, p2, p3, p4}
  
  
  
  
  if (not cell.positions[1]) or ((not cell.positions[1].icon) and (not cell.positions[1].constructed)) or (cell.positions[1].constructed) then
    table.insert(playstate.positions, p1)
    table.insert(cell.positions, p1)
  end
  if (not cell.positions[2]) or ((not cell.positions[2].icon) and (not cell.positions[2].constructed)) or (cell.positions[2].constructed)  then
    table.insert(playstate.positions, p2)
    table.insert(cell.positions, p2)
  end
  if (not cell.positions[3]) or ((not cell.positions[3].icon) and (not cell.positions[3].constructed)) or (cell.positions[3].constructed)  then
    table.insert(playstate.positions, p3)
    table.insert(cell.positions, p3)
  end
  if (not cell.positions[4]) or ((not cell.positions[4].icon) and (not cell.positions[4].constructed)) or (cell.positions[4].constructed) then
    table.insert(playstate.positions, p4)
    table.insert(cell.positions, p4)
  end
  

  for _, position in pairs(cell.positions) do
    --if position.icon == 'builder' then
      local tierForMaterial = cell.tier
      if cell.building == 'townhall' then
        tierForMaterial = tierForMaterial - 1
      end
      if tierForMaterial == 0 then
        position.buildMaterial = 'wood'
      elseif tierForMaterial == 1 then
        position.buildMaterial = 'stone'
      elseif tierForMaterial == 2 then
        position.buildMaterial = 'iron'
      end
    --end
  end

--[[
  for _, position in pairs(cell.positions) do
    position.buildMaterial = 'wood'
  end
  ]]
  
  

end

function distributeWorkers(workersOriginal, sliders)
  
  local workers = copyTable(workersOriginal)
  
  shuffleArray(workers)
  
  
  
  local totalWorkers = 0
  local nWorkers = {none = 0,}
  
  for _, work in ipairs(workList) do
    nWorkers[work] = 0
  end
  
  for _, worker in ipairs(workers) do
    local work = worker.work
    nWorkers[work] = nWorkers[work] + 1
    totalWorkers = totalWorkers + 1
  end
 
  
  local multRate = 0.85
  local sliderWeights = {}
  
  
  for i, slider in ipairs(sliders) do
    if slider.active then
      sliderWeights[slider.work] = slider.value
    end
  end

  
  
  local desiredWorkerDistribution = {
    farmer = 0,
    lumberjack = 0,
    soldier = 0,
    builder = 0,
    stonemason = 0,
    doctor = 0,
    miner = 0,
    blacksmith = 0,
    none = 0,
  }
  
  for i = 1, totalWorkers do
    local work = getKeyMax(sliderWeights)
    desiredWorkerDistribution[work] = desiredWorkerDistribution[work] + 1
    sliderWeights[work] = sliderWeights[work]*multRate
  end

  for key, value in pairs(desiredWorkerDistribution) do
    --print(key, value)
  end
  
  
  --[[
  --calculate desired worker distribution... for the moment:
  desiredWorkerDistribution = {
    farmer = 2,
    lumberjack = 1,
    soldier = 2,
    builder = 1,
    stonemason = 1,
    doctor = 0,
    miner = 0,
    blacksmith = 1,
    none = 0,
  }
  ]]

  
  
  local workersNeeded = {}
  for _, work in ipairs(workList) do
    workersNeeded[work] = desiredWorkerDistribution[work] - nWorkers[work]
    --print('workersneeded', work, workersNeeded[work])
  end
  
  local newWorksList = {}
  for work, workersNeeded in pairs(workersNeeded) do
    while workersNeeded > 0 do
      table.insert(newWorksList, work)
      workersNeeded = workersNeeded - 1
    end
  end
  

  for _, worker in ipairs(workers) do
    while workersNeeded[worker.work] < 0 do
      local oldWork = worker.work
      local newWork = newWorksList[#newWorksList]
      worker:changeWork(newWork)
      table.remove(newWorksList, #newWorksList)
      workersNeeded[oldWork] = workersNeeded[oldWork] + 1
      --print('changed from', oldWork, 'to', newWork)
    end
  end
  
end



function activateSliders(state, tier)
  
  local sliders = state.sliders
  local icons = state.workIcons

  for i = 1, 4 do
    sliders[i].active = true
    icons[i].active = true
  end
  
  if tier >= 2 then
    sliders[5].active = true
    sliders[6].active = true
    icons[5].active = true
    icons[6].active = true
    state.lockedIcon1.active = false
  end
  
  if tier >= 3 then
    sliders[7].active = true
    sliders[8].active = true
    icons[7].active = true
    icons[8].active = true
    state.lockedIcon2.active = false
  end
  
  distributeWorkers(state.workers, sliders)

end

function checkCloserPosition(positions, worker, posType)
  
  local possiblePositions = {}
  local minDistance = math.huge
  local currentCloserPosition = nil
  
  for _, position in pairs(positions) do
    --if position.icon == posType and (position.worker == nil or position.worker.work == 'blacksmith' or position.worker.work == 'doctor') then
    if position.icon == posType and position.worker == nil then
      table.insert(possiblePositions, position)
    end
  end

  
  if #possiblePositions == 0 then
    return nil
  end
  
  for _, position in pairs(possiblePositions) do
    local distance = calculateDistance(worker.x, worker.y, position.x, position.y)
    if distance < minDistance then
      minDistance = distance
      currentCloserPosition = position
    end
  end
  
  return currentCloserPosition
  
end

function checkRandomPosition(positions, worker, posType)

  for _, position in pairs(positions) do
    if position.icon == posType and (position.worker == nil or position.worker.work == 'blacksmith' or position.worker.work == 'doctor') then
      return position
    end
  end

end




function isBuildingComplete(cell)
    for _, position in pairs(cell.positions) do
        if position.icon == 'builder' then
            return false
        end
    end
    return true
end


function detectNextCellWithoutBuilding(cells)
  for _, cell in ipairs(cells) do
    if not cell.building then
      return cell
    end
  end
end

function createNewConstructionSite(cells, playState)
  local cell = detectNextCellWithoutBuilding(cells)
  cell.building = 'construction'
  cell.tier = 0
  assignWorkPositions(cell, playState)
end

function decideBuildingType(playState)
  
  local cells = playState.cells
  local workers = playState.workers
  local tier = playState.tier
  local newBuildingType = nil
  local data = {}
  
  for _, work in ipairs(worksAllowed[tier]) do
    
    
    local availableWorkPositions = 0
    local currentWorkers = 0
    
    for _, cell in pairs(cells) do
      if cell.positions then
        for _, position in pairs(cell.positions) do
          if position.icon == work then
            availableWorkPositions = availableWorkPositions + 1
          end
        end
      end
    end
    
    for _, worker in pairs(workers) do
      if worker.work == work then
        currentWorkers = currentWorkers + 1
      end
    end

    table.insert(data, {work = work, availableWorkPositions = availableWorkPositions, currentWorkers = currentWorkers, positionsNeeded = currentWorkers - availableWorkPositions})
    
  end
  
  --[[
  for _, work in pairs(data) do
    print(work.work, work.positionsNeeded)
  end
  ]]
  
  local maxDemand = -math.huge
  for _, work in pairs(data) do
    if work.positionsNeeded > maxDemand then
      newBuildingType = workToBuilding[work.work]
      maxDemand = work.positionsNeeded
    end
  end
  
  
  return newBuildingType
  
end

function getCloserAvailableWorker(playstate, enemy, worksAlone)
  
  local workers = playstate.workers
  local currentCloserWorker
  
  local minDistance = math.huge
  local currentCloserPosition = nil
  
  for _, worker in pairs(workers) do
    if worker.isAlive and (worksAlone == not worker.isTarget) then
      local distance = calculateDistance(worker.x, worker.y, enemy.x, enemy.y)
      if distance < minDistance then
        minDistance = distance
        currentCloserWorker = worker
      end
    end
  end
  
  if currentCloserWorker == nil and (not worksAlone) then
    gStateStack:push(LoseState())
  end
  
  
  return currentCloserWorker
  
end

function checkBehavior(behavior, workerOriginal) -- with friend
  local state = workerOriginal.playState
  local workers = state.workers
  local minDistance = math.huge
  local currentCloserWorker = nil
  
  for _, worker in pairs(workers) do
    if worker.behavior == behavior and (not worker.friend or worker.friend == workerOriginal) then
      local distance = calculateDistance(worker.x, worker.y, workerOriginal.x, workerOriginal.y)
      if distance < minDistance then
        minDistance = distance
        currentCloserWorker = worker
      end
    end
  end
  
  return currentCloserWorker
  
end


