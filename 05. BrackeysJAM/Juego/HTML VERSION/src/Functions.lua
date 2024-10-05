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


function regularAngle(angle)
  
  angle = angle % 2*math.pi
  
  if angle < 0 then
    angle = angle + 2*math.pi
  end

  return angle
  
end

function regularAngleSign(angle)
  
    angle = angle % (2 * math.pi)
    
    if angle >= math.pi then
        angle = angle - 2 * math.pi
    elseif angle < -math.pi then
        angle = angle + 2 * math.pi
    end
    
    return angle
end


function angleDifference(angle1, angle2)
    local diff = angle1 - angle2
    return (diff + math.pi) % (2 * math.pi) - math.pi
end




-- specific functions


function interpolateCatmullRom(p0, p1, p2, p3, t)
  local t2 = t * t
  local t3 = t2 * t

  local x = 0.5 * ((2 * p1.x) + (-p0.x + p2.x) * t + 
                   (2 * p0.x - 5 * p1.x + 4 * p2.x - p3.x) * t2 +
                   (-p0.x + 3 * p1.x - 3 * p2.x + p3.x) * t3)
  
  local y = 0.5 * ((2 * p1.y) + (-p0.y + p2.y) * t + 
                   (2 * p0.y - 5 * p1.y + 4 * p2.y - p3.y) * t2 +
                   (-p0.y + 3 * p1.y - 3 * p2.y + p3.y) * t3)
  
  return {x = x, y = y}
end


function generateSmoothCurve(puntos, subdivisions, cameraOrig)
  
  local camera = cameraOrig or {x = 0, y = 0}
  
  local smoothPoints = {}

  local totalPoints = #puntos

  for i = 1, totalPoints do
      local p0 = puntos[(i - 2) % totalPoints + 1]
      local p1 = puntos[(i - 1) % totalPoints + 1]
      local p2 = puntos[i % totalPoints + 1]
      local p3 = puntos[(i + 1) % totalPoints + 1]

      for t = 0, 1, 1 / subdivisions do
          local interpolatedPoint = interpolateCatmullRom(p0, p1, p2, p3, t)
          table.insert(smoothPoints, interpolatedPoint.x - camera.x)
          table.insert(smoothPoints, interpolatedPoint.y - camera.y)
      end
  end
  
  table.insert(smoothPoints, puntos[1].x - camera.x)
  table.insert(smoothPoints, puntos[1].y - camera.y)
  
  --smoothPoints = removeDuplicatePoints(smoothPoints, 1e-5)

  return smoothPoints
end




function removeDuplicatePoints(points, threshold)
    local newPoints = {}
    for i = 1, #points, 2 do
        local x, y = points[i], points[i+1]
        local duplicate = false
        for j = 1, #newPoints, 2 do
            local nx, ny = newPoints[j], newPoints[j+1]
            if math.abs(x - nx) < threshold and math.abs(y - ny) < threshold then
                duplicate = true
                break
            end
        end
        if not duplicate then
            table.insert(newPoints, x)
            table.insert(newPoints, y)
        end
    end
    return newPoints
end


function calculatePolygonArea(vertices)
    local area = 0
    local numVertices = #vertices / 2

    for i = 1, numVertices do
        local x1, y1 = vertices[(i-1)*2 + 1], vertices[(i-1)*2 + 2]
        local x2, y2 = vertices[(i % numVertices)*2 + 1], vertices[(i % numVertices)*2 + 2]
        area = area + (x1 * y2 - y1 * x2)
    end

    return math.abs(area) / 2
end
