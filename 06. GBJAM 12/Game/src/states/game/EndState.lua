EndState = Class{__includes = BaseState}

function EndState:init(def)
  self.type = 'End'
  
  self.chosenEnding = def.chosenEnding or 1 -- this will change depending on the def parameters
  
  self.endTexts = {
    -- destroy loop without killing the entity
    "You decide to stop the TIME LOOP before permanently dealing with the ENTITY. The VOLCANO erupts, wiping out most life on the planet's surface, including all living beings on the ISLAND. Since you are not protected by ICE, you are also consumed by the lava, meaning all the effort the PRECURSORS invested in you is wasted. With the ENTITY still active, the RITUAL will be repeated indefinitely.",
    
    
    
    -- destroy loop after killing the entity
    "You stop the TIME LOOP after destroying the ENTITY. The VOLCANO erupts, wiping out most life on the planet's surface, including all living beings on the ISLAND. Since you are not protected by ICE, you are also consumed by the lava. However, all the effort the PRECURSORS invested in you was not in vain: in the FUTURE, the species that inhabit this world will be free to choose their own path.",
    
    
    
    -- kill entity and stop eruption
    "You manage to destroy the ENTITY and stop the VOLCANO eruption before it begins. Nearly all the people on the ISLAND survive. Freed from the recent threat, their civilization eventually uncovers all the PRECURSOR ruins and learns of the events that transpired in the past. You too survive, and are allowed to live within society as a symbol of the catastrophe that almost happened. You are both admired and feared.",
    
    
    
    -- kill entity, stop eruption, save last person
    "You manage to destroy the ENTITY and stop the VOLCANO eruption before it begins. Thanks to your perseverance and creativity, everyone on the ISLAND survives. Freed from the recent threat, their civilization eventually uncovers all the PRECURSOR ruins and learns of the events that transpired in the past. You too survive, and are allowed to live within society as a citizen with full rights. You are considered a living legend.",
    
    
  }
  
  defPlay('endState2')
  
  local text = self.endTexts[self.chosenEnding]
  self.delay = 2
  Timer.after(self.delay, function()
      gStateStack:push(TextState({text = text}))
      self.triggerEndScreen = true
      end)
  
  
  
end





function EndState:update(dt)
  
  if self.triggerEndScreen then
    self.triggerEndScreen = false
    Timer.after(self.delay, function()
        self.showEndScreen = true
        defPlay('thanks')
        end)
  end
  
  
  
end



function EndState:render()
  
  love.graphics.setColor(palette[4])
  love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
  
  if self.showEndScreen then
    love.graphics.setColor(colors.white)
    love.graphics.draw(gTextures['endScreen'])
  end
  

end