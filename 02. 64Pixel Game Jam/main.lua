require 'src/Dependencies'

function love.load()
    love.window.setTitle('64 Pixel Store')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    math.randomseed(os.time())
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = false,
        pixelperfect = true,
        canvas = false
    })

    gStateStack = StateStack()
    --gStateStack:push(StorageState({}))
    --gStateStack:push(StoreState({}))
    --gStateStack:push(EnddayState({}))
    --gStateStack:push(ScoreState({}))
    gStateStack:push(MainMenuState({}))
    
    font = gFonts['8']
    love.graphics.setFont(font)

    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
    love.mouse.keysReleased = {}
    
    
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
  if not pause then
    Timer.update(dt)
    gStateStack:update(dt)
  end
  --[[
  if love.keyboard.wasPressed('f') then
    local isFullscreen = love.window.getFullscreen()
    love.window.setFullscreen(not isFullscreen)
    print(push:getWidth(), push:getHeight())

    for i, state in pairs(gStateStack.states) do
      if state.clients then
        for _, client in pairs(state.clients) do
          client:calculateCanvas()
        end
      end
      if state.owner then
        state.owner:calculateCanvas()
      end
      
    end

  end
  ]]

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
    end
    
    push:finish()
end

