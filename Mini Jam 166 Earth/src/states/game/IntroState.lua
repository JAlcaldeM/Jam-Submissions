IntroState = Class{__includes = BaseState}

function IntroState:init(def)
  self.type = 'Intro'
  
  

end


function IntroState:update(dt)
  
  if love.anyKeyPressed then
    gStateStack:pop()
    gStateStack:push(PlayState({}))
    gSounds['ok']:stop()
    gSounds['ok']:play()
  end

end


function IntroState:render()
  
  love.graphics.setColor(palette[4])
  love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

  love.graphics.setFont(gFonts['medium'])
  love.graphics.setColor(palette[3])
  love.graphics.printf('OBJECTIVE: DEFEND EARTH FOR 2 MINUTES', -1, 21, VIRTUAL_WIDTH, 'center')
  love.graphics.setColor(palette[1])
  love.graphics.printf('OBJECTIVE: DEFEND EARTH FOR 2 MINUTES', 0, 20, VIRTUAL_WIDTH, 'center')
  
  
  love.graphics.setFont(gFonts['small'])
  love.graphics.setColor(palette[3])
  love.graphics.printf('MOVE WITH A-D OR ARROW KEYS', -1, 91, VIRTUAL_WIDTH, 'center')
  love.graphics.setColor(palette[1])
  love.graphics.printf('MOVE WITH A-D OR ARROW KEYS', 0, 90, VIRTUAL_WIDTH, 'center')
  love.graphics.setColor(palette[3])
  love.graphics.printf('AUTO-SHOOT IS ENABLED', -1, 111, VIRTUAL_WIDTH, 'center')
  love.graphics.setColor(palette[1])
  love.graphics.printf('AUTO-SHOOT IS ENABLED', 0, 110, VIRTUAL_WIDTH, 'center')
end

