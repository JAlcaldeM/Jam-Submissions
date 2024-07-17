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
require 'src/Icon'
require 'src/Slider'
require 'src/Worker'
require 'src/Bar'
require 'src/Enemy'




-- Generic states
require 'src/states/BaseState'
require 'src/states/StateStack'

-- Specific states
require 'src/states/game/PlayState'
require 'src/states/game/MenuState'
require 'src/states/game/InstructionsState'
require 'src/states/game/PauseState'
require 'src/states/game/WinState'
require 'src/states/game/LoseState'


gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 64),
    ['mediumLarge'] = love.graphics.newFont('fonts/font.ttf', 96),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 128),
    ['title'] = love.graphics.newFont('fonts/font.ttf', 192),
    ['huge'] = love.graphics.newFont('fonts/font.ttf', 256),
}


gTextures = {
    ['icons'] = love.graphics.newImage('graphics/icons.png'),
    ['buildings'] = love.graphics.newImage('graphics/buildings.png'),
    --['trainer'] = love.graphics.newImage('graphics/trainer.png'), 
}

for _, texture in pairs(gTextures) do
    texture:setFilter('nearest', 'nearest')
end

gFrames = {
    ['icons'] = tileMap(gTextures['icons'], 10, 10),
    ['buildings'] = tileMap(gTextures['icons'], 50, 50),
}



gSounds = {
    ['birdmusic'] = love.audio.newSource('sounds/birdmusic.mp3', 'static'),
    ['chronomusic'] = love.audio.newSource('sounds/chronomusic.mp3', 'static'),
    ['clang'] = love.audio.newSource('sounds/clang.mp3', 'static'),
    ['clap'] = love.audio.newSource('sounds/clap.mp3', 'static'),
    ['clong'] = love.audio.newSource('sounds/clong.mp3', 'static'),
    ['fanfare'] = love.audio.newSource('sounds/fanfare.mp3', 'static'),
    ['happymusic'] = love.audio.newSource('sounds/happymusic.mp3', 'static'),
    ['mysterymusic'] = love.audio.newSource('sounds/mysterymusic.mp3', 'static'),
    ['pling'] = love.audio.newSource('sounds/pling.mp3', 'static'),
    ['reward'] = love.audio.newSource('sounds/reward.mp3', 'static'),
    ['rockdestroy'] = love.audio.newSource('sounds/rockdestroy.mp3', 'static'),
    ['sadmusic'] = love.audio.newSource('sounds/sadmusic.mp3', 'static'),
    ['saw'] = love.audio.newSource('sounds/saw.mp3', 'static'),
    ['unknown'] = love.audio.newSource('sounds/unknown.mp3', 'static'),
    ['pick'] = love.audio.newSource('sounds/pick.wav', 'static'),
    ['release'] = love.audio.newSource('sounds/release.wav', 'static'),
    ['ok'] = love.audio.newSource('sounds/ok.mp3', 'static'),
    ['out'] = love.audio.newSource('sounds/out.mp3', 'static'),
    ['pause'] = love.audio.newSource('sounds/pause.mp3', 'static'),
    ['unpause'] = love.audio.newSource('sounds/unpause.mp3', 'static'),
    ['victory'] = love.audio.newSource('sounds/victory.mp3', 'static'),
    ['defeat'] = love.audio.newSource('sounds/defeat.mp3', 'static'),
    ['wood'] = love.audio.newSource('sounds/wood.wav', 'static'),
    ['iron'] = love.audio.newSource('sounds/iron.wav', 'static'),
    ['stone'] = love.audio.newSource('sounds/stone.mp3', 'static'),
    ['plin'] = love.audio.newSource('sounds/plin.mp3', 'static'),
}

gSounds['stone']:setVolume(0.2)



gSounds['birdmusic']:setLooping(true)
gSounds['chronomusic']:setLooping(true)
gSounds['happymusic']:setLooping(true)
gSounds['mysterymusic']:setLooping(true)
gSounds['sadmusic']:setLooping(true)