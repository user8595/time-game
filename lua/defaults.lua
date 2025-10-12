wWidth, wHeight = love.graphics.getWidth(), love.graphics.getHeight()
gWidth, gHeight = 220, 280

ver = "v1.0"

font = {
    love.graphics.newFont("/assets/fonts/monogram.ttf", 22),
    love.graphics.newFont("/assets/fonts/picopixel.ttf", 14),
    love.graphics.newFont("/assets/fonts/monogram.ttf", 26),
}

isPaused = false
isFail = fail
isDebug = false
isExit = 0 -- -1 = mode & popups, 0 = game, 1 = exit game

state = "title"
mode = 1 -- 1 = normal, 2 = random
buttonTime = 0
speed = 1
spdMax = 25
timer = 0
lastTimer = 0
TimingTimer = 0
lastTimingTimer = 0

-- hide timing text
isMiss = true
animHitTime = 0

-- mode select position
selY = 64

width = 120
pW = width * (timer / 1.25)

pf, great, good, miss = 0, 0, 0, 0

-- life bar
lifeBar = 100

-- timing effect object
timingEffect, pfEffect, msEffect = {}, {}, {}

buttonCol, textCol = {1, 1, 1, 0}, {0, 0, 0, 0}
buttonRed = {1, 0.15, 0.15, 0}

timingCol = {
    {1, 0.25, 0.25, 1},
    {0.5, 1, 1, 1},
    {1, 0.5, 0.25, 1},
    {0.25, 0.5, 1, 1},
    {1, 1, 1, 1}
}

tipCol = {0.95, 0.7, 0.6}
white = {1, 1, 1, 1}
red = {1, 0.25, 0.25, 1}

tCol = timingCol[1]
