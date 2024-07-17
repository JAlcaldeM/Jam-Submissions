-- This file contains generic and specific CONSTANTS that may be used during the game

VIRTUAL_WIDTH = 1920
VIRTUAL_HEIGHT = 1080

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

baseResourceRate = {
  wheat = 40,
  wood = 40,
  stone = 30,
  iron = 20,
  }

expGainRate = 5
armorGainRate = 10
doctorHealRate = 10

baseBuildRate = {
  wood = 40,
  stone = 30,
  iron = 20,
  }
townhallUpdatesNeeded = 6

pause = false
showFPS = false

cosmetics = false
enemies = true

local tierTransparency = 1

colors = {
  white = {1,1,1,1},
  black = {0,0,0,1},
  grey = {0.5,0.5,0.5,1},
  lightgrey = {0.8,0.8,0.8,1},
  red = {1,0,0,1},
  green = {0,1,0,1},
  blue = {0,0,1,1},
  yellow = {1,1,0,1},
  magenta = {1,0,1,1},
  cyan = {0,1,1,1},
  purple = {0.65,0,0.8,1},
  bronze = {0.6, 0.4, 0.1, tierTransparency},
  silver = {0.7, 0.7, 0.7, tierTransparency},
  gold = {1, 0.85, 0.3, tierTransparency},
  transparent = {0,0,0,0},
  brown = {0.5, 0.35, 0.05}
}

colorTier = {'bronze', 'silver', 'gold'}

resourceList = {'wheat', 'wood', 'stone', 'iron'}
workList = {'farmer', 'lumberjack', 'soldier', 'builder', 'stonemason', 'doctor', 'miner', 'blacksmith'}

resourceIcons = {
  wheat = 2,
  wood = 1,
  stone = 3,
  iron = 4, 
}

workIcons = {
  farmer = 7,
  lumberjack = 6,
  soldier = 11,
  builder = 14,
  stonemason = 8,
  doctor = 10,
  miner = 9,
  blacksmith = 13,
  none = 15,
}

buildingIcons = {
  townhall = 5,
  farm = 6,
  forest = 2,
  barracks = 5,
  quarry = 3,
  hospital = 5,
  mine = 7,
  forge = 5,
  construction = 8,
}

cosmeticList = {'grass', 'flower', 'animal', 'bird'}

cosmeticIcons = {
  grass = {17, 18},
  flower = {19, 20},
  animal = {21, 22},
  bird = {23, 24},
  }

buildingToWork = {
  farm = 'farmer',
  forest = 'lumberjack',
  barracks = 'soldier',
  quarry = 'stonemason',
  hospital = 'doctor',
  mine = 'miner',
  forge = 'blacksmith',
  construction = 'builder',
}

workToBuilding = {
  farmer = 'farm',
  lumberjack = 'forest',
  soldier = 'barracks',
  stonemason = 'quarry',
  doctor = 'hospital',
  miner = 'mine',
  blacksmith = 'forge',
  builder = 'construction',
}

workToResource = {
  farmer = 'wheat',
  lumberjack = 'wood',
  stonemason = 'stone',
  miner = 'iron',
}
  
worksAllowedFull = {
  {'farmer', 'lumberjack', 'soldier', 'builder'},
  {'farmer', 'lumberjack', 'soldier', 'builder', 'stonemason', 'doctor'},
  {'farmer', 'lumberjack', 'soldier', 'builder', 'stonemason', 'doctor', 'miner', 'blacksmith'},
}

worksAllowed = {
  {'farmer', 'soldier'},
  {'farmer', 'soldier', 'doctor'},
  {'farmer', 'soldier', 'doctor', 'blacksmith'},
}