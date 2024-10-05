-- Libraries
Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'
tween = require 'lib/tween'

-- Generic
require 'src/StateMachine'
require 'src/Functions'
require 'src/Constants'

-- Specific
require 'src/Client'
require 'src/Item'
require 'src/Button'



-- Generic states
require 'src/states/BaseState'
require 'src/states/StateStack'

-- Specific states
require 'src/states/game/StoreState'
require 'src/states/game/StorageState'
require 'src/states/game/EnddayState'
require 'src/states/game/ScoreState'
require 'src/states/game/MainMenuState'


gFonts = {
    ['8'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['16'] = love.graphics.newFont('fonts/font.ttf', 16),
    --[[
    ['small'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 64),
    ['mediumLarge'] = love.graphics.newFont('fonts/font.ttf', 96),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 128),
    ['title'] = love.graphics.newFont('fonts/font.ttf', 192),
    ['huge'] = love.graphics.newFont('fonts/font.ttf', 256),
    
    ['yoster12'] = love.graphics.newFont('fonts/yoster.ttf', 12),
    ['yoster16'] = love.graphics.newFont('fonts/yoster.ttf', 16),
    ['yoster24'] = love.graphics.newFont('fonts/yoster.ttf', 24),
    
    ['yoster32'] = love.graphics.newFont('fonts/yoster.ttf', 32),
    ['yoster64'] = love.graphics.newFont('fonts/yoster.ttf', 64),
    ['yoster96'] = love.graphics.newFont('fonts/yoster.ttf', 96),
    ['yoster128'] = love.graphics.newFont('fonts/yoster.ttf', 128),
    ['yoster192'] = love.graphics.newFont('fonts/yoster.ttf', 192),
    ['yoster256'] = love.graphics.newFont('fonts/yoster.ttf', 256),
    
    ['manaspc8'] = love.graphics.newFont('fonts/manaspc.ttf', 8),
    ['manaspc16'] = love.graphics.newFont('fonts/manaspc.ttf', 16),
    ['manaspc32'] = love.graphics.newFont('fonts/manaspc.ttf', 32),
    ['manaspc64'] = love.graphics.newFont('fonts/manaspc.ttf', 64),
    ['manaspc96'] = love.graphics.newFont('fonts/manaspc.ttf', 96),
    ['manaspc128'] = love.graphics.newFont('fonts/manaspc.ttf', 128),
    ['manaspc192'] = love.graphics.newFont('fonts/manaspc.ttf', 192),
    ['manaspc256'] = love.graphics.newFont('fonts/manaspc.ttf', 256),
    ]]
}

for _, font in pairs(gFonts) do
    font:setFilter('nearest', 'nearest')
end


gTextures = {
    ['icons'] = love.graphics.newImage('graphics/icons.png'),
    ['icons8'] = love.graphics.newImage('graphics/icons8.png'),
    ['icons5'] = love.graphics.newImage('graphics/icons5.png'),
    ['characters'] = love.graphics.newImage('graphics/characters.png'),
    ['items'] = love.graphics.newImage('graphics/items.png'),
    ['itemsbig'] = love.graphics.newImage('graphics/itemsbig.png'),
    ['store'] = love.graphics.newImage('graphics/storescreen2.png'),
    ['storage'] = love.graphics.newImage('graphics/storagescreen.png'),
    ['bubble'] = love.graphics.newImage('graphics/bubble.png'),
    ['bubble2'] = love.graphics.newImage('graphics/bubble2.png'),
    ['vbubble'] = love.graphics.newImage('graphics/vbubble.png'),
    ['endday'] = love.graphics.newImage('graphics/enddaymenu.png'),
    ['score'] = love.graphics.newImage('graphics/scorescreen.png'),
    ['sampler'] = love.graphics.newImage('graphics/sampler.png'),
    ['mainmenu'] = love.graphics.newImage('graphics/mainmenu.png'),
    
}

for _, texture in pairs(gTextures) do
    texture:setFilter('nearest', 'nearest')
end

gFrames = {
    ['icons'] = tileMap(gTextures['icons'], 10, 10),
    ['icons8'] = tileMap(gTextures['icons8'], 8, 8),
    ['icons5'] = tileMap(gTextures['icons5'], 5, 5),
    ['characters'] = tileMap(gTextures['characters'], 10, 10),
    ['items'] = tileMap(gTextures['items'], 10, 10),
    ['itemsbig'] = tileMap(gTextures['itemsbig'], 30, 30),
}



gSounds = {
    ['bell'] = love.audio.newSource('sounds/bell.mp3', 'static'),
    ['blip'] = love.audio.newSource('sounds/blip.mp3', 'static'),
    ['cash'] = love.audio.newSource('sounds/cash.mp3', 'static'),
    ['tip'] = love.audio.newSource('sounds/tip.mp3', 'static'),
    ['coin'] = love.audio.newSource('sounds/coin.mp3', 'static'),
    ['pow'] = love.audio.newSource('sounds/pow.mp3', 'static'),
    ['ok'] = love.audio.newSource('sounds/ok.mp3', 'static'),
    ['roar'] = love.audio.newSource('sounds/roar.mp3', 'static'),
    ['finalbell'] = love.audio.newSource('sounds/finalbell.mp3', 'static'),
    ['purpledream'] = love.audio.newSource('sounds/purpledream.mp3', 'static'),
    ['downtownglow'] = love.audio.newSource('sounds/downtownglow.mp3', 'static'),

}

