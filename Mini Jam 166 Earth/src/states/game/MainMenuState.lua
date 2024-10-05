MainMenuState = Class{__includes = BaseState}

function MainMenuState:init(def)
  self.type = 'MainMenu'
  
  gSounds['menu']:play()


end


function MainMenuState:update(dt)
  
  if love.anyKeyPressed then
    gStateStack:pop()
    gStateStack:push(IntroState({}))
    gSounds['menu']:stop()
    gSounds['ok']:stop()
    gSounds['ok']:play()
  end

  
end


function MainMenuState:render()
  
  love.graphics.setColor(colors.white)
  love.graphics.draw(gTextures['title'])
  
  love.graphics.setFont(gFonts['small'])
  
  local x = 0
  local y = 100
  love.graphics.setColor(palette[3])
  love.graphics.printf('PRESS ANY KEY TO CONTINUE', x - 1, y + 1, VIRTUAL_WIDTH, 'center')
  love.graphics.setColor(palette[1])
  love.graphics.printf('PRESS ANY KEY TO CONTINUE', x, y, VIRTUAL_WIDTH, 'center')

  

end

