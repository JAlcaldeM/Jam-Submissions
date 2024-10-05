-- This file contains generic and specific CONSTANTS that may be used during the game

VIRTUAL_WIDTH = 160
VIRTUAL_HEIGHT = 144

--WINDOW_WIDTH = VIRTUAL_WIDTH/2
--WINDOW_HEIGHT = VIRTUAL_HEIGHT/2

WINDOW_WIDTH = VIRTUAL_WIDTH*4
WINDOW_HEIGHT = VIRTUAL_HEIGHT*4

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

--[[
palette = {
  {0.878,0.973,0.816},
  {0.533,0.753,0.439},
  {0.204,0.408,0.337},
  {0.031,0.094,0.125},
}
]]

palette = {
  {0.624,0.957,0.898},
  {0,0.725,0.745},
  {0,0.373,0.549},
  {0,0.169,0.349},
}


enemyPalette1 = {
  {0.973,0.890,0.769},
  {0.800,0.204,0.584},
  {0.420,0.122,0.694},
  {0.043,0.024,0.188},
}

enemyPalette2 = {
  {0.937,0.976,0.839},
  {0.729,0.314,0.267},
  {0.478,0.110,0.294},
  {0.106,0.012,0.149},
}

enemyPalette3 = {
  {1.000,0.988,0.996},
  {1.000,0.000,0.082},
  {0.525,0.000,0.125},
  {0.067,0.027,0.039},
}

enemyPalette4 = {
  {0.949,0.773,0.286},
  {0.749,0.325,0.114},
  {0.400,0.122,0.102},
  {0.102,0.059,0.086},
}

winColor = {0.800,0.204,0.584}
loseColor = {1.000,0.000,0.082}
pauseColor = {0.949,0.773,0.286}

enemyPalettes = {enemyPalette1, enemyPalette2, enemyPalette3, enemyPalette4}

nextProjectileID = 1
tilesize = 16
maxLevel = 6

upgradeList = {'damage', 'firerate', 'pierce', 'pellet', 'explosion', 'movespeed', 'slow'}
upgradeDescriptions = {
  damage = ' +50% DAMAGE', -- implemented
  firerate = '+25% FIRERATE', -- implemented
  pierce = ' +1 ENEMY PIERCED', -- implemented
  pellet = '+1 PROJECTILE, LESS DAMAGE', -- implemented
  explosion = '+10 BLAST RADIUS', -- implemented
  movespeed = '+50% MOVESPEED', -- implemented
  slow = '+50% REPULSION', -- implemented
}




