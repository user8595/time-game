local tableClear = require("table.clear")
local progX = (gWidth - 120) / 2
local modeStrings = {
    "Play endlessly.",
    "Play while the game's speed changes every hit."
}

function gameInit()
    pf, great, good, miss = 0, 0, 0, 0
    buttonTime = 0
    timer = 0
    pW = 0
    buttonCol[4] = 0
    buttonRed[4] = 0
    textCol[4] = 0
    tCol = timingCol[1]
    isMiss = true
    tableClear(timingEffect)
    tableClear(pfEffect)
    tableClear(msEffect)
    speed = 1
    lastTimer = 0
    TimingTimer = 0
    lifeBar = 100
    isPaused = false
    isFail = false
end

function keyInit()
    lastTimer = timer
    timer = 0
    buttonCol[4] = 0
    buttonRed[4] = 0
    buttonTime = 0
    lastTimingTimer = TimingTimer
    TimingTimer = 0
    isMiss = false

    if mode == 2 then
        speed = 1 * (0.1 * love.math.random(10, spdMax))
    end
end

function gameOverlay()
    love.graphics.setColor(0, 0, 0, 0.85)
    love.graphics.rectangle("fill", 0, 0, gWidth, gHeight)
end

function gameUI()
    for _, v in ipairs(timingEffect) do
        love.graphics.setColor(v[1])
        love.graphics.rectangle("fill", v[2], v[3], v[4], v[5])
    end

    if mode == 2 then
        if speed < 3 then
            love.graphics.setColor(buttonCol)
        else
            love.graphics.setColor(buttonRed)
        end
    else
        love.graphics.setColor(buttonCol)
    end

    love.graphics.rectangle("fill", gWidth / 2 - 25, 10, 40, 40)
    love.graphics.setColor(textCol)
    love.graphics.printf("HIT!", font[2], 0, 25, gWidth - 6, "center")

    love.graphics.setColor(tCol)
    love.graphics.rectangle("fill", progX, 62, pW, 10)

    for _, v in ipairs(pfEffect) do
        love.graphics.setColor(v[1])
        love.graphics.rectangle("fill", v[2], v[3], v[4], v[5])
    end

    love.graphics.setColor({0.5, 1, 1, 1})
    love.graphics.rectangle("line", progX + 90, 60, 9, 14)

    love.graphics.setColor(timingCol[1])
    love.graphics.rectangle("line", progX + 120, 60, 4, 14)

    for _, v in ipairs(msEffect) do
        love.graphics.setColor(v[1])
        love.graphics.rectangle("fill", v[2], v[3], v[4], v[5])
    end

    love.graphics.setColor(white)
    love.graphics.printf({timingCol[2], "perfect " .. pf, timingCol[3], "\ngreat " .. great, timingCol[4], "\ngood " .. good, timingCol[1], "\nmiss " .. miss}, font[1], 0, 110, gWidth, "center")
    
    if lifeBar > 15 then
        love.graphics.setColor(white)
    else
        love.graphics.setColor(red)
    end
    love.graphics.rectangle("fill", gWidth - 15, 12 + 215, 7, -215 * (lifeBar / 100))

    love.graphics.printf({tipCol, "\nspeed: " .. string.format("%.1f", speed) .. "x"}, font[2], 0, 68, gWidth, "center")

    if lastTimer > 0.75 and lastTimer < 0.85 then
        love.graphics.setColor(timingCol[4])
        love.graphics.printf("GOOD", font[3], 10, 205, gWidth - 24, "center")
    elseif lastTimer > 0.85 and lastTimer < 0.95 then
        love.graphics.setColor(timingCol[3])
        love.graphics.printf("GREAT", font[3], 10, 205, gWidth - 24, "center")
    elseif lastTimer > 0.95 and lastTimer < 1.05 then
        love.graphics.setColor(timingCol[2])
        love.graphics.printf("PERFECT!!", font[3], 10, 205, gWidth - 24, "center")
    elseif lastTimer > 1.05 and lastTimer < 1.15 then
        love.graphics.setColor(timingCol[3])
        love.graphics.printf("GREAT", font[3], 10, 205, gWidth - 24, "center")
    elseif lastTimer > 1.15 and lastTimer < 1.25 then
        love.graphics.setColor(timingCol[4])
        love.graphics.printf("GOOD", font[3], 10, 205, gWidth - 24, "center")
    elseif lastTimer > 1.25 then
        love.graphics.setColor(timingCol[1])
        love.graphics.printf("MISS", font[3], 10, 205, gWidth - 24, "center")
    else
        love.graphics.setColor(tipCol)
        love.graphics.printf("Press SPACE on blue", font[2], 10, 212, gWidth - 24, "center")
    end

    if lastTimer > 0 and not isMiss then
        love.graphics.printf(string.format("%.3f", lastTimingTimer) .. "s", font[2], 0 , 230, gWidth, "center")
    end
end

function titleUI()
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("time", font[3], 0, 12, gWidth, "center")
    love.graphics.printf({{0.95, 0.5, 0.4}, "\n\n\ncontrols\n\n", {0.95, 0.7, 0.4}, "[space]", {1, 1, 1},  " hit object\n", {0.95, 0.7, 0.4}, "[p]", {1, 1, 1}, " pause\n\n", {0.95, 0.7, 0.4}, "[up/down] ", {1, 1, 1}, "adjust\nspeed\n (normal only)", {1, 1, 1}, "\n\npress ", {0.95, 0.7, 0.4}, "space ", {1, 1, 1}, "to play",}, font[1], 0, -2, gWidth, "center")
    love.graphics.print(ver, font[2], 10, gHeight - 44)
end

function modeUI()
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("select mode", font[3], 0, 16, gWidth, "center")
    love.graphics.printf("normal", font[3], 0, 64, gWidth, "center")
    love.graphics.printf("random", font[3], 0, 90, gWidth, "center")

    love.graphics.setColor(1, 1, 1, 0.15)
    love.graphics.rectangle("fill", 0, selY, gWidth, 26)
    
    love.graphics.setColor(1, 1, 1)
    if mode == 1 then
        love.graphics.printf(modeStrings[1], font[2], 0, gHeight - 70, gWidth, "center")
    elseif mode == 2 then
        love.graphics.printf(modeStrings[2], font[2], 0, gHeight - 70, gWidth, "center")
        if spdMax < 30 then
            love.graphics.printf({red, "max ", white, 1 * (0.1 * spdMax) .. "x"}, font[2], 0, gHeight - 90, gWidth, "center")
        else
            love.graphics.printf({red, "max ", 1 * (0.1 * spdMax) .. "x"}, font[2], 0, gHeight - 90, gWidth, "center")
        end
    end
end

function pauseUI()
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("- PAUSED -", font[3], 0, 50, gWidth, "center")
    love.graphics.printf("Escape: Exit\nP: Unpause\nR: Reset", font[1], 0, 195, gWidth, "center")
end

function failUI()
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf({{0.95, 0.7, 0.4}, "- RESULTS -"}, font[3], 0, 30, gWidth, "center")
    love.graphics.printf({timingCol[2], "PF: " .. pf, timingCol[3], "\nGR: " .. great, timingCol[4], "\nGD: " .. good, timingCol[1], "\nMS: " .. miss}, font[1], 0, 58, gWidth, "center")
    
    if mode == 2 then
        if spdMax < 30 then
            love.graphics.printf({red, "max: ", white, 1 * (0.1 * spdMax) .. "x"}, font[1], 0, 160, gWidth, "center")
        else
            love.graphics.printf({red, "max: " .. 1 * (0.1 * spdMax) .. "x"}, font[1], 0, 160, gWidth, "center")
        end
    end
    
    love.graphics.printf("Press Escape to exit", font[2], 0, 190, gWidth, "center")
end

function debugUI()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(love.timer.getFPS() .. " FPS", font[2], 10, 10)
    love.graphics.print(wWidth .. "x" .. wHeight, font[2], 10, 25)
end
