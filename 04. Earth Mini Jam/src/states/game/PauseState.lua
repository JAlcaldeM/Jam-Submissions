PauseState = Class{__includes = BaseState}

function PauseState:init(def)
  self.type = 'Pause'
  
  battlePosition = 1.05 * gSounds['battle']:tell()
  gSounds['battle']:pause()

end


function PauseState:update(dt)

  --[[
  if love.keyboard.wasPressed('space') then
    gStateStack:pop()
  elseif love.keyboard.wasPressed('escape') then
    love.event.quit()
  end
  ]]
  
end


function PauseState:render()
  
  
  love.graphics.setFont(gFonts['big'])
  love.graphics.setColor(palette[3])
  love.graphics.printf('GAME PAUSED', 9, 21, VIRTUAL_WIDTH - 20, 'center')
  love.graphics.setColor(pauseColor)
  love.graphics.printf('GAME PAUSED', 10, 20, VIRTUAL_WIDTH - 20, 'center')
  
  
  love.graphics.setFont(gFonts['medium'])
  love.graphics.setColor(palette[3])
  love.graphics.printf('SPACE TO RESUME ESCAPE TO CLOSE', -1, 91, VIRTUAL_WIDTH, 'center')
  love.graphics.setColor(pauseColor)
  love.graphics.printf('SPACE TO RESUME ESCAPE TO CLOSE', 0, 90, VIRTUAL_WIDTH, 'center')


end

