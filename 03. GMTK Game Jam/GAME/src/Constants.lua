-- This file contains generic and specific CONSTANTS that may be used during the game

VIRTUAL_WIDTH = 1920
VIRTUAL_HEIGHT = 1080

WINDOW_WIDTH = VIRTUAL_WIDTH/2
WINDOW_HEIGHT = VIRTUAL_HEIGHT/2

pause = false
showFPS = false

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
}

transitions = true
transitionTime = 0.5
defaultLevelAccuracyRatings = {50, 50, 50, 50, 50, 50, 50, 50, 50, 50}
levelAccuracyRatings = defaultLevelAccuracyRatings


levelNames = {'The Donut','The Watermelon','The Pretzel','The Toast','The Zucchini',
            'The Croissant','The Chocolate','The Tomato','The Cheese','The Potato'}
centerStyle = {'corrected','corrected','corrected','corrected','corrected',
              'corrected','corrected','corrected','corrected','corrected'}
itemWeights = {90,200,120,70,200,
              80,100,150,300,120}
itemsThickness = {40,50,40,20,50,40,15,60,80,50} -- first was 40
itemSounds = {gSounds['crunch'], gSounds['watermelon'], gSounds['crunch2'], gSounds['spreadtoast'], gSounds['fruit'],
              gSounds['crunch2'], gSounds['choco2'], gSounds['fruit'], gSounds['crunch3'], gSounds['fruit'],}
itemSoundsTime = {0.5, 1, 0, 1, 0.6,
                  1, 2, 0, 0, 0,}

