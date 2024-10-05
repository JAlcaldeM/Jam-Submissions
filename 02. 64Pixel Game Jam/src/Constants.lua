-- This file contains generic and specific CONSTANTS that may be used during the game

VIRTUAL_WIDTH = 64
VIRTUAL_HEIGHT = 64

WINDOW_WIDTH = 640
WINDOW_HEIGHT = 640

pause = false
showFPS = false

colors = {
  white = {1,1,1,1},
  black = {0,0,0,1},
  grey = {0.5,0.5,0.5,1},
  lightgrey = {0.8,0.8,0.8,1},
  darkgrey = {0.2,0.2,0.2,1},
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




day = 1
cut = 20
spent = 0
earnt = 0

itemIcon = {
  default = 1,
  empty = 1,
  glassball = 2,
  sword = 3,
  bow = 4,
  spellbook = 5,
  hammer = 6,
  staff = 7,
  daggers = 8,
  lute = 9,
  axe = 10,
  goldenArrow = 11,
  headband = 12,
  bigSword = 13,
  lightSaber = 14,
  ring = 15,
  hunterAxe = 16,
  lichSword = 17,
  gem = 18,
  shroom = 19,
  triangles = 20,
  bomb = 21,
  lawyerMedal = 22,
  monsterBall = 23,
  dualPistols = 24,
  fairy = 25,
  runes = 26,
  cola = 27,
  trigger = 28,
  ball = 29,
  passport = 30,
  gauntlet = 31,
  flySwords = 32,
  hearts = 33,
  fruit = 34,
  silverSword = 35,
  box = 36,
  usedShield = 37,
  carpet = 38,
  hiddenBlade = 39,
  fusionCore = 40,
  star = 41,
  lostItems = 42,
  cherries = 43,
  doll = 44,
  portalGunBlue = 45,
  portalGunGreen = 46,
  solarShield = 47,
  map = 48,
  
  
  
  
}

--[[
itemBigIcon = {
  default = 1,
  glassball = 2,
  sword = 1,
  empty = 3
}
]]

itemBigIcon = itemIcon

forbiddenCharacters = {'lich', 'trigger'}

characterIcon = {
  default = 1,
  owner = 1,
  magician = 2,
  soldier = 3,
  ranger = 4,
  wizard = 5,
  paladin = 6,
  priest = 7,
  rogue = 8,
  bard = 9,
  barbarian = 10,
  standUser = 11,
  ninja = 12,
  demon = 13,
  jedi = 14,
  grey = 15,
  hunter = 16,
  lich = 17,
  lightWarrior = 18,
  jumpman = 19,
  hero = 20,
  bombman = 21,
  lawyer = 22,
  trainer = 23,
  agent = 24,
  ears = 25,
  dragon = 26,
  wanderer = 27,
  trigger = 28,
  football = 29,
  papers = 30,
  titan = 31,
  survey = 32,
  eskeleton = 33,
  animal = 34,
  witcher = 35,
  snake = 36,
  king = 37,
  wish = 38,
  assassin = 39,
  astronaut = 40,
  juni = 41,
  cops = 42,
  pac = 43,
  courier = 44,
  subject = 45,
  family = 46,
  solar = 47,
  cartographer = 48,
  }

defaultItemValue = {
  default = 0,
  empty = 0,
  glassball = 250,
  sword = 100,
  bow = 75,
  spellbook = 300,
  hammer = 125,
  staff = 225,
  daggers = 150,
  lute = 175,
  axe = 200,
  
  goldenArrow = 800,
  headband = 400,
  bigSword = 500,
  lightSaber = 700,
  ring = 900,
  hunterAxe = 500,
  lichSword = 600,
  gem = 500,
  shroom = 400,
  triangles = 800,
  bomb = 400,
  lawyerMedal = 50,
  monsterBall = 600,
  dualPistols = 500,
  fairy = 400,
  runes = 500,
  cola = 350,
  trigger = 600,
  ball = 400,
  passport = 25,
  gauntlet = 900,
  flySwords = 400,
  hearts = 600,
  fruit = 400,
  silverSword = 600,
  box = 300,
  usedShield = 600,
  carpet = 700,
  hiddenBlade = 700,
  fusionCore = 600,
  star = 500,
  lostItems = 500,
  cherries = 100,
  doll = 0,
  portalGunBlue = 600,
  portalGunGreen = 700,
  solarShield = 600,
  map = 200,
  
  
}

tagList = {'weapon', 'magical','art', 'powerup', 'unique', 'golden', 'wearable', 'technology', 'information', 'organic', 'consumable', 'stealth', 'oneHanded',
  'twoHanded', 'dualWield', 'melee', 'ranged'}
-- unused tags: , , wearable, , 

itemTags = {
  default = {},
  empty = {},
  glassball = {'magical', 'information'},
  sword = {'weapon', 'oneHanded', 'melee'},
  bow = {'weapon', 'twoHanded', 'ranged'},
  spellbook = {'magical', 'oneHanded', 'ranged', 'information'},
  hammer = {'weapon', 'oneHanded', 'melee'},
  staff = {'magical', 'oneHanded', 'melee', 'ranged'},
  daggers = {'weapon', 'dualWield', 'melee'},
  lute = {'art', 'twoHanded', 'melee'},
  axe = {'weapon', 'twoHanded', 'melee'},
  goldenArrow = {'powerup', 'unique', 'golden'},
  headband = {'wearable', 'stealth'},
  bigSword = {'weapon', 'twoHanded', 'melee'},
  lightSaber = {'weapon', 'technology', 'oneHanded', 'melee'},
  ring = {'magical', 'wearable', 'powerup', 'unique', 'golden', 'information', 'stealth'},
  hunterAxe = {'weapon', 'technology', 'oneHanded', 'melee'},
  lichSword = {'weapon', 'magical', 'unique', 'twoHanded', 'melee'},
  gem = {'magical', 'powerup'},
  shroom = {'powerup', 'organic', 'consumable'},
  triangles = {'magical', 'powerup', 'unique', 'golden'},
  bomb = {'weapon', 'consumable'},
  lawyerMedal = {'wearable', 'golden', 'information'},
  monsterBall = {'technology', 'organic'},
  dualPistols = {'weapon', 'stealth', 'dualWield', 'ranged'},
  fairy = {'organic', 'golden', 'consumable'},
  runes = {'magical', 'consumable', 'information'},
  cola = {'organic', 'consumable'},
  trigger = {'golden', 'technology'},
  ball = {'technology', 'art', 'ranged'},
  passport = {'information', 'art'},
  gauntlet = {'weapon', 'powerup', 'unique', 'stealth', 'oneHanded', 'melee', 'ranged'},
  flySwords = {'weapon', 'technology', 'dualWield', 'melee'},
  hearts = {'magical', 'organic', 'consumable'},
  fruit = {'organic', 'consumable'},
  silverSword = {'weapon', 'magical', 'twoHanded', 'melee'},
  box = {'technology', 'stealth', 'wearable'},
  usedShield = {'weapon', 'oneHanded', 'melee'},
  carpet = {'magical', 'art', 'stealth'},
  hiddenBlade = {'weapon', 'art', 'wearable', 'stealth', 'oneHanded', 'melee'},
  fusionCore = {'technology'},
  star = {'organic', 'consumable', 'magical', 'powerup'},
  lostItems = {'weapon', 'information', 'unique', 'oneHanded', 'ranged'},
  cherries = {'organic', 'consumable'},
  doll = {'organic', 'magical'},
  portalGunBlue = {'technology', 'oneHanded', 'ranged'},
  portalGunGreen = {'technology', 'oneHanded', 'ranged'},
  solarShield = {'weapon', 'art', 'oneHanded', 'melee'},
  map = {'information', 'art'},
  
  }



tagValues = {
  default = {},
  magician = {information = 1.15, wearable = 1.1, magical = 1.05},
  soldier = {oneHanded = 1.1, weapon = 1.1, melee = 1.05},
  ranger = {ranged = 1.2, weapon = 1.05},
  wizard = {magical = 1.1, powerup = 1.1, technology = 1.05},
  paladin = {golden = 1.1, unique = 1.1, weapon = 1.05},
  priest = {consumable = 1.15, organic = 1.1},
  rogue = {dualWield = 1.1, stealth = 1.1, melee = 1.05},
  bard = {art = 1.15, wearable = 1.1},
  barbarian = {twoHanded = 1.15, weapon = 1.05, melee = 1.05},
  
  
  
}


normalCharacterList = {'magician','soldier','ranger','wizard','paladin','priest','rogue','bard','barbarian'}
specialCharacterList = {'standUser','ninja','demon','jedi','grey','hunter','lightWarrior','jumpman','hero','bombman','lawyer','trainer','agent','ears','dragon','wanderer','football','papers','titan','survey','eskeleton','animal','witcher','snake','king','wish','assassin','astronaut','juni','cops','pac','courier','subject','family','solar','cartographer'}
--specialCharacterList = {'courier'}
currentSpecialCharacterList = specialCharacterList


characterToItem = {
  
  default = 'default',
  owner = 'empty',
  magician = 'glassball',
  soldier = 'sword',
  ranger = 'bow',
  wizard = 'spellbook',
  paladin = 'hammer',
  priest = 'staff',
  rogue = 'daggers',
  bard = 'lute',
  barbarian = 'axe',
  standUser = 'goldenArrow',
  ninja = 'headband',
  demon = 'bigSword',
  jedi = 'lightSaber',
  grey = 'ring',
  hunter = 'hunterAxe',
  lich = 'lichSword',
  lightWarrior = 'gem',
  jumpman = 'shroom',
  hero = 'triangles',
  bombman = 'bomb',
  lawyer = 'lawyerMedal',
  trainer = 'monsterBall',
  agent = 'dualPistols',
  ears = 'fairy',
  dragon = 'runes',
  wanderer = 'cola',
  trigger = 'trigger',
  football = 'ball',
  papers = 'passport',
  titan = 'gauntlet',
  survey = 'flySwords',
  eskeleton = 'hearts',
  animal = 'fruit',
  witcher = 'silverSword',
  snake = 'box',
  king = 'usedShield',
  wish = 'carpet',
  assassin = 'hiddenBlade',
  astronaut = 'fusionCore',
  juni = 'star',
  cops = 'lostItems',
  pac = 'cherries',
  courier = 'doll',
  subject = 'portalGunBlue',
  family = 'portalGunGreen',
  solar = 'solarShield',
  cartographer ='map',
  
  
}

specialItemPrices = {
  goldenArrow = 600,
  headband = 500,
  bigSword = 700,
  lightSaber = 600,
  ring = 950,
  hunterAxe = 350,
  lichSword = 600,
  gem = 600,
  shroom = 500,
  triangles = 750,
  bomb = 400,
  lawyerMedal = 500,
  monsterBall = 200,
  dualPistols = 600,
  fairy = 500,
  runes = 800,
  cola = 500,
  trigger = 600,
  ball = 300,
  passport = 800,
  gauntlet = 999,
  flySwords = 500,
  hearts = 700,
  fruit = 250,
  silverSword = 900,
  box = 100,
  usedShield = 300,
  carpet = 900,
  hiddenBlade = 500,
  fusionCore = 700,
  star = 1,
  lostItems = 300,
  cherries = 500,
  doll = 0,
  portalGunBlue = 400,
  portalGunGreen = 800,
  solarShield = 400,
  map = 700,
}

skinWeights = {0.15, 0.2, 0.2, 0.15, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5}
