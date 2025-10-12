wWidth, wHeight = love.graphics.getWidth(), love.graphics.getHeight()
gWidth, gHeight = 220, 280

ver = "v1.0"

font = {
    love.graphics.newFont("/assets/fonts/monogram.ttf", 22),
    love.graphics.newFont("/assets/fonts/picopixel.ttf", 14),
    love.graphics.newFont("/assets/fonts/monogram.ttf", 26),
}

isPaused = false
isDebug = false

state = "title"
buttonTime = 0
speed = 1
timer = 0
lastTimer = 0
globalTimer = 0
lastGlobalTimer = 0

-- hide timing text?
isMiss = true
animHitTime = 0

width = 120
pW = width * (timer / 1.25)

pf, great, good, miss = 0, 0, 0, 0
-- timing effect object
timingEffect, pfEffect, msEffect = {}, {}, {}

buttonCol, textCol = {1, 1, 1, 0}, {0, 0, 0, 0}
timingCol = {
    {1, 0.25, 0.25, 1},
    {0.5, 1, 1, 1},
    {1, 0.5, 0.25, 1},
    {0.25, 0.5, 1, 1},
    {1, 1, 1, 1}
}
tipCol = {0.95, 0.7, 0.4}
white = {1, 1, 1, 1}

tCol = timingCol[1]
