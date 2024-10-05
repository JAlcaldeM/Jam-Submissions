-- This file contains generic and specific CONSTANTS that may be used during the game

VIRTUAL_WIDTH = 1920
VIRTUAL_HEIGHT = 1080

--WINDOW_WIDTH = VIRTUAL_WIDTH/2
--WINDOW_HEIGHT = VIRTUAL_HEIGHT/2

startScreenScale = 0.5

WINDOW_WIDTH = VIRTUAL_WIDTH*startScreenScale
WINDOW_HEIGHT = VIRTUAL_HEIGHT*startScreenScale

pause = false
showFPS = false

prevX = 0
prevY = 0

colors = {
  white = {1,1,1,1},
  black = {0,0,0,1},
  grey = {0.5,0.5,0.5,1},
  lightgrey = {0.8,0.8,0.8,1},
  darkgrey = {0.2,0.2,0.2,1},
  darkgrey2 = {0.29,0.29,0.29,1},
  red = {1,0,0,1},
  darkred = {0.5,0,0},
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
  orange = {1, 165/255, 0},
}

nPellets = 50

transitionTime = 0.5