require 'src/Dependencies'

function love.load()
    love.window.setTitle('Prototype')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    math.randomseed(os.time())
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = true,
        vsync = true,
        resizable = false,
        canvas = false
    })

    gStateStack = StateStack()
    --gStateStack:push(PlayState())
    gStateStack:push(MenuState())
    --gStateStack:push(InstructionsState())

    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
    love.mouse.keysReleased = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
  --[[
    if key == 'd' then
      local fullscreen = love.window.getFullscreen()
      love.window.setFullscreen(not fullscreen)
    elseif key == 'escape' then
      pause = false
      if instantClose then
        love.event.quit()
      else
        local type = gStateStack:currentType()
        if type == 'Options' or type == 'About' then
          gStateStack:pop()
          playSound('out')
        else
          gStateStack:push(OptionsState({}))
          playSound('ok')
        end
      end

  end
  ]]
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
