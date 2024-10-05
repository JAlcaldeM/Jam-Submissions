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
require 'src/states/game/TestState'
require 'src/states/game/MainMenuState'
require 'src/states/game/InLevelState'
require 'src/states/game/OutLevelState'
require 'src/states/game/FinalState'
require 'src/states/game/PauseState'



gFonts = {

    ['small'] = love.graphics.newFont('fonts/hotpizza.ttf', 32),
    ['smallmedium'] = love.graphics.newFont('fonts/hotpizza.ttf', 48),
    
    ['title'] = love.graphics.newFont('fonts/hotpizza.ttf', 192),
    ['large'] = love.graphics.newFont('fonts/hotpizza.ttf', 128),
    ['movinglarge'] = love.graphics.newFont('fonts/hotpizza.ttf', 158),
    ['mediumlarge'] = love.graphics.newFont('fonts/hotpizza.ttf', 96),
    ['medium'] = love.graphics.newFont('fonts/hotpizza.ttf', 64),
    
    ['scaleWeight'] = love.graphics.newFont('fonts/digiclock.ttf', 96),

}

for _, font in pairs(gFonts) do
    font:setFilter('nearest', 'nearest')
end


gTextures = {
  ['knife'] = love.graphics.newImage('graphics/knife.png'),
  ['food'] = love.graphics.newImage('graphics/food.png'),
  ['background'] = love.graphics.newImage('graphics/background.png'),
  ['scale'] = love.graphics.newImage('graphics/scale.png'),
  ['woodentable'] = love.graphics.newImage('graphics/woodentable.png'),
  ['maintitle'] = love.graphics.newImage('graphics/maintitle.png'),
  ['mainscreen'] = love.graphics.newImage('graphics/mainscreen.png'),
  ['mainshadow'] = love.graphics.newImage('graphics/mainshadow.png'),
  ['smallicons'] = love.graphics.newImage('graphics/smallicons.png'),
  ['finalscreen'] = love.graphics.newImage('graphics/finalscreen.png'),
  
  

}

for _, texture in pairs(gTextures) do
    texture:setFilter('nearest', 'nearest')
end

gFrames = {
    ['food'] = tileMap(gTextures['food'], 600, 600),
    ['smallicons'] = tileMap(gTextures['smallicons'], 100, 100),
}

gSounds = {
    ['eatcookie'] = love.audio.newSource('sounds/068243_crunchy-cookie-eatingwav-81661.mp3', 'static'),
    ['fruit'] = love.audio.newSource('sounds/apple-bite-85720.mp3', 'static'),
    ['bread'] = love.audio.newSource('sounds/bite-in-crunchy-bread-46216.mp3', 'static'),
    ['eatchip'] = love.audio.newSource('sounds/bite-potato-chips-83946.mp3', 'static'),
    ['fruit2'] = love.audio.newSource('sounds/bush-cut-103503.mp3', 'static'),
    ['choco'] = love.audio.newSource('sounds/candy_bar_drop-94394.mp3', 'static'),
    ['bread2'] = love.audio.newSource('sounds/crunch-crispy-breadbun-41340.mp3', 'static'),
    ['crunch'] = love.audio.newSource('sounds/crunching-and-chewing-a-cookie-or-cracker-173872.mp3', 'static'),
    ['crunch2'] = love.audio.newSource('sounds/eating-chips-81092.mp3', 'static'),
    ['choco2'] = love.audio.newSource('sounds/eating-chocolate-67566.mp3', 'static'),
    ['crunch3'] = love.audio.newSource('sounds/eating-sound-effect-36186.mp3', 'static'),
    ['watermelon'] = love.audio.newSource('sounds/eating-watermelon-78233.mp3', 'static'),
    ['knifetable'] = love.audio.newSource('sounds/knife-cut-veggies-foley-2-211702.mp3', 'static'),
    ['crunch4'] = love.audio.newSource('sounds/plastic-crunch-83779.mp3', 'static'),
    ['knifetable2'] = love.audio.newSource('sounds/slice-apple-on-wood_fizz-85879.mp3', 'static'),
    ['spreadtoast'] = love.audio.newSource('sounds/spreading-toast-knife-butter-19909.mp3', 'static'),
    ['transition'] = love.audio.newSource('sounds/transition-base-121422.mp3', 'static'),
    ['wholesome'] = love.audio.newSource('sounds/Wholesome.mp3', 'static'),
    ['porridge'] = love.audio.newSource('sounds/Pleasant Porridge.mp3', 'static'),
    ['applause'] = love.audio.newSource('sounds/applause-180037.mp3', 'static'),
    ['fail'] = love.audio.newSource('sounds/timpani-boing-fail-146292.mp3', 'static'),
    ['drumroll'] = love.audio.newSource('sounds/tadaa-47995.mp3', 'static'),
    ['slide'] = love.audio.newSource('sounds/slide-click-92152.mp3', 'static'),
    ['ok'] = love.audio.newSource('sounds/good-6081.mp3', 'static'),
    ['pause'] = love.audio.newSource('sounds/pause-89443.mp3', 'static'),
    ['unpause'] = love.audio.newSource('sounds/unpause-106278.mp3', 'static'),
    

}

transitionSound = gSounds['transition']
transitionSound:setVolume(0.3)
transitionSound:setPitch(1)

gSounds['crunch2']:setVolume(0.5)
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

require 'src/Constants'
