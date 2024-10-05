WinState = Class{__includes = BaseState}

function WinState:init(def)
  self.type = 'Win'
  
  gSounds['battle']:stop()
  gSounds['win']:play()

end


function WinState:update(dt)
  
  if love.anyKeyPressed then
    gStateStack:clear()
    gStateStack:push(MainMenuState({}))
  end
  
  
end


function WinState:render()
  
  love.graphics.setFont(gFonts['big'])
  love.graphics.setColor(palette[3])
  love.graphics.printf('YOU BEAT THE GAME!', 9, 21, VIRTUAL_WIDTH - 20, 'center')
  love.graphics.setColor(winColor)
  love.graphics.printf('YOU BEAT THE GAME!', 10, 20, VIRTUAL_WIDTH - 20, 'center')
  
  
  love.graphics.setFont(gFonts['medium'])
  love.graphics.setColor(palette[3])
  love.graphics.printf('PRESS ANY KEY TO CONTINUE', -1, 91, VIRTUAL_WIDTH, 'center')
  love.graphics.setColor(winColor)
  love.graphics.printf('PRESS ANY KEY TO CONTINUE', 0, 90, VIRTUAL_WIDTH, 'center')
  

end

