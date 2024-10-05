StorageState = Class{__includes = BaseState}

function StorageState:init(def)
  self.type = 'Storage'
  
  self.money = def.money or 5555
  self.source = def.source or nil
  
  presetItems = {}
  possiblePresetTypes = {'sword', 'glassball', 'empty'}
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

  for i, itemCol in ipairs(self.items) do
    rearrangeItems(itemCol)
  end

  
  for i, itemCol in ipairs(self.items) do
    for j, item in ipairs(itemCol) do
      item.row = j
      item.col = i
      item.x1 = 2 + 10*(i-1)
      local yOffset
      if j == 1 then
        yOffset = 0
      else
        yOffset = 4 + 11*(j-1)
      end
      item.y1 = 2 + yOffset
      item.printBig = false
    end
  end
  
  
  self.buttons = {}
  local okButton = Button{
    x = 52,
    y = 52,
    onClick = function() 
      gSounds['tip']:stop()
      gSounds['tip']:play()
      for i, itemCol in ipairs(self.items) do
        itemCol[1].y1 = 0
      end
      if self.source == 'endday' then
        gStateStack:pop()
        gStateStack:push(StoreState({items = self.items, money = self.money}))
      else
        gStateStack:pop()
      end
      
      
      end
  }
  table.insert(self.buttons, okButton)
  
  
  local cutMinusButton = Button{
    x = 19,
    y = 57,
    size = 5,
    onClick = function()
      gSounds['tip']:stop()
      gSounds['tip']:play()
      self.cutDecrease = true
      end
  }
  table.insert(self.buttons, cutMinusButton)
  
  local cutPlusButton = Button{
    x = 19,
    y = 52,
    size = 5,
    onClick = function()
      gSounds['tip']:stop()
      gSounds['tip']:play()
      self.cutIncrease = true
      cut = cut + 0.5
      end
  }
  table.insert(self.buttons, cutPlusButton)
  
  self.changePriceButtons = {}
  local minusButton = Button{
    x = 46,
    y = 57,
    size = 5,
    onClick = function()
      gSounds['tip']:stop()
      gSounds['tip']:play()
      self.priceDecrease = true
      end
  }
  table.insert(self.changePriceButtons, minusButton)
  
  local plusButton = Button{
    x = 46,
    y = 52,
    size = 5,
    onClick = function()
      gSounds['tip']:stop()
      gSounds['tip']:play()
      self.priceIncrease = true
      self.priceItem.sellValue = self.priceItem.sellValue + 1
      end
  }
  table.insert(self.changePriceButtons, plusButton)
  
  --[[
  
  
  self.money = 9999
  
  self.x1 = 10
  self.y1 = 20
  self.x2 = 0
  self.y2 = 30
  
  self.clients = {}
  local startingClient = Client({
      state = self,
      seller = true
      })
  table.insert(self.clients, startingClient)
  
  self.currentSellerX = 20
  self.currentSellerY = 20
  self.sellers = {}
  table.insert(self.sellers, startingClient)
  ]]
  
  --[[
  self.input = true
  self.timeUntilInput = 0
  self.maxTimeUntilInput = 1
  ]]
  
  self.priceChangeRate1 = 10
  self.priceChangeRate2 = 50
  self.priceFast = false
  self.priceTimer = 0
  self.priceTimerMax = 1
  
  self.cutChangeRate = 10
  
  
end


function StorageState:update(dt)
  --[[
  if not self.input then
    self.timeUntilInput = self.timeUntilInput + dt
    if self.timeUntilInput >= self.maxTimeUntilInput then
      self.input = true
      self.timeUntilInput = 0
    end
    return
  end
  ]]

  local x, y = push:toGame(love.mouse.getPosition())
  
  self.hoverItem = nil
  self.priceItem = nil
  
  for i, itemCol in ipairs(self.items) do
    for j, item in ipairs(itemCol) do
      if item:mouseIsOver(x, y) and self.selectAllowed then
        self.hoverItem = item
        --item:onHover()
        if love.mouse.wasPressed(1) then
          self.selectAllowed = false
          if not self.selectedItem then
            --print('a new item was selected')
            self.selectedItem = item
            item.selected = true
          else
            --print('items are being swapped')
            self:swapItems(self.selectedItem, item)
            self.deleteSelectedItem = true
           -- self.selectAllowed = false
          end
        end
      end
    end
  end
  
  self.selectAllowed = true
  
  if self.selectedItem then
    self.priceItem = self.selectedItem
  elseif self.hoverItem then
    self.priceItem = self.hoverItem
  end
  
  
  
  
  
  for _, button in pairs(self.buttons) do
    if button:mouseIsOver(x, y) then
      button:onHover()
      if love.mouse.wasPressed(1) then
        button:onClick()
      end
    else
      button:notOnHover()
    end
  end
  
  if self.selectedItem and self.selectedItem.sellValue > 0 then
    for _, button in pairs(self.changePriceButtons) do
      if button:mouseIsOver(x, y) then
        
        button:onHover()
        if love.mouse.wasPressed(1) then
          button:onClick()
        end
      else
        button:notOnHover()
      end
    end
  end
  
  if love.mouse.wasReleased(1) then
    self.priceIncrease = false
    self.priceDecrease = false
    self.priceFast = false
    self.priceTimer = 0
    if self.priceItem then
      self.priceItem.sellValue = math.floor(self.priceItem.sellValue)
    end
    
    self.cutIncrease = false
    self.cutDecrease = false
  end
  
  
  if self.priceDecrease or self.priceIncrease then
    local priceChangeRate
    if self.priceFast then
      priceChangeRate = self.priceChangeRate2
    else
      priceChangeRate = self.priceChangeRate1
    end
    
    
    self.priceTimer = self.priceTimer + dt
    if self.priceTimer >= self.priceTimerMax then
      self.priceFast = true
    end
    
    if self.priceDecrease then
      self.priceItem.sellValue = self.priceItem.sellValue - priceChangeRate*dt
      if self.priceItem.sellValue <= 1 then
        self.priceItem.sellValue = 1
      end
    elseif self.priceIncrease then
      self.priceItem.sellValue = self.priceItem.sellValue + priceChangeRate*dt
    end
    
  end
  
  
  
  if self.deleteSelectedItem then
    self.selectedItem.selected = false
    self.selectedItem = nil
    self.deleteSelectedItem = false
    cut = math.floor(cut)
  end
  
  if self.cutIncrease then
    cut = math.min(99,cut + self.cutChangeRate*dt)
  elseif self.cutDecrease then
    cut = math.max(0,cut - self.cutChangeRate*dt)
  end
  
  
  
  --[[
  for i, seller in ipairs(self.sellers) do
    seller.targetX = 20 + 10*(i-1)
    seller.targetY = 20
  end
  
  
  
  for _, client in pairs(self.clients) do
    client:update(dt)
  end
  ]]
  
  

  
  
  
end



function StorageState:render()
  
  love.graphics.setColor(colors.white)
  love.graphics.draw(gTextures['storage'], 0, 0)
  
  
  for i, itemCol in ipairs(self.items) do
    for j, item in ipairs(itemCol) do
      item:render()
    end
  end
  
  for _, button in pairs(self.buttons) do
    button:render()
  end
  
  for _, button in pairs(self.changePriceButtons) do
    button:render()
  end
  
  love.graphics.setColor(colors.black)
  if self.priceItem and self.priceItem.sellValue > 0 then
    love.graphics.printf(math.floor(self.priceItem.sellValue)..'$', 0, 53, 46, 'right')
    --[[
    if self.selectedItem then
      love.graphics.print('-', 16, 53)
      love.graphics.print('+', 44, 53)
    end
    ]]
  end
  
  love.graphics.printf(math.floor(cut)..'%', 0, 53, 19, 'right')
  
  
  if self.hoverItem and (not (self.hoverItem.type == 'empty')) then
    local item = self.hoverItem
    local x = item.x1 + 10
    local y = item.y1 + 1
    
    if item.col >= 4 then
      x = item.x1 - 30
    end
    
    if item.row >= 4 then
      y = item.y1 - 21
    end
    
    
    --[[
    
    if item.col == 3 or item.col == 4 then
      x = item.x1 - 10
      if item.row == 1 or item.row == 2 then
        y = item.y1 + 10
      else
        y = item.y1 - 34
      end
    elseif item.col == 5 or item.col == 6 then
      x = item.x1 - 34
    end
    ]]
    
    love.graphics.setColor(colors.white)
    love.graphics.draw(gTextures['sampler'],x, y)
    love.graphics.draw(gTextures['itemsbig'], gFrames['itemsbig'][item.iconBigNumber],x, y)
  end
  
  
  
  
  --[[
  for i = 1,6 do
    love.graphics.draw(gTextures['icons'], gFrames['icons'][3], 2 + 10*(i-1), 0)
  end
  
  
  for i = 1,6 do
    love.graphics.rectangle('fill', 3 + 10*(i-1), 1, 8, 8)
  end
  
  for _, client in pairs(self.clients) do
    client:render()
  end
  
  
  love.graphics.setColor(colors.black)
  love.graphics.printf(self.money, 0, 56, 64, 'right')
  ]]
  
end


function StorageState:swapItems(item1, item2)
  
  self.items[item1.col][item1.row] = item2
  self.items[item2.col][item2.row] = item1
  
  local item1x = item1.x1
  local item1y = item1.y1
  local item1row = item1.row
  local item1col = item1.col

  item1.x1 = item2.x1
  item1.y1 = item2.y1
  item1.row = item2.row
  item1.col = item2.col
  
  item2.x1 = item1x
  item2.y1 = item1y
  item2.row = item1row
  item2.col = item1col
  
  
  
end






