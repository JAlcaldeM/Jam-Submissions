TextState = Class{__includes = BaseState}

function TextState:init(def)
  self.type = 'Text'
  
  local emptySize = 2 -- space between screen border and start of textbox
  local marginSize = 3 -- space between start of textbox and actual text space
  local textMarginLeft = 5 -- space between start of text space and first character coordinates
  self.advanceIconSize = 7 --size of the icon for advancing to the next text line
  local textMarginRight = self.advanceIconSize + 3 -- space between end of text and textbox margin
  local textHeight = 40 -- size of the actual text space
  local lineMaxWidth = VIRTUAL_WIDTH - 2*emptySize - 2*marginSize - textMarginLeft - textMarginRight
  
  local font = gFonts['text2']
  --local defaultText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
  local defaultText = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
  local text = def.text or defaultText-- string of text to print in this instance of the state
  --local words = separateIntoWords(text)
  local textLines = wrapTextIntoLines(text, font, lineMaxWidth)
  
  --[[
  for _, word in ipairs(words) do
    print(word)
  end
  
  for _, line in ipairs(textLines) do
    print(line)
  end
  ]]
  
  
  
  
  self.margin = {
    x = emptySize,
    y = VIRTUAL_HEIGHT - textHeight - emptySize - 2*marginSize,
    width = VIRTUAL_WIDTH - 2*emptySize,
    height = textHeight + 2*marginSize,
    color = palette[4],
    size = marginSize,
  }
  
  self.textbox = {
    x = self.margin.x + self.margin.size,
    y = self.margin.y + self.margin.size,
    width = self.margin.width - 2*self.margin.size,
    height = self.margin.height - 2*self.margin.size,
    color = palette[1],
  }
  
  
  self.text = {
    strings = textLines,
    currentString = 1,
    maxCurrentString = math.max(1, #textLines - 2),
    nLines = 3,
    margin = textMarginLeft,
    color = palette[4],
    --currentLine = 1,
    x = self.textbox.x + textMarginLeft,
    yValues = {},
    --[[
    y1 =  self.textbox.y + textMarginLeft,
    y2 = self.textbox.y + textMarginLeft + font:getHeight(),
    ]]
    width = lineMaxWidth,
    --lineHeigth = font:getHeight(),
    font = font,
    charSpace = 1,
  }
  
  local extraOffset = 2
  for i = 1, self.text.nLines do
    table.insert(self.text.yValues, self.textbox.y + textMarginLeft + (i-1)*(extraOffset + font:getHeight()))
  end
  
  self.nextText = def.nextText
  
  
  --defPlay('moreText')
  defPlay('okSound1')
end





function TextState:update(dt)
  

  if love.keyboard.wasPressed(bButton) then
    gStateStack:pop()
    defPlay('okSound2')
  end
  
  local keyPressed = false
  if love.keyboard.wasPressed(aButton) then
    keyPressed = true
  end
  for _, key in pairs(moveKeys) do
     if love.keyboard.wasPressed(key) then
      keyPressed = true
     end
  end
  
  
  if keyPressed then
    
    if self.text.currentString < self.text.maxCurrentString  then
      self.text.currentString = self.text.currentString + 1
      --defPlay('moreText')
      defPlay('okSound1')

    else
      gStateStack:pop()
      --defPlay('closeText')
      defPlay('okSound2')

  end
  
  
  
  

end


  
  
end



function TextState:render()
  
  --background default
  --love.graphics.clear(0.5, 0.5, 0.5)
  
  --margin
  love.graphics.setColor(self.margin.color)
  love.graphics.rectangle('fill', self.margin.x, self.margin.y, self.margin.width, self.margin.height)
  
  --textbox
  love.graphics.setColor(self.textbox.color)
  love.graphics.rectangle('fill', self.textbox.x, self.textbox.y, self.textbox.width, self.textbox.height)
  
  
  --point where the mouse is
  if self.mouseX and self.mouseY then
    love.graphics.setColor(colors.black)
    --love.graphics.points(math.floor(self.mouseX), math.floor(self.mouseY) )
    love.graphics.rectangle('fill', math.floor(self.mouseX), math.floor(self.mouseY), 1, 1)
  end
  
  --show the text
  love.graphics.setFont(self.text.font)
  love.graphics.setColor(self.text.color)
  --love.graphics.print(self.text.string, self.text.x, self.text.y1)
  for i = 1, self.text.nLines do
    local stringNumber = self.text.currentString + i - 1
    local text = self.text.strings[stringNumber]
    if text then
      drawTextSpace(text, self.text.x, self.text.yValues[i], self.text.charSpace, self.text.font)
    end
  end
  
  
  
  
  -- icon for next text
  --[[
  love.graphics.setColor(colors.cyan)
  love.graphics.rectangle('fill', self.text.x + self.text.width, self.text.y1, 10, 10)
  ]]
  love.graphics.setColor(colors.white)
  love.graphics.draw(gTextures['sprites10'], gFrames['sprites10'][22], self.text.x + self.text.width, self.textbox.y + self.textbox.height - 10)
  

end