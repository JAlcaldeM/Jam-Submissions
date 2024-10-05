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
require 'src/Tiles'
require 'src/Map'
require 'src/Tools'
require 'src/Npcs'

-- Specific


-- Generic states
require 'src/states/BaseState'
require 'src/states/StateStack'

-- Specific states
require 'src/states/game/PlayState'
require 'src/states/game/TextState'
require 'src/states/game/LevelEditorState'
require 'src/states/game/EndState'


gFonts = {
  

    --['small'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['big'] = love.graphics.newFont('fonts/font.ttf', 24),
    
    ['text'] = love.graphics.newFont('fonts/PokemonGb-RAeo.ttf', 8),
    ['text2'] = love.graphics.newFont('fonts/PKMN_RBYGSC.ttf', 8),
    
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
  ['sprites10'] = love.graphics.newImage('graphics/sprites10.png'),
  ['sprites16'] = love.graphics.newImage('graphics/sprites16.png'),
  
  ['UI'] = love.graphics.newImage('graphics/UI.png'),
  ['sandfall'] = love.graphics.newImage('graphics/sandfall.png'),
  
  ['ice1'] = love.graphics.newImage('graphics/ice1.png'),
  ['ice2'] = love.graphics.newImage('graphics/ice2.png'),
  ['ice3'] = love.graphics.newImage('graphics/ice3.png'),
  ['golemSleep'] = love.graphics.newImage('graphics/golemSleep.png'),
  ['golemAwake1'] = love.graphics.newImage('graphics/golemAwake1.png'),
  ['golemAwake2'] = love.graphics.newImage('graphics/golemAwake2.png'),
  ['blackScreen'] = love.graphics.newImage('graphics/blackScreen.png'),
  ['endScreen'] = love.graphics.newImage('graphics/endScreen.png'),
  --[[
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
  ['sprites10'] = tileMap(gTextures['sprites10'], 10, 10),
  ['sprites16'] = tileMap(gTextures['sprites16'], 16, 16),
  --[[
  ['smallicons'] = tileMap(gTextures['smallicons'], 9, 9),
  ['playsprites'] = tileMap(gTextures['playsprites'], 16, 16),
  
    ['food'] = tileMap(gTextures['food'], 600, 600),
    ['smallicons'] = tileMap(gTextures['smallicons'], 100, 100),
    ]]
}

gSounds = {
  ['plop'] = love.audio.newSource('sounds/plop.mp3', 'static'),
  
  
  
  ['defrost'] = {
    love.audio.newSource('sounds/defrost1.mp3', 'static'),
    love.audio.newSource('sounds/defrost2.mp3', 'static'),
    love.audio.newSource('sounds/defrost3.mp3', 'static'),
    love.audio.newSource('sounds/nothing.mp3', 'static'),
    love.audio.newSource('sounds/golemAwake.mp3', 'static'),
  },
  ['longnoise'] = love.audio.newSource('sounds/longnoise.mp3', 'static'),
  ['ok'] = love.audio.newSource('sounds/ok.mp3', 'static'),
  ['pip'] = love.audio.newSource('sounds/pip.mp3', 'static'),
  ['select'] = love.audio.newSource('sounds/select.mp3', 'static'),
  --['steps1'] = love.audio.newSource('sounds/steps1.mp3', 'static'),
  
  ['golemAwake'] = love.audio.newSource('sounds/golemAwake.mp3', 'static'),
  ['fall'] = love.audio.newSource('sounds/fall.mp3', 'static'),
  ['timeloopTemp'] = love.audio.newSource('sounds/timeloopTemp.mp3', 'static'),
  ['prang'] = love.audio.newSource('sounds/prang.mp3', 'static'),
  ['timeLoopStarts'] = love.audio.newSource('sounds/timeLoopStarts.mp3', 'static'),
  ['getTool'] = love.audio.newSource('sounds/getTool.mp3', 'static'),
  ['loseTool'] = love.audio.newSource('sounds/loseTool.mp3', 'static'),
  ['bump'] = love.audio.newSource('sounds/bump.mp3', 'static'),
  ['moreText'] = love.audio.newSource('sounds/moreText.mp3', 'static'),
  ['closeText'] = love.audio.newSource('sounds/closeText.mp3', 'static'),
  ['golemStep'] = love.audio.newSource('sounds/golemStep.mp3', 'static'),
  ['bigExplosion'] = love.audio.newSource('sounds/bigExplosion.mp3', 'static'),
  ['timeReverseStart'] = love.audio.newSource('sounds/timeReverseStart.mp3', 'static'),
  ['itemGiven'] = love.audio.newSource('sounds/itemGiven.mp3', 'static'),
  ['missionComplete'] = love.audio.newSource('sounds/missionComplete.mp3', 'static'),
  ['fireShort'] = love.audio.newSource('sounds/fireShort.mp3', 'static'),
  ['fireDeath'] = love.audio.newSource('sounds/fireDeath.mp3', 'static'),
  ['sandSink'] = love.audio.newSource('sounds/sandSink.mp3', 'static'),
  ['waterSink'] = love.audio.newSource('sounds/waterSink.mp3', 'static'),
  ['sinking1'] = love.audio.newSource('sounds/sinking1.mp3', 'static'),
  ['sinking2'] = love.audio.newSource('sounds/sinking2.mp3', 'static'),
  ['sinking3'] = love.audio.newSource('sounds/sinking3.mp3', 'static'),
  ['sinking4'] = love.audio.newSource('sounds/sinking4.mp3', 'static'),
  ['lava'] = love.audio.newSource('sounds/lava.mp3', 'static'),
  ['eruptionStarts'] = love.audio.newSource('sounds/eruptionStarts.mp3', 'static'),
  ['okSound1'] = love.audio.newSource('sounds/okSound1.mp3', 'static'),
  ['okSound2'] = love.audio.newSource('sounds/okSound2.mp3', 'static'),
  ['endState'] = love.audio.newSource('sounds/endState.mp3', 'static'),
  ['endState2'] = love.audio.newSource('sounds/endState2.mp3', 'static'),
  ['thanks'] = love.audio.newSource('sounds/thanks.mp3', 'static'),
  ['iceSlide'] = love.audio.newSource('sounds/iceSlide.mp3', 'static'),
  
  ['tool1'] = love.audio.newSource('sounds/tool1.mp3', 'static'),
  ['tool2'] = love.audio.newSource('sounds/tool2.mp3', 'static'),
  ['tool3'] = love.audio.newSource('sounds/tool3.mp3', 'static'),
  --['teleportFail'] = love.audio.newSource('sounds/teleportFail.mp3', 'static'),
  ['toolFail'] = love.audio.newSource('sounds/toolFail.mp3', 'static'),
  ['toolFailMini'] = love.audio.newSource('sounds/toolFailMini.mp3', 'static'),
  ['axe'] = love.audio.newSource('sounds/axe.mp3', 'static'),
  ['tool4'] = love.audio.newSource('sounds/tool2.mp3', 'static'),
  ['tool5'] = love.audio.newSource('sounds/tool3.mp3', 'static'),
  ['putBomb'] = love.audio.newSource('sounds/putBomb.mp3', 'static'),
  ['smallExplosions'] = {
    love.audio.newSource('sounds/smallExplosion.mp3', 'static'),
    love.audio.newSource('sounds/smallExplosion2.mp3', 'static'),
  },
  ['hover'] = {
    love.audio.newSource('sounds/startHover.mp3', 'static'),
    love.audio.newSource('sounds/hover2.mp3', 'static'),
    love.audio.newSource('sounds/stopHover.mp3', 'static'),
  },
  ['useWater'] = love.audio.newSource('sounds/useWater.mp3', 'static'),
  ['iceTool'] = love.audio.newSource('sounds/iceTool.mp3', 'static'),
  ['flames'] = love.audio.newSource('sounds/flames.mp3', 'static'),
  
  
  
  ['grass'] = {
    love.audio.newSource('sounds/stepgrass1.mp3', 'static'),
    love.audio.newSource('sounds/stepgrass2.mp3', 'static'),
  },
  ['sand'] = {
    love.audio.newSource('sounds/stepSand1.mp3', 'static'),
    love.audio.newSource('sounds/stepSand2.mp3', 'static'),
  },
  ['hard'] = {
    love.audio.newSource('sounds/stepHard1.mp3', 'static'),
    love.audio.newSource('sounds/stepHard2.mp3', 'static'),
  },
  ['ice'] = {
    love.audio.newSource('sounds/stepIce1.mp3', 'static'),
    love.audio.newSource('sounds/stepIce2.mp3', 'static'),
  },
  
  ['iceCrack'] = {
    love.audio.newSource('sounds/iceCrack.mp3', 'static'),
    love.audio.newSource('sounds/iceCrack.mp3', 'static'),
  },
  
  
  
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
