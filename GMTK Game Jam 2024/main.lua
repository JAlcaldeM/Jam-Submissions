require 'src/Dependencies'

function love.load()
    love.window.setTitle('The Perfect Cut')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    math.randomseed(os.time())
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = true,
        vsync = true,
        
        resizable = true,
        canvas = false
    })

    gStateStack = StateStack()
    gStateStack:push(MainMenuState({}))
    --gStateStack:push(TestState({level = 8,}))
    --gStateStack:push(FinalState({}))
    --gStateStack:push(TestState({level = 1,}))
    --gStateStack:push(OutLevelState({level = 1,}))
    
    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
    love.mouse.keysReleased = {}
    
    love.mouse.setVisible(false)
    
    
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)

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

function love.update(dt)

  if not (gStateStack:currentType() == 'Pause') then
    Timer.update(dt)
    gStateStack:update(dt)
  elseif love.mouse.wasPressed(1) or love.mouse.wasPressed(2) then
    gStateStack:pop()
  end
  
  
  if love.keyboard.wasPressed('f') then
    local isFullscreen = love.window.getFullscreen()
    love.window.setFullscreen(not isFullscreen)
  end
  
  if love.keyboard.wasPressed('escape') then
    if gStateStack:currentType() == 'Pause' then
      love.event.quit()
    else
      gStateStack:push(PauseState({}))
      gSounds['pause']:play()
    end
  end
  
  if love.keyboard.wasPressed('space') then
    if gStateStack:currentType() == 'Pause' then
      gStateStack:pop()
      gSounds['unpause']:play()
    else
      gStateStack:push(PauseState({}))
      gSounds['pause']:play()
    end
  end
  
  


    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
    love.mouse.keysReleased = {}
end

function love.draw()
    push:start()
    gStateStack:render()
    
    if showFPS then
      love.graphics.setFont(gFonts['small'])
      love.graphics.setColor(colors.cyan)
      love.graphics.print("FPS: "..love.timer.getFPS(), 20, 20)
      
      local x, y = push:toGame(love.mouse.getPosition())
      if x then
        love.graphics.print('x: '..x, 20, 60)
      end
      if y then
        love.graphics.print('y: '..y, 20, 90)
      end
    end
    
    
    
    push:finish()
end

