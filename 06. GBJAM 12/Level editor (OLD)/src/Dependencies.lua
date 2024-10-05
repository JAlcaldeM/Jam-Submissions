-- Libraries
Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'
tween = require 'lib/tween'
Easing = require 'lib/easing'
--https://easings.net/

-- Generic
require 'src/StateMachine'
require 'src/Functions'
--require 'src/Constants' MOVED TO THE END, AFTER LOADING GSOUNDS
require 'src/Button'

-- Specific


-- Generic states
require 'src/states/BaseState'
require 'src/states/StateStack'

-- Specific states
--require 'src/states/game/PlayState'
require 'src/states/game/LevelEditorState'


gFonts = {
  

    --['small'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['big'] = love.graphics.newFont('fonts/font.ttf', 24),
    
    --[[
    ['smallmedium'] = love.graphics.newFont('fonts/hotpizza.ttf', 48),
    
    ['title'] = love.graphics.newFont('fonts/hotpizza.ttf', 192),
    ['large'] = love.graphics.newFont('fonts/hotpizza.ttf', 128),
    ['movinglarge'] = love.graphics.newFont('fonts/hotpizza.ttf', 158),
    ['mediumlarge'] = love.graphics.newFont('fonts/hotpizza.ttf', 96),
    ['medium'] = love.graphics.newFont('fonts/hotpizza.ttf', 64),
    
    ['scaleWeight'] = love.graphics.newFont('fonts/digiclock.ttf', 96),
    ]]

}

for _, font in pairs(gFonts) do
    font:setFilter('nearest', 'nearest')
end


gTextures = {
  ['spritesground'] = love.graphics.newImage('graphics/spritesground.png'),
--[[
  ['icons'] = love.graphics.newImage('graphics/icons.png'),
  ['smallicons'] = love.graphics.newImage('graphics/smallicons.png'),
  ['playsprites'] = love.graphics.newImage('graphics/playsprites.png'),
  ['title'] = love.graphics.newImage('graphics/title.png'),
  ['clouds'] = love.graphics.newImage('graphics/clouds.png'),
  
  
  ['food'] = love.graphics.newImage('graphics/food.png'),
  ['background'] = love.graphics.newImage('graphics/background.png'),
  ['scale'] = love.graphics.newImage('graphics/scale.png'),
  ['woodentable'] = love.graphics.newImage('graphics/woodentable.png'),
  ['maintitle'] = love.graphics.newImage('graphics/maintitle.png'),
  ['mainscreen'] = love.graphics.newImage('graphics/mainscreen.png'),
  ['mainshadow'] = love.graphics.newImage('graphics/mainshadow.png'),
  ['smallicons'] = love.graphics.newImage('graphics/smallicons.png'),
  ['finalscreen'] = love.graphics.newImage('graphics/finalscreen.png'),
  
  ]]

}

for _, texture in pairs(gTextures) do
    texture:setFilter('nearest', 'nearest')
end

gFrames = {
  ['spritesground'] = tileMap(gTextures['spritesground'], 16, 16),
  --[[
  ['icons'] = tileMap(gTextures['icons'], 16, 16),
  ['smallicons'] = tileMap(gTextures['smallicons'], 9, 9),
  ['playsprites'] = tileMap(gTextures['playsprites'], 16, 16),
  
    ['food'] = tileMap(gTextures['food'], 600, 600),
    ['smallicons'] = tileMap(gTextures['smallicons'], 100, 100),
    ]]
}

gSounds = {
  ['plop'] = love.audio.newSource('sounds/plop.mp3', 'static'),
  --[[
  ['battle'] = love.audio.newSource('sounds/battleTheme.mp3', 'static'),
  ['lose'] = love.audio.newSource('sounds/defeat.mp3', 'static'),
  ['destroyed'] = love.audio.newSource('sounds/fire.mp3', 'static'),
  ['menu'] = love.audio.newSource('sounds/mainTheme.mp3', 'static'),
  ['explosion'] = love.audio.newSource('sounds/mineral.mp3', 'static'),
  ['ok'] = love.audio.newSource('sounds/ok.mp3', 'static'),
  ['pause'] = love.audio.newSource('sounds/pause.mp3', 'static'),
  ['shoot'] = love.audio.newSource('sounds/pow.mp3', 'static'),
  ['hit'] = love.audio.newSource('sounds/powapo.mp3', 'static'),
  ['unpause'] = love.audio.newSource('sounds/unpause.mp3', 'static'),
  ['win'] = love.audio.newSource('sounds/victory.mp3', 'static'),
  ['levelup'] = love.audio.newSource('sounds/prang.mp3', 'static'),
  ['powerup'] = love.audio.newSource('sounds/plin.mp3', 'static'),
  ['changeselection'] = love.audio.newSource('sounds/plon.mp3', 'static'),
  ['enemyshoot'] = love.audio.newSource('sounds/roar.mp3', 'static'),
  ]]
}


--[[
gSounds['shoot']:setVolume(0.15)
gSounds['battle']:setVolume(0.5)
gSounds['ok']:setVolume(0.5)
gSounds['destroyed']:setVolume(0.3)
gSounds['hit']:setVolume(0.3)
gSounds['levelup']:setVolume(0.5)
gSounds['explosion']:setVolume(0.2)

gSounds['battle']:setPitch(1.05)

transitionSound = gSounds['transition']
transitionSound:setVolume(0.3)
transitionSound:setPitch(1)


gSounds['crunch3']:setVolume(0.05)

music = {gSounds['porridge'], gSounds['wholesome']}
for _, song in pairs(music) do
  song:setLooping(true)
  song:setVolume(0.3)
end

music1 = music[2]
music2 = music[1]

gSounds['drumroll']:setVolume(0.3)
gSounds['fail']:setVolume(0.3)

]]

require 'src/Constants'
