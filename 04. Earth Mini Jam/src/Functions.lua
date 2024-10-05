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




-- specific functions

