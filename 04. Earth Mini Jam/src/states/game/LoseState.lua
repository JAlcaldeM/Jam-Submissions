LoseState = Class{__includes = BaseState}

function LoseState:init(def)
  self.type = 'Lose'
  
  gSounds['battle']:stop()
  gSounds['lose']:play()


end


function LoseState:update(dt)
  
  if love.anyKeyPressed then
    gStateStack:clear()
    gStateStack:push(MainMenuState({}))
  end
  
  
end


function LoseState:render()
  
  love.graphics.setFont(gFonts['big'])
  love.graphics.setColor(palette[3])
  love.graphics.printf('GAME OVER', 19, 21, VIRTUAL_WIDTH - 40, 'center')
  love.graphics.setColor(loseColor)
  love.graphics.printf('GAME OVER', 20, 20, VIRTUAL_WIDTH - 40, 'center')
  
  
  love.graphics.setFont(gFonts['medium'])
  love.graphics.setColor(palette[3])
  love.graphics.printf('PRESS ANY KEY TO CONTINUE', -1, 91, VIRTUAL_WIDTH, 'center')
  love.graphics.setColor(loseColor)
  love.graphics.printf('PRESS ANY KEY TO CONTINUE', 0, 90, VIRTUAL_WIDTH, 'center')
  

end

