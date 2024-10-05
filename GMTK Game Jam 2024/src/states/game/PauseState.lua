PauseState = Class{__includes = BaseState}

function PauseState:init(def)
    self.type = 'Pause'  
end



function PauseState:update(dt)


end



function PauseState:render()
  
  love.graphics.setColor(0.5, 0.5, 0.5, 0.8)
  love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
  
  love.graphics.setColor(colors.white)
  
  love.graphics.setFont(gFonts['title'])
  love.graphics.printf('Game paused', 0, 200, VIRTUAL_WIDTH, 'center')
  
  love.graphics.setFont(gFonts['medium'])
  love.graphics.printf('Click or press Space to continue', 0, 700, VIRTUAL_WIDTH, 'center')
  love.graphics.printf('Press Escape to quit the game', 0, 850, VIRTUAL_WIDTH, 'center')
  

end
