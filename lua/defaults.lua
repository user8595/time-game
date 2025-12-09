-- outer width & height
oWidth, oHeight = 330, 280
gWidth, gHeight = 330, 280
tX, tY = (oWidth - gWidth) / 2, (oHeight - gHeight) / 2 + 23
ver = "v1.1.1"

font = {
  love.graphics.newFont("/assets/fonts/monogram.ttf", 22),
  love.graphics.newFont("/assets/fonts/Picopixel.ttf", 14),
  love.graphics.newFont("/assets/fonts/monogram.ttf", 26),
}

isPaused = false
isPauseDelay = false
isCountdown = false
countdownCool = 0
isFail = false
isDebug = false
isShake = false
isShakeHit = false
shakeTime = 0
isExit = 0      -- -1 = mode & popups, 0 = game, 1 = exit game
backState = 0   -- 0 = initial, 1 = closed from state (permanent)

state = "title" -- "title", "mode", "game", "options", "about"
mode = 1        -- 1 = normal, 2 = random, 3 = options, 4 = about
buttonTime = 0
speed = 1
spdMax = 25
timer = 0
lastTimer = 0
TimingTimer = 0
lastTimingTimer = 0
bpm = 60 * speed
pDisplay = 0

combo, maxCombo = 0, 0

min, sec = 0, 0

buttonSkin = 1
shakeEnabled = true

b2S = 2.5

circRad = (math.pi * 2)

-- hide timing text
isMiss = true
animHitTime = 0

-- mode select position
selY = 64

-- option selection
optSel = 1
optPage = 1
selYOpt = 64
optionsSave = {}

-- pause & fail selection
overSel = 1
oYSel = 162

isAudio = true
--TODO: Add fullscreen & vsync options
isFullscreen = false
isVSync = true

width = 120
pW = width * (timer / 1.25)

pf, great, good, miss = 0, 0, 0, 0

-- life bar
lifeBar = 100
lMObj = {}

-- text info
textInfo = {}

keys = {
  hit = "space",
}

-- judgement effect variables
eX, eY, eW, eH, eT = gWidth / 2 - 29, 6, 48, 48, 0

-- timing effect object
timingEffect, pfEffect, msEffect = {}, {}, {}
tObjCircle = {}

--TODO: Add button objects as bounds
buttonUI = {}

buttonCol, textCol = { 1, 1, 1, 0 }, { 0, 0, 0, 0 }
buttonRed = { 1, 0.25, 0.25, 0 }

timingCol = {
  { 1,    0.25, 0.25, 1 },
  { 0.5,  1,    1,    1 },
  { 1,    0.5,  0.25, 1 },
  { 0.25, 0.5,  1,    1 },
  { 1,    1,    1,    1 }
}

tipCol = { 0.95, 0.7, 0.6 }
white = { 1, 1, 1, 1 }
red = { 1, 0.25, 0.25, 1 }
redTint = { 1, 0, 0, 0 }

tCol = timingCol[1]
