require 'src/Dependencies'

function love.load()
    love.window.setTitle('Zen Fish')
   -- love.graphics.setDefaultFilter('nearest', 'nearest')
   love.graphics.setDefaultFilter('linear', 'linear')
    math.randomseed(os.time())
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = false,
        canvas = false,
    })

    gStateStack = StateStack()
    --gStateStack:push(PlayState({}))
    gStateStack:push(MainMenuState({}))

    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
    love.mouse.keysReleased = {}
    love.mouse.params = {}
    
    --love.mouse.setVisible(false)
    --love.mouse.setRelativeMode(true)
    
    --[[
    for i = 1, 5 do
      Timer.after(0.5*i, function() playPop(i) end)
    end
    ]]
    
    gSounds['music2']:play()
    
    
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.anyKeyPressed = true
    love.keyboard.keysPressed[key] = true
end

function love.mousepressed(x, y, key)
    love.mouse.keysPressed[key] = true
end

function love.mousereleased(x, y, key)
    love.mouse.keysReleased[key] = true 
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.mouse.wasPressed(key)
    return love.mouse.keysPressed[key]
end

function love.mouse.wasReleased(key)
    return love.mouse.keysReleased[key]
end
--[[
function love.mousemoved(x, y, dx, dy, istouch)
  --print('x:', x, 'y:', y, 'dx:', dx, 'dy:', dy, 'istouch:', istouch)
    love.mouse.params = {
      x = x,
      y = y,
      dx = dx,
      dy = dy,
      istouch = istouch,
      }
end
]]

function love.update(dt)
  
  x, y = push:toGame(love.mouse.getPosition())
  
  if x == nil then
    x = prevX
  end
  if y == nil then
    y = prevY
  end
  
  prevX = x
  prevY = y

  if not (gStateStack:currentType() == 'Pause') then
    Timer.update(dt)
    gStateStack:update(dt)
  elseif love.mouse.wasPressed(1) or love.mouse.wasPressed(2) then
    gStateStack:pop()
  end
  
  --[[
  if love.keyboard.wasPressed('f') then
    local isFullscreen = love.window.getFullscreen()
    love.window.setFullscreen(not isFullscreen)
  end
  ]]
  
  --[[
  
  if love.keyboard.wasPressed('escape') then
    if gStateStack:currentType() == 'Pause' then
      love.event.quit()
    elseif gStateStack:currentType() == 'Play' then
      gStateStack:push(PauseState({}))
      gSounds['pause']:play()
    end
  end
  
  if love.keyboard.wasPressed('space') then
    if gStateStack:currentType() == 'Pause' then
      gStateStack:pop()
      gSounds['battle']:seek(battlePosition)
      gSounds['battle']:play()
      gSounds['unpause']:play()
    elseif gStateStack:currentType() == 'Play' then
      gStateStack:push(PauseState({}))
      gSounds['pause']:play()
    end
  end
  
  
  
  ]]
  
  
  
  --[[
  if love.keyboard.wasPressed('escape') then
      love.event.quit()
  end
  ]]
  


    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
    love.mouse.keysReleased = {}
    love.mouse.params = {}
    love.anyKeyPressed = false
end

function love.draw()
    push:start()
    gStateStack:render()
    
    if showFPS then
      love.graphics.setFont(gFonts['newSmall'])
      love.graphics.setColor(colors.cyan)
      love.graphics.print("FPS: "..love.timer.getFPS(), 2, 2)
      
      local x, y = push:toGame(love.mouse.getPosition())
      --[[
      if x then
        love.graphics.print('x: '..x, 2, 6)
      end
      if y then
        love.graphics.print('y: '..y, 2, 9)
      end
      ]]
    end
    
    
    
    push:finish()
end

