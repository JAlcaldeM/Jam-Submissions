-- This file contains generic and specific CONSTANTS that may be used during the game


--[[
VIRTUAL_WIDTH = 160
VIRTUAL_HEIGHT = 144

WINDOW_WIDTH = VIRTUAL_WIDTH*4
WINDOW_HEIGHT = VIRTUAL_HEIGHT*4
]]

tilesize = 16

nRowsMap = 30
nColsMap = 50

VIRTUAL_WIDTH = tilesize * nColsMap
VIRTUAL_HEIGHT = tilesize *nRowsMap



WINDOW_WIDTH = VIRTUAL_WIDTH*2
WINDOW_HEIGHT = VIRTUAL_HEIGHT*2



pause = false
showFPS = true

colors = {
  white = {1,1,1,1},
  black = {0,0,0,1},
  grey = {0.5,0.5,0.5,1},
  lightgrey = {0.8,0.8,0.8,1},
  darkgrey = {0.2,0.2,0.2,1},
  darkgrey2 = {0.29,0.29,0.29,1},
  red = {1,0,0,1},
  green = {0,1,0,1},
  blue = {0,0,1,1},
  yellow = {1,1,0,1},
  magenta = {1,0,1,1},
  cyan = {0,1,1,1},
  purple = {0.65,0,0.8,1},
  transparent = {1,1,1,0},
  semitransparent = {1,1,1,0.5},
  brown = {0.5, 0.35, 0.05},
  windowColor = {0,0.62, 0.67, 0.4},
  frameColor = {0.66,0.57, 0},
  shadow = {0,0,0,0.4},
}



--[[
nRowsMap = VIRTUAL_HEIGHT/tilesize --10
nColsMap = VIRTUAL_WIDTH/tilesize --10
]]



--[[
groundToSprite = {
  lgrass1 = 1,
  
  
  }
  ]]