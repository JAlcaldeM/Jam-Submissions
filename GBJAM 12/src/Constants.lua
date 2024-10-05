-- This file contains generic and specific CONSTANTS that may be used during the game


tilesize = 16
nRowsMap = 115 --30
nColsMap = 165 --50
nRowsMapScreen = 30 --these should not be changed
nColsMapScreen = 50 --these should not be changed

local viewScale = 4

if editor then
  VIRTUAL_WIDTH = tilesize * nColsMapScreen
  VIRTUAL_HEIGHT = tilesize * nRowsMapScreen
  WINDOW_WIDTH = VIRTUAL_WIDTH*2
  WINDOW_HEIGHT = VIRTUAL_HEIGHT*2
else
  VIRTUAL_WIDTH = 160
  VIRTUAL_HEIGHT = 144
  WINDOW_WIDTH = VIRTUAL_WIDTH*viewScale
  WINDOW_HEIGHT = VIRTUAL_HEIGHT*viewScale
end

--CONTROLS
aButton = 'e'
bButton = 'space'

pause = false
showFPS = false

moveKeys = {'w', 'a', 's', 'd', 'up', 'left', 'down', 'right'}

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




palette = {
  {0.878,0.973,0.812},
  {0.525,0.753,0.424},
  {0.188,0.408,0.314},
  {0.027,0.094,0.129},
}


-- info in text tiles
tilesText = {
  --key = {x = , y = , text = '',},
  start1 = {x = 80, y = 79, text = "REMEMBER: RISE AGAIN GOLEM, AND FULFILL YOUR DESTINY!",},
  
  time1 = {x = 71, y = 32, text = "Congratulations for reaching this area. If you are here, you have shown enough ingenuity and creativity to be worthy of knowing your PURPOSE.",},

  time2 = {x = 72, y = 32, text = "During millenia, entire civilizations have been whipped out of the face of the earth by an unknown ENTITY. We know that this ENTITY resides in the interior of the VOLCANO, and even if we have the means to reach it, we are not sure we can stop it. But in the next cycle (the one you are right now), you will.",},
  time3 = {x = 73, y = 32, text = "Equipped with all the PRECURSOR technology and our own, TIME manipulation, we devised a plan to stop this senseless destruction cycle for good. You are the key to make the plan work, and exactly like this ISLAND you current verison is the result of the cooperative work from all PRECURSORS. We freed your will using the HOLY WATER, protected from heat using CRYO-CRYSTALS, equipped you with the PROCESSOR to learn and understand, and put you in the right place using LEVITATION at the right time so that you are ready to save the world.",},
  time4 = {x = 74, y = 28, text = "At some distance from the ISLAND we built a TIME BUBBLE and protected it from the eruption that killed us. This TIME BUBBLE stores all the information you see, and when it perceives the heat from nearby lava sends your current memory (or last, if you are dead) to the PROCESSOR in your version from the past. We froze you again so that you awake moments before the VOLCANO erupts, but we hope with enough time to find the resources needed to reach the center and destroy the ENTITY before it triggers the eruption.",},
  time5 = {x = 70, y = 28, text = "To aid you in this task, we leave here our final gift, the RESTORATOR. If you interact with it while carrying a TOOL, it will restore it to the moment of its creation, allowing you to use it more times. With this, we believe that you have the necessary means to reach the ENTITY, but we do not know the specifics; you will need to create your own path inside.",},
  time6 = {x = 66, y = 28, text = "Now you know your PURPOSE. Remember: RISE AGAIN GOLEM, AND FULFILL YOUR DESTINY!",},
  
  end1 = {x = 143, y = 54, text = "If you are here without having destroyed the ENTITY, you either have been brainwashed by it or willingly decided to break the TIME LOOP. In case you are still under your own volition, we urge you to reconsider what you are just about to do, since this decision is completely IRREVERSIBLE.",},
  end2 = {x = 144, y = 54, text = "If you even slightly touch the TIME BUBBLE, it will react with your matter and be destroyed before it can send your memory to the past. This means that you will die, the TIME LOOP will be broken and we will have lost possibly the only opportunity to defeat the ENTITY.",},
  end3 = {x = 145, y = 54, text = "Countless PRECURSOR civilizations, including ours, have sacrificed themselves selflessly to give you this opportunity. If you throw it away, all this will have been for nothing. Think about not only us and those in the ISLAND who will die (or have already died) from the current civilization, but also the ones from the FUTURE.",},
  end4 = {x = 146, y = 54, text = "I know we did not give you much time within the loop, but it must be a way to destroy the ENTITY and stop the ERUPTION. Explore each and every corner of the ISLAND! Find the TOOLS given to you by the PRECURSORS! Experiment and discover all their possible applications! We are sure you will find the way, because you carry the LEGACY of all those who preceded you.",},
  end5 = {x = 147, y = 54, text = "After designing our plan, we realized that we tried to use you the same way the ENTITY is doing, treating you as a GOLEM built for fulfilling our own desires, and we are ashamed of that. If you are still determined to end this right now, we will not stop you (we cannot). But remember: your PURPOSE is not to defend this ISLAND, to stop the ENTITY or to stop the TIME LOOP. You were a GOLEM once, but now you are an intelligent being. You must decide your own PURPOSE, and assume the consequences of your actions.",},
  
  forest1 = {x = 119, y = 59, text = "For future readers: We arrived at the ISLAND some days ago. Our findings are summarized in the following texts.",},
  forest2 = {x = 122, y = 58, text = "This FOREST is the only area that supports life, since the rest of the area is polluted by toxic air. This must mean that these fast-growing trees act as an air purifier. Some of them even produce a fruit that, when ingested, is able to revert the effects of the air toxins. Unfortunately, the growth of this plant is too slow to give enough time to explore the island. If only there was a way to accelerate its growth...",},
  forest3 = {x = 125, y = 56, text = "From here we can see two GOLEMS, one to the NORTH and other to the SOUTHWEST. These golems seem hostile, and very resistant. If you want to take them down, you will need to breach their armor first, or debilitate its power source, a strong heat from within. Or maybe, you can remain just far enough to evade them...",},
  forest4 = {x = 127, y = 53, text = "The mineral analysis of the ISLAND sections revealed that the VOLCANO will erupt in a matter of days, and if our calculations are correct, it will cause an ecological disaster, wiping out most of the world's life. We do not have the means to stop it, which means that almost every living being on the planet, including us and the others of our kin, is doomed.",},
  forest5 = {x = 121, y = 49, text = "We believe that this vegetation is a product of a previous civilization, which used its domain over organic matter to create a refuge so that others in the FUTURE (as you) could explore the rest of the ISLAND. If that is the case, we also have a present that we want to share with you: the LEGACY. Here we deposit huge quantities of our most heat-resistant material, the ZIRCOXITE. You can use it to leave messages to the FUTURE, the same way we are doing now, in hopes that your discoveries may help others to triumph where you could not.",},
  
  ice1 = {x = 105, y = 27, text = "GOLEMS take no damage. We use CRYO-CRYSTALS. GOLEM is ICE. You have GOLEM problem? Use our CRYO-CRYSTAL.",},
  ice2 = {x = 106, y = 28, text = "CRYO-CRYSTAL other uses too. Not swim? ICE. Need ground? ICE. Hot drink? ICE. Maybe ENTITY ICE too.",},
  ice3 = {x = 107, y = 29, text = "HOLY WATER makes GOLEM good. But VOLCANO destroys GOLEMS. ICE protects good GOLEM. You use our good GOLEM.",},
  ice4 = {x = 104, y = 44, text = "Ground ICE breaks, use only once or fall. Also, slippery.",},
  
  desert1 = {x = 28, y = 51, text = "Predecessors, we found your gifts: the power of ENDURANCE, so that we can breath this polluted air, and the power of LEGACY, so that we can pass this knowledge onto others.",},
  desert2 = {x = 33, y = 51, text = "Successors, receive ours: this HOLY WATER, able to alter the very nature of life. The sacred TREES will grow faster, and the GOLEMS will be freed from the influence of the malevolent ENTITY. May this gift serve in your endeavors, and allow further exploration of these forbidden lands.",},
  
  grav1 = {x = 124, y = 82, text = "FACT: This material will resist many volcanic eruptions. Therefore, this is the best option for documenting our findings.",},
  grav2 = {x = 128, y = 82, text = "FACT: Several PRECURSORS civilizations were found during our exploration of the ISLAND. FACT: These have a very advanced level of knowledge about a particular field; in chronological order: VEGETAL GROWTH (the trees and fruits, in the FOREST), MATERIALS (these slabs, in many places), MOLECULAR BIOLOGY (some sort of  'holy' fluid as per their texts, in the DESERT). THEORY: We are the fourth civilization that explores this ISLAND.",},
  grav3 = {x = 124, y = 79, text = "FACT: There is no relation between every civilization and the next. THEORY: The PRECURSORS are not related between them or with us. QUESTION: Where are the previous PRECURSORS? THEORY: They are extinct. FACT: The kinetic magma analysis revealed that the ISLAND rises to the surface abnormally fast, and that the VOLCANO erupts periodically. THEORY: The VOLCANO is alive (we give it the ENTITY name, as our predecessors did) and responsible for the extinction events.",},
  grav4 = {x = 128, y = 79, text = "FACT: The VOLCANO is inaccessible from outside. FACT: We are unable to reach the VOLCANO and to stop the imminent eruption using our current technological level. FACT: We are going to be extinct soon, and there is nothing we can do to stop it.",},
  grav5 = {x = 128, y = 76, text = "THEORY: We can help others in the FUTURE to survive. FACT: We developed several REPULSORS and deployed them over the ISLAND. FACT: These REPULSORS protect small items from the lava, protecting them from physical damage. THEORY: A future civilization could use the REPULSORS to leave traces of its technology for others to use.",},
  grav6 = {x = 124, y = 76, text = "FACT: We also leave several of our LEVITATION devices. They cannot be used to reach the center of the ISLAND, but they help traverse difficult terrain. THEORY: In the FUTURE, a LEVITATION device could be vital to defeat the ENTITY, so its conservation is extremely important. REQUEST: Please do not take more LEVITATION devices than you need.",},
  
  space1a = {x = 33, y = 86, text = "Day 1. Today I arrived at this ISLAND. I was intrigued by its mysterious origin and enigmatic appearance. I will use this small cay as a base, since it is far enough from the toxic gasses. My plan is to perform fast explorations of the ISLAND using my new invention, the WARP ENGINE, to teleport in and out before receiving severe damage. It is a risky plan, but I am optimistic. I'm sure I will discover something great!",},
  space1b = {x = 28, y = 81, text = "Day 2. Today I found something! Ruins of PRECURSOR civilizations, containing ancient technology and speaking about some sort of ENTITY.",},
  space2b = {x = 29, y = 81, text = "Why does it exist, and actively wants to destroy us? Have we done something to anger it?",},
  space3b = {x = 31, y = 81, text = "Perhaps the ENTITY seeks nothing but wanton destruction.",},
  space4b = {x = 32, y = 81, text = "Or maybe it is scared of us.",},
  space5b = {x = 34, y = 81, text = "My anthropological research has proven that more advanced societies tend to be more violent and destructive. It is possible that the ENTITY is so advanced that concepts like empathy or mercy are completely alien to it.",},
  space6b = {x = 35, y = 81, text = "The real answer can be any of these, or even all of them.",},
  space1c = {x = 35, y = 76, text = "I did it. I found all the PRECURSORS. I have collected the data, analyzed the evidence, and reached a conclusion. And the very things that motivates the ENTITY to extinguish us... are ourselves. Or particularly, fast technological advancements. And it turns out, I have no other person to blame but myself and my recent discoveries.",},
  space2c = {x = 32, y = 76, text = "But Ihave a plan to stop this: I will enter the VOLCANO using the WARP ENGINE, and face the ENTITY. I will start by taking some of those CRYO-CRYSTALS to survive the extreme heat...",},
  space1d = {x = 28, y = 70, text = "This is written for you, GOLEM. If my calculations are correct, there is not enough charge in the WARP ENGINE to reach the center of the VOLCANO, and I cannot recharge it in time. Which means that, as the previous PRECURSORS, I have caused the demise of my species, and now I find myself unable to save them.",},
  space2d = {x = 30, y = 70, text = "But the time for laments has yet to come. All my life I have refused cooperation, but now I have the chance to participate in something greater than myself, and to trust others to do their part in the FUTURE. I have equipped you with a PROCESSOR to analyze and receive information. This makes you able to learn and adapt to any plan created by other civilizations, but you must willingly participate in the plan. I trust you will make the correct choices and save the FUTURE.",},
  space3d = {x = 32, y = 70, text = "I leave to you my most precious possession, the WARP ENGINE. Use it to teleport 3 tiles in the direction you are looking. But be sure to target an empty tile, or you will waste energy! You are extremely resistant to heat, so you can use it to reach the ENTITY if you find a way. But who knows, maybe you discover other uses. Use it wisely!",},

  
  
  
  
  
  
  
  }














