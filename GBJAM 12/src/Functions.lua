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
    
    --local offset = 0.001
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
    return array
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

function sign(x)
  if x >= 0 then
    return 1
  elseif x < 0 then
    return -1
  else
    return nil
  end
end

function roundToNDecimals(num, n)
   local n = n or 0
    local multiplier = 10^n
    return math.floor(num * multiplier + 0.5) / multiplier
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



function playSoundForDuration(sound, duration)
    sound:play()
    love.timer.sleep(duration)
    sound:stop()
end

function mean(numbers)
    local sum = 0
    for i = 1, #numbers do
        sum = sum + numbers[i]
    end
    local mean = sum / #numbers
    return mean
end


function defPlay(string, index)
  
  local sound
  if index then
    
    for _, prevSound in pairs(gSounds[string]) do
      prevSound:stop()
    end
    if gSounds[string][index] then
      gSounds[string][index]:play()
    end
    
  else
    
    sound = gSounds[string]
    --[[
    if sound == nil then
      print('missing sound:', string)
    end
    ]]
    
    local minTime = 0.1
    local currentTime = sound:tell()
    if currentTime == 0 or currentTime > minTime then
      sound:stop()
      sound:play()
    end
    
  end

end









-- specific functions
function drawTextSpace(text, printX, printY, space, font)
  
  local x = printX or 0
  local y = printY or 0
  
  for i = 1, #text do
    local char = text:sub(i, i)
    love.graphics.print(char, x, y)

    if i < #text then
      local nextChar = text:sub(i + 1, i + 1)
      if not (char:match("%u") and nextChar:match("%u")) then
        x = x + font:getWidth(char) + space
      else
        x = x + font:getWidth(char)
      end
    else
      x = x + font:getWidth(char)
    end
  end
  
end


function separateIntoWords(text)
  local words = {}
  
  for word in text:gmatch("%S+") do
    table.insert(words, word)
  end
  
  return words
end

function wrapTextIntoLines(text, font, maxWidth)
  
  local words = separateIntoWords(text)
  local lines = {}
  local currentLine = ""
  local extraSpace = 1
  
  local function getWordWidthWithExtraSpace(word)
    
    local totalWidth = 0
    for i = 1, #word do
      
      local char = word:sub(i, i)
      totalWidth = totalWidth + font:getWidth(char)
      
      if i < #word then
        
        local nextChar = word:sub(i + 1, i + 1)
        
        if not (char:match("%u") and nextChar:match("%u")) then
          totalWidth = totalWidth + extraSpace
        end
        
      end
    end
    
    return totalWidth
  end

  for i, word in ipairs(words) do
    
    local wordWidth = getWordWidthWithExtraSpace(word)
    local separator = (currentLine == "" and "") or "   "
    local testLine = currentLine .. separator .. word
    local testLineWidth = 0
    
    for j = 1, #testLine do
      local char = testLine:sub(j, j)
      testLineWidth = testLineWidth + font:getWidth(char)
      
      if j < #testLine then
        local nextChar = testLine:sub(j + 1, j + 1)
        
        if not (char:match("%u") and nextChar:match("%u")) then
            testLineWidth = testLineWidth + extraSpace
        end
      end
      
    end

    if testLineWidth > maxWidth then
      table.insert(lines, currentLine)
      currentLine = word
    else
      currentLine = testLine
    end
    
  end
  
  if currentLine ~= "" then
    table.insert(lines, currentLine)
  end
  
  return lines
  
end


function convertMapToText(map)
  
  local lines = {}
  
  for x = 1, nColsMap do
    
    local col = {}
    for y = 1, nRowsMap do
      table.insert(col, map[x][y])
    end
    table.insert(lines, "{" .. table.concat(col, ",") .. "},")
    
  end
  
  return table.concat(lines, "\n")
  
end

function convertTextToMap(data)
  
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


function pushTestStates(texts) -- this can be used to push more than one text state at the same time
  
  if type(texts) == 'string' then
    texts = {texts}
  end
  
  for i = #texts, 1, -1 do
    gStateStack:push(TextState({text = texts[i]}))
  end
end

function iceSlide(currentX, currentY, state)
  local player = state.player
  if not player.hasMoved then
    return
  end
  
  local slideTime = 0.15
  local targetX = currentX
  local targetY = currentY
  if player.direction == 'up' then
    targetY = targetY - 1
  elseif player.direction == 'down' then
    targetY = targetY + 1
  elseif player.direction == 'left' then
    targetX = targetX - 1
  elseif player.direction == 'right' then
    targetX = targetX + 1
  end
  local tileKey, tileData = numberToKeyData(state.map[targetX][targetY])
  if tileData.walkable or tileData.canSlideOnto then
    state.allowInput = false
    Timer.after(slideTime, function()
        player.hasMoved = true
        state.allowInput = true
        state:movePlayerTo(targetX, targetY, tileData)
        state:updateTileOffset()
        state:recalculateCanvas()
        --defPlay('iceSlide')
        
      end)
  end
end


function searchNpc(x, y, state)
  for i, npc in ipairs(state.npcs) do
    if npc.x == x and npc.y == y then
      return npc, i
    end
  end
end

function searchTool(x, y, state)
  for i, tool in ipairs(state.tools) do
    if tool.x == x and tool.y == y then
      return tool, i
    end
  end
end


function triggerPlayerDeathAnimation(state, cause)
  
  -- trigger the animation depending on the cause
  
  
  
  local afterDeathDelay1 = 1
  local afterDeathDelay2 = 2
  Timer.after(afterDeathDelay1, function()
      state.renderCanvasPosition = 0
    end)
  Timer.after(afterDeathDelay2, function()
      state.renderCanvasPosition = #state.canvases
      state.reverseTime = true
      defPlay('timeReverseStart')
    end)
  
  
  
end





function directionSwap(direction)
  
  local directionMatrix = {
  up = 'down',
  down = 'up',
  left = 'right',
  right = 'left',
  }

  return directionMatrix[direction]
  
end


function isVisible(entity, state)
  
  local xDelta = math.abs(entity.x - state.player.x)
  local yDelta = math.abs(entity.y - state.player.y)
  if xDelta <= state.nTilesView and yDelta <= state.nTilesView then
    return true
  else
    return false
  end
  
  
end

