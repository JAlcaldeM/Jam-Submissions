StoreState = Class{__includes = BaseState}

function StoreState:init(def)
  self.type = 'Store'
  
  self.buttons = {}
  
  gSounds['downtownglow']:play()
  
 
  
  local storageButton = Button{
    x = 2,
    y = 0,
    width = 60,
    height = 10,
    onClick = function()
      gSounds['ok']:stop()
      gSounds['ok']:play()
      gStateStack:push(StorageState({items = self.items, money = self.money, source = 'store'}))
      end
  }
  table.insert(self.buttons, storageButton)
   --[[
  local buyButton = Button{
    x = 52,
    y = 42,
    width = 10,
    height = 10,
    onClick = function()
      if self.currentSeller and self.currentSeller.item.sellValue <= self.money then
        local itemSpaceData = freeItemSpace(self.items)
        if itemSpaceData then          
          local item = self.currentSeller.item
          item.printBig = false
          self.currentSeller:exitStore()
          self.money = self.money - item.sellValue
          self.items[itemSpaceData.col][itemSpaceData.row] = item
          if itemSpaceData.visible then
            self.showcasedItems[itemSpaceData.col] = item
            item.x1 = 2 + 10*(itemSpaceData.col-1)
            item.y1 = 0
          end
          for _, button in pairs(self.toggableButtons) do
            button.active = false
          end
          self.owner.bubble = false
        else
          -- not storage space
        end
      else
        -- not buyer or not money
      end
    end
  }
  table.insert(self.buttons, buyButton)
  ]]
  
  
  
  
  
  self.okButton = Button{
    x = 2,
    y = 28,
    size = 8,
    iconNumber = 2,
    active = false,
    onClick = function()
      if self.currentSeller and self.currentSeller.item.sellValue <= self.money then
        local itemSpaceData = freeItemSpace(self.items)
        if itemSpaceData then  
          local item = self.currentSeller.item
          self.money = self.money - self.offer
          spent = spent + self.offer
          item.sellValue = math.floor(self.offer*(cut/100 + 1))
          item.printBig = false
          self.items[itemSpaceData.col][itemSpaceData.row] = item
          if itemSpaceData.visible then
            self.showcasedItems[itemSpaceData.col] = item
            item.x1 = 2 + 10*(itemSpaceData.col-1)
            item.y1 = 0
          end
          
          self:clientOut()
          gSounds['coin']:stop()
          gSounds['coin']:play()

        else
          -- not storage space
        end
      else
        -- not buyer or not money
      end
    end
  }
  table.insert(self.buttons, self.okButton)

  self.offerButton = Button{
    x = 2,
    y = 28,
    size = 8,
    iconNumber = 3,
    active = false,
    onClick = function()
      gSounds['pow']:stop()
      gSounds['pow']:play()
      self.currentSeller:processOffer(self.offer)
    end
  }
  table.insert(self.buttons, self.offerButton)

  
  self.noButton = Button{
    x = 2,
    y = 36,
    size = 8,
    iconNumber = 4,
    active = false,
    onClick = function()
      gSounds['roar']:stop()
      gSounds['roar']:play()
      self:clientOut()
    end
  }
  table.insert(self.buttons, self.noButton)
  
  
  self.callButton = Button{
    x = 2,
    y = 54,
    size = 8,
    iconNumber = 6,
    active = false,
    onClick = function()
      gSounds['ok']:stop()
      gSounds['ok']:play()
      local item = self.currentSeller.item
      local mainTag = item.tags[1]
      self.expert = Client{
        state = self,
        expert = true,
        type = 'owner', -- change to depend on mainTag
        
      }
      self.expert.targetX = 10
      self.expert.targetY = 10
      table.insert(self.clients, self.expert)
      self:hideBubbles()
      
      
    end
  }
  table.insert(self.buttons, self.callButton)
  
  self.downButton = Button{
    x = 8,
    y = 14,
    size = 5,
    iconNumber = 1,
    active = false,
    onClick = function()
      gSounds['tip']:stop()
      gSounds['tip']:play()
      self.offerDecrease = true
    end
  }
  table.insert(self.buttons, self.downButton)
  
  self.upButton = Button{
    x = 13,
    y = 14,
    size = 5,
    iconNumber = 2,
    active = false,
    onClick = function()
      gSounds['tip']:stop()
      gSounds['tip']:play()
      self.offerIncrease = true
      self.offer = self.offer + 1
    end
  }
  table.insert(self.buttons, self.upButton)
  
  self.toggableButtons = {self.okButton, self.offerButton, self.noButton, self.bookButton, self.callButton, self.downButton, self.upButton}

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  --[[
  presetItems = {}
  possiblePresetTypes = {'empty'}--{'sword', 'glassball', 'empty'}
  for i = 1, 24 do
    presetItems[i] = Item{
      type = possiblePresetTypes[math.random(#possiblePresetTypes)]
      
      }
  end
  
  if def.items then
    self.items = def.items
  else
    self.item1 = def.item1 or {presetItems[1], presetItems[2], presetItems[3], presetItems[4]}
    self.item2 = def.item2 or {presetItems[5], presetItems[6], presetItems[7], presetItems[8]}
    self.item3 = def.item3 or {presetItems[9], presetItems[10], presetItems[11], presetItems[12]}
    self.item4 = def.item4 or {presetItems[13], presetItems[14], presetItems[15], presetItems[16]}
    self.item5 = def.item5 or {presetItems[17], presetItems[18], presetItems[19], presetItems[20]}
    self.item6 = def.item6 or {presetItems[21], presetItems[22], presetItems[23], presetItems[24]}
    
    self.items = {self.item1, self.item2, self.item3, self.item4, self.item5, self.item6}
  end
  ]]
  
  
  self.money = def.money or 5555
  
  
  
  
  
  if def.items then
    self.items = def.items
  else
    
    local startingItems = {}
    local possibleStartingItems = {'glassball','sword','bow','spellbook','hammer','staff','daggers','lute','axe'}
    local startingMoney = 1000
    
    for i = 1, 3 do

      local type = possibleStartingItems[math.random(#possibleStartingItems)]
      print(type)
      local item
      startingItems[i] = Item{
        type = type
      }
      startingMoney = startingMoney - defaultItemValue[type]
    end
    
    local emptyItems = {}
    for i = 1, 21 do
      emptyItems[i] = Item{
        type = 'empty'
        }
    end
    
    self.money = startingMoney
    
    
    
    self.item1 = def.item1 or {startingItems[1], emptyItems[1], emptyItems[2], emptyItems[3]}
    self.item2 = def.item2 or {startingItems[2], emptyItems[4], emptyItems[5], emptyItems[6]}
    self.item3 = def.item3 or {startingItems[3], emptyItems[8], emptyItems[9], emptyItems[10]}
    self.item4 = def.item4 or {emptyItems[11], emptyItems[12], emptyItems[13], emptyItems[14]}
    self.item5 = def.item5 or {emptyItems[15], emptyItems[16], emptyItems[17], emptyItems[18]}
    self.item6 = def.item6 or {emptyItems[19], emptyItems[20], emptyItems[21], emptyItems[22]}
    
    self.items = {self.item1, self.item2, self.item3, self.item4, self.item5, self.item6}
  end
  
  
  for i, itemCol in ipairs(self.items) do
    rearrangeItems(itemCol)
  end
  
  for i, itemCol in ipairs(self.items) do
    for j, item in ipairs(itemCol) do
      item.row = j
      item.col = i
      item.printBig = false
    end
  end
  
  
  
  self.showcasedItems = {}
  for i, itemCol in ipairs(self.items) do
    local item = itemCol[1]
    table.insert(self.showcasedItems, item)
    item.x1 = 2 + 10*(i-1)
    item.y1 = 0
  end
  
  self.itemInstructions = {
    {x = 2, y = 3},
    {x = 12, y = 3},
    {x = 22, y = 3},
    {x = 32, y = 3},
    {x = 42, y = 3},
    {x = 52, y = 3},
    {x = 52, y = 8, exit = true},
    
    }
  
  
  

  
  self.x1 = 10
  self.y1 = 20
  self.x2 = 10
  self.y2 = 32
  
  self.clients = {}
  self.sellers = {}
  
  print(skin)
  self.owner = Client{
    state = self,
    x = 1,
    y = 18,
    type = job,
    skinColor = skin,
    owner = true,
    
    
  } 
  
  self.currentSellerX = 20
  self.currentSellerY = 18
  
  
  --[[
  local startingClient = Client({
      state = self,
      seller = true,
      
      })
  table.insert(self.clients, startingClient)
  
  table.insert(self.sellers, startingClient)
  ]]
  
  
--[[
  local client1 = Client({
      state = self,
      })
  table.insert(self.clients, client1)
  
  
  local client2 = Client({
      state = self,
      x = 20,
      y = 8,
      })
  table.insert(self.clients, client2)
  
  local client3 = Client({
      state = self,
      x = 30,
      y = 9,
      })
  table.insert(self.clients, client3)
]]

  buyerTime = 0
  buyerTimeMax = 5
  
  sellerTime = 7.5
  sellerTimeMax = 10
  
  
  self.clock = 0
  self.clockAngle = 0
  self.clockMax = 60 
  self.clockUpdate = 1
  self.clockUpdateMax = 1
  
  self.offerChangeRate1 = 10
  self.offerChangeRate2 = 50
  self.offerFast = false
  self.offerTimer = 0
  self.offerTimerMax = 1
  
  self.acceptPrice = true
  
  self.dayEnding = false
  
  self.newClients = true
  self.newSellers = true
  
  self.specialSellerClock = 0
  self.specialSellerClockMax = 30
  self.specialSeller = false
  self.specialSellerAllowed = true
  

end


function StoreState:update(dt)

  


  local x, y = push:toGame(love.mouse.getPosition())
  
  for _, button in pairs(self.buttons) do
    if button.active and button:mouseIsOver(x, y) then
      button:onHover()
      if love.mouse.wasPressed(1) then
        button:onClick()
      end
    else
      button:notOnHover()
    end
  end
  
  
  
  
  
  
  for _, client in pairs(self.clients) do
    client:update(dt)
  end
  
  
  
  if self.offerDecrease or self.offerIncrease then
    local offerChangeRate
    if self.offerFast then
      offerChangeRate = self.offerChangeRate2
    else
      offerChangeRate = self.offerChangeRate1
    end
    
    
    self.offerTimer = self.offerTimer + dt
    if self.offerTimer >= self.offerTimerMax then
      self.offerFast = true
    end
    
    if self.offerDecrease then
      self.offer = self.offer - offerChangeRate*dt
      if self.offer <= 1 then
        self.offer = 1
      end
    elseif self.offerIncrease then
      self.offer = self.offer + offerChangeRate*dt
    end
    
  end
  
  
  if love.mouse.wasReleased(1) then
    self.offerIncrease = false
    self.offerDecrease = false
    self.offerFast = false
    self.offerTimer = 0
    if self.offer then
      self.offer = math.floor(self.offer)
    end
  end
  

  if self.offer and self.currentSeller.offer then
    if self.offer >= self.currentSeller.offer then
      self.okButton.active = true
      self.offerButton.active = false
    else
      self.okButton.active = false
      self.offerButton.active = true
    end
  end

  
  --[[
  
  local prevAcceptOffer = self.acceptOffer
  
  if self.offer then
    if self.offer >= self.currentSeller.offer then
      self.acceptOffer = true
    else
      self.acceptOffer = false
    end
  end
  
  if not (prevAcceptOffer == self.acceptOffer) then
    self.okButton.active = self.acceptOffer
    self.offerButton.active = not self.acceptOffer
  end
  
  ]]

  if self.dayEnding and #self.clients == 0 then
    gStateStack:push(EnddayState({items = self.items, money = self.money}))
  end
  
  
  if self.dayEnding then
    return
  end
  
  for i, seller in ipairs(self.sellers) do
    seller.targetX = 20 + 10*(i-1)
    seller.targetY = self.currentSellerY
  end
  
  
  if self.newClients then
    buyerTime = buyerTime + dt
    if buyerTime >= buyerTimeMax then
      buyerTime = 0
      local newBuyer = Client({
        state = self,
        type = 'wizard',
        })
        table.insert(self.clients, newBuyer)
    end
  end
  
  
  if self.newSellers then
    sellerTime = sellerTime + dt
    
    if self.specialSellerAllowed then
      self.specialSellerClock = self.specialSellerClock + dt
      if self.specialSellerClock >= self.specialSellerClockMax then
        self.specialSeller = true
        self.specialSellerClock = 0
        self.specialSellerAllowed = false
        --print('next seller will be special')
      end
    end
    
    
    
    if sellerTime >= sellerTimeMax and #self.sellers <= 3 then
      sellerTime = 0
      
      local isSellerSpecial = self.specialSeller
      if isSellerSpecial then
        --print('specialSeller is disallowed')
        self.specialSeller = false
      end
      
      local sellerType
      sellerType = self:selectSellerType(isSellerSpecial)
      
      local newSeller = Client({
        state = self,
        seller = true,
        type = sellerType,
        })
      table.insert(self.clients, newSeller)
      table.insert(self.sellers, newSeller)
    end
  
  
  
  end
  
  
  
  
  
  local lastFrame = false
  self.clock = self.clock + dt
  if self.clock >= self.clockMax then
    self.clock = 0
    lastFrame = true
  end
  
  self.clockUpdate = self.clockUpdate + dt
  
  if lastFrame or self.clockUpdate >= self.clockUpdateMax then

    self.clockUpdate = 0
    
    self.clockAngle = 2*math.pi*self.clock/self.clockMax
    if self.clockAngle >= 2*math.pi then
      self.clockAngle = 0
    end

    self.clockX = 10.5 + math.sin(self.clockAngle)*9.9
    self.clockY = 10.5 - math.cos(self.clockAngle)*9.9
    

    
    self.clockCanvas = love.graphics.newCanvas(21, 21)
    love.graphics.setCanvas(self.clockCanvas)
    love.graphics.setColor(colors.black)
    
    love.graphics.setLineStyle('rough')
    love.graphics.setLineWidth(1.5)
    love.graphics.line(10.5, 10.5, self.clockX, self.clockY)
    love.graphics.setCanvas()
    
    
  end
  
  if lastFrame then
    self:endDay()
  end
  
  
  
  --[[
  --activate if problems with effects not killing bubbles
  if self.dayEnding and (self.owner or self.offer) then
    self:hideBubbles()
  end

  
  print(#self.clients, self.owner, self.offer)
  ]]
  
  self.inputAllowed = true
  
  
end



function StoreState:render()
  
  love.graphics.setColor(colors.white)
  love.graphics.draw(gTextures['store'], 0, 0)
  
  
  
  -- draw items
  for _, item in pairs(self.showcasedItems) do
    item:render()
  end
  
  
  
  
  
  -- glass frame
  love.graphics.setColor(colors.white)
  for i = 1,6 do
    love.graphics.draw(gTextures['icons'], gFrames['icons'][3], 2 + 10*(i-1), 0)
  end

  --glass
  love.graphics.setColor(colors.windowColor)
  for i = 1,6 do
    love.graphics.rectangle('fill', 3 + 10*(i-1), 1, 8, 8)
  end
  
  
  love.graphics.setColor(colors.white)

  for i = #self.clients, 1, -1 do
    self.clients[i]:render()
  end
  
  for i = #self.sellers, 1, -1 do
    self.sellers[i]:render()
  end
  
  
  self.owner:render()
  self.owner:renderBubble()
  
  love.graphics.setColor(colors.black)
  
  if self.offer and self.owner.bubble then
    love.graphics.printf(math.floor(self.offer), 0, 7, 18, 'right')
    
    love.graphics.setColor(colors.white)
    love.graphics.draw(gTextures['vbubble'], 1, 24)
  end
  
  for _, seller in ipairs(self.sellers) do
    seller:renderBubble()
  end
  
  if self.expert and self.currentSeller.item then
    self.currentSeller.item:render()
    if not self.expert.exit then
      self.expert:renderBubble()
    end
  end
  
  
  
  for _, button in pairs(self.buttons) do
    if button.active then
      button:render()
    end
  end
  
  
  
  
  love.graphics.setColor(colors.black)
  love.graphics.printf(self.money, 0, 55, 62, 'right')
  
  if self.clockCanvas then
    love.graphics.draw(self.clockCanvas, 41, 32)
  end
  
  
  
end


function StoreState:clientOut()
  self.currentSeller:exitStore()
  self:hideBubbles()
end

function StoreState:hideBubbles()
  if self then
    for _, button in pairs(self.toggableButtons) do
      button.active = false
    end
    
    self.owner.bubble = false
    self.offer = false
    
    
    self.currentSeller.bubble = false
    self.offer = false
    self.currentSeller.offer = false
    
    
  end
  

  
end



function StoreState:endDay()
  
  gSounds['downtownglow']:stop()
  gSounds['finalbell']:play()
  
  self.dayEnding = true
  for _, client in pairs(self.clients) do
    client.targetY = 8
    client.exit = true
    client.bubble = false
  end
  
  if self.currentSeller then
    self.currentSeller.bubble = false
    self.offer = false
    self.owner.bubble = false
    for _, button in pairs(self.toggableButtons) do
      button.active = false
    end
    
  end
  
  
  
end


function StoreState:selectSellerType(isSellerSpecial)
  
  local sellerType
  
  if isSellerSpecial then
    sellerType = currentSpecialCharacterList[math.random(#currentSpecialCharacterList)]
    for i = #currentSpecialCharacterList, 1, -1 do
      if currentSpecialCharacterList[i] == sellerType then
        table.remove(currentSpecialCharacterList, i)
      end
      
    end
    
  else
    sellerType = normalCharacterList[math.random(#normalCharacterList)]
  end
  
  --print(sellerType)
  return sellerType
  
end


