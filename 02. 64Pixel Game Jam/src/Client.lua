Client = Class{}

function Client:init(def)
  self.state = def.state
  
  self.x = def.x or -10
  self.y = def.y or 3
  
  self.itemsChecked = 0
  self:updateTargetCoordinates()
  --self.targetX = self.x
  --self.targetY = self.y
  
  self.type = def.type or 'default'
  self.special = true
  local nonSpecialTypes = {'default', 'owner', 'magician', 'soldier', 'ranger', 'wizard', 'paladin', 'priest', 'rogue', 'bard', 'barbarian'}
  for _, type in pairs(nonSpecialTypes) do
    if type == self.type then
      self.special = false
    end
  end
  
  
  self.tagValues = {}
  for _, tag in ipairs(tagList) do
    self.tagValues[tag] = 1
  end
  
  local newTagValues = tagValues[self.type]
  for tag, value in pairs(self.tagValues) do
    if newTagValues and newTagValues[tag] then
      self.tagValues[tag] = newTagValues[tag]
    end
  end
  
  self.wealthLimit = 0.4
  --self.wealthFactor = 1
  self.wealthFactor = 1 - self.wealthLimit + math.random(2*self.wealthLimit*100)/100
  
  
  self.iconNumber = characterIcon[self.type]
  
  self.seller = def.seller or false
  self.expert = def.expert or false
  self.speed = def.speed or 20
  
  if self.seller then
    self.item = self:selectSellingItem()
  end
  
  if self.expert then
    self.p1X = 13
    self.p2X = 18
    self.p3X = 23
    self.py = 4
    
    self.expertTimer = 0
    self.expertTimerMax = 0.25
    self.expertTimerMax2 = 1.5
  end
  
  
  self.color = colors.white
  
  self.nCounterOffers = 0
  
  --[[
  self.p1 = true
  self.p2 = true
  self.p3 = true
  ]]
  
  self.owner = def.owner or false
  
  if self.owner and skin then
    self.skinColor = 50 + skin
  else
    self:decideSkinColor()
  end
  

  

  --print(self.type, self.special, self.skinColor)
  

  self:calculateCanvas()

  self.sprite = love.graphics.newCanvas(push:getWidth(), push:getHeight())
  
  love.graphics.setCanvas(self.sprite)
  love.graphics.clear()
  love.graphics.setColor(colors.white)
  if not self.special then
    love.graphics.draw(gTextures['characters'], gFrames['characters'][self.skinColor], 0, 0)
  end
  love.graphics.draw(gTextures['characters'], gFrames['characters'][self.iconNumber], 0, 0)
  --love.graphics.draw(gTextures['characters'], gFrames['characters'][51], 0, 0)
  love.graphics.setCanvas()


end

function Client:update(dt)
  
  

  if math.floor(self.x) ~= self.targetX then
    local xDiff = self.targetX - self.x
    xDiff = xDiff or 0
    self.x = self.x + self.speed*dt*sign(xDiff)
  else
    self.reversed = true
    if math.floor(self.y) ~= self.targetY then
      local yDiff = self.targetY - self.y
      self.y = self.y + self.speed*dt*sign(yDiff)
    end
  end
  
  self.allowOffer = true
  if self.state.expert then --and (not self.state.expert.exit) then
    self.allowOffer = false
  end
  


  if self.seller and (not self.exit) and math.floor(self.x) == self.state.currentSellerX and math.floor(self.y) == self.state.currentSellerY then
    
    if self.allowOffer then
      if not self.offer then
        self:makeOffer(self)
      end
      
      --[[
    else
      print('hiding bubbles')
      self.state.hideBubbles()
      self.offer = false
      self.bubble = false
      ]]
    end
    
    
    
    
    
    
  end
  
  if (not self.seller and not self.expert) and (not self.exit) and math.floor(self.x) == self.targetX and math.floor(self.y) == self.targetY then
    self.itemsChecked = self.itemsChecked + 1
    if self.itemsChecked >= 6 then
      self.exit = true
    else
      self.reverse = false
    end
    
    
    self:updateTargetCoordinates()
    
    -- check item at this position
    local item = self.state.showcasedItems[self.itemsChecked]
    if item.sellValue > 0 then
      local itemTags = itemTags[item.type]
      local valueMult = 1
      for _, tag in pairs(itemTags) do
        local currentValueMult = self.tagValues[tag]
        valueMult = valueMult * currentValueMult
      end
      local itemMaxPrice = item.value * self.wealthFactor * valueMult
      if itemMaxPrice >= item.sellValue then
        local prevMoney = self.state.money
        self.state.money = math.min(self.state.money + item.sellValue, 9999)
        local earntMoney = self.state.money - prevMoney
        earnt = earnt + earntMoney
        --buyer exits store
        self.targetX = math.floor(self.x)
        self.targetY = 8
        self.exit = true
        -- remove item
        removeItem(1, self.itemsChecked, self.state)
        gSounds['cash']:stop()
        gSounds['cash']:play()
        
      end
    end

    
  end

  
  if self.expert then
    
    if self.bubble and (not self.exit) then
      self.expertTimer = self.expertTimer + dt
    end

    if self.expertTimer > self.expertTimerMax then
      self.expertTimer = 0
      if self.calculationsPerformed then
        self.bubble = false
        self.exit = true
      else
        if self.p3 then
          self.calculationsPerformed = true
          self.calculation = self.state.currentSeller.item.value
          self.expertTimerMax = self.expertTimerMax2
        elseif self.p2 then
          self.p3 = true
        elseif self.p1 then
          self.p2 = true
        else
          self.p1 = true
        end
      end
    end
    
    
    if not self.bubble and math.floor(self.x) == self.targetX and math.floor(self.y) == self.targetY then
      self.bubble = true
    end
    
    
    if math.floor(self.x) == -10 and math.floor(self.y) == 10 then
      
      local seller = self.state.currentSeller
      if seller and seller.item and (not seller.bubble) and self.calculation then
        -- change seller offer
        self.state.expert = false
        seller:makeOffer(seller, self.calculation)
        self.calculation = nil
        
      end
      
    end
    
    
    
    --[[
    if math.floor(self.x) == self.targetX and math.floor(self.y) == self.targetY then
      
      
      if self.exit then
        local seller = self.state.currentSeller
        if seller and seller.item and (not seller.bubble) then
          -- change seller offer
          seller:makeOffer(seller, self.calculation)
        end
        
        
        
        
        
        
      else
        if not self.bubble then
          self.bubble = true
        end
      end
    end
    ]]
    
  end
  
  
  
  
  
  if self.exit then
    if math.floor(self.y) == self.targetY then
      self.targetX = -10
    end
    
    if math.floor(self.x) == -10 and math.floor(self.y) == 8 then

      local personalIndex
      for i, client in ipairs(self.state.clients) do
        if client == self then
          personalIndex = i
        end
      end
      if personalIndex then
        table.remove(self.state.clients, personalIndex)
      end
      
      --[[
      if self.expert then
        self.state.expert = nil
        
        
        
        
        
      end
      ]]

    end
    
  end
  
  
  
  
end


function Client:render()
  --love.graphics.setColor(colors.white)
  
  

  love.graphics.setColor(self.color)
  --love.graphics.draw(gTextures['characters'], gFrames['characters'][self.iconNumber], math.floor(self.x), math.floor(self.y))
  if self.reversed then
    love.graphics.draw(self.sprite, math.floor(self.x + 10), math.floor(self.y), 0, -1, 1)
  else
    love.graphics.draw(self.sprite, math.floor(self.x), math.floor(self.y), 0, 1, 1)
  end
  
  
  
  --[[
  if self.bubble then
    love.graphics.setColor(colors.white)
    if self.owner then
      love.graphics.draw(gTextures['bubble2'], math.floor(self.x), 7)
    else
      love.graphics.draw(gTextures['bubble'], math.floor(self.x), math.floor(self.y) - 9)
      if self.expert then
        love.graphics.setColor(colors.black)
        if self.calculation then
          love.graphics.printf(self.calculation, 0, 1, 27, 'right')
        else
          if self.p1 then
            love.graphics.rectangle('fill', self.p1X, self.py, 2, 2)
          end
          if self.p2 then
            love.graphics.rectangle('fill', self.p2X, self.py, 2, 2)
          end
          if self.p3 then
            love.graphics.rectangle('fill', self.p3X, self.py, 2, 2)
          end
        end
        
        
        
      end
      
    end
    
    
    
    if self.item then
      love.graphics.setColor(colors.white)
      self.item:render()
      love.graphics.setColor(colors.black)
      love.graphics.printf(self.offer, 0, 9, 37, 'right')
    end
    
    
  end
  
  ]]
  

end

function Client:selectSellingItem()
  --local chosenItem = 'sword'
  local chosenItem = characterToItem[self.type]
  local item = Item({
      type = chosenItem,
      x1 = self.state.x1,
      y1 = self.state.y1,
      x2 = self.state.x2,
      y2 = self.state.y2,
      printBig = true,
      opacity = 1
    })
  return item
end

function Client:exitStore()
  self.item = nil
  self.bubble = false
  local sellerRemoved
  for i, seller in ipairs(self.state.sellers) do
    if seller == self then
      sellerRemoved = i
    end
  end
  --self.state.sellers[sellerRemoved] = nil
  table.remove(self.state.sellers, sellerRemoved)
  self.targetX = math.floor(self.x)
  self.targetY = 8
  self.exit = true
  self = nil
end

function Client:updateTargetCoordinates()

  local coord = self.state.itemInstructions[self.itemsChecked+1]
  self.targetX = coord.x
  self.targetY = coord.y

  
end

function Client:processOffer(offer)
  self.angerFactor = 0.5
  if self.nCounterOffers >= 2 or offer < self.offer*self.angerFactor then
    self.state:clientOut()
    gSounds['roar']:stop()
    gSounds['roar']:play()
  else
    self.offer = math.floor(0.5*(self.offer + offer))
    self.state.offer = self.offer
    self.nCounterOffers = self.nCounterOffers + 1
  end
  
end



function Client:makeOffer(client, calculation)

  if client.item then
    client.bubble = true
    client.state.owner.bubble = true
    client.state.currentSeller = self
    
    gSounds['pow']:stop()
    gSounds['pow']:play()
    
    
    if not client.offer or not client.state.offer then
      
      client.offer = math.floor(client.item.value * client.wealthFactor)
      if client.special then
        client.offer = specialItemPrices[client.item.type]
      end
      
      
      
      
      if calculation then
        client.offer = math.floor(calculation + 0.5*(client.offer - calculation))
      end
      
      
      client.state.offer = client.offer
    end

    
    for _, button in pairs(client.state.toggableButtons) do
      button.active = true
    end
  end
  
  
end

function Client:renderBubble()
  if self.bubble then
    love.graphics.setColor(colors.white)
    if self.owner then
      love.graphics.draw(gTextures['bubble2'], math.floor(self.x), 7)
    else
      love.graphics.draw(gTextures['bubble'], math.floor(self.x), math.floor(self.y) - 9)
      if self.expert then
        love.graphics.setColor(colors.black)
        if self.calculation then
          love.graphics.printf(self.calculation, 0, 1, 27, 'right')
        else
          if self.p1 then
            love.graphics.rectangle('fill', self.p1X, self.py, 2, 2)
          end
          if self.p2 then
            love.graphics.rectangle('fill', self.p2X, self.py, 2, 2)
          end
          if self.p3 then
            love.graphics.rectangle('fill', self.p3X, self.py, 2, 2)
          end
        end
        
        
      end
      
    end
    
    
    
    if self.item then
      love.graphics.setColor(colors.white)
      self.item:render()
      love.graphics.setColor(colors.black)
      love.graphics.printf(self.offer, 0, 9, 37, 'right')
    end
    
    
  end
end





function Client:decideSkinColor()
  local skinDecider = math.random()
  local currentSkinDecider = 0
  
  for i, skinWeight in ipairs(skinWeights) do
    currentSkinDecider = currentSkinDecider + skinWeight
    if currentSkinDecider >= skinDecider then
      self.skinColor = 50 + i
      return
    end
  end
  
end


function Client:calculateCanvas()
  self.sprite = love.graphics.newCanvas(push:getWidth(), push:getHeight())
  
  love.graphics.setCanvas(self.sprite)
  love.graphics.clear()
  love.graphics.setColor(colors.white)
  love.graphics.draw(gTextures['characters'], gFrames['characters'][self.skinColor], 0, 0)
  love.graphics.draw(gTextures['characters'], gFrames['characters'][self.iconNumber], 0, 0)
  --love.graphics.draw(gTextures['characters'], gFrames['characters'][51], 0, 0)
  love.graphics.setCanvas()
end
