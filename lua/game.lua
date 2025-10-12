local tableClear = require("table.clear")
local progX = (gWidth - 120) / 2

function gameInit()
    pf, great, good, miss = 0, 0, 0, 0
    buttonTime = 0
    timer = 0
    pW = 0
    buttonCol[4] = 0
    textCol[4] = 0
    tCol = timingCol[1]
    isMiss = true
    tableClear(timingEffect)
    tableClear(pfEffect)
    speed = 1
    lastTimer = 0
    globalTimer = 0
    isPaused = false
end

function keyInit()
    lastTimer = timer
    timer = 0
    buttonCol[4] = 0
    buttonTime = 0
    lastGlobalTimer = globalTimer
    globalTimer = 0
    isMiss = false
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

    love.graphics.setColor(buttonCol)
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

    for i, v in ipairs(msEffect) do
    love.graphics.setColor(v[1])
    love.graphics.rectangle("fill", v[2], v[3], v[4], v[5])
    end

    love.graphics.setColor(white)
    love.graphics.printf({timingCol[2], "perfect " .. pf, timingCol[3], "\ngreat " .. great, timingCol[4], "\ngood " .. good, timingCol[1], "\nmiss " .. miss, white, "\nspeed: " .. string.format("%.1f", speed) .. "x"}, font[1], 0, 110, gWidth, "center")

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
        love.graphics.printf(string.format("%.3f", lastGlobalTimer) .. "s", font[2], 0 , 230, gWidth, "center")
    end
end

function titleUI()
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("time", font[3], 0, 16, gWidth, "center")
    love.graphics.printf({{1, 1, 1}, "\n\npress ", {0.95, 0.7, 0.4}, "space ", {1, 1, 1}, "to start", {0.95, 0.5, 0.4}, "\n\n\ncontrols\n\n", {0.95, 0.7, 0.4}, "[space]", {1, 1, 1},  " hit object\n", {0.95, 0.7, 0.4}, "[p]", {1, 1, 1}, " pause\n\n", {0.95, 0.7, 0.4}, "[up/down] ", {1, 1, 1}, "adjust\nspeed"}, font[1], 0, 16, gWidth, "center")
    love.graphics.print(ver, font[2], 10, gHeight - 44)
end

function pauseUI()
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("- PAUSED -", font[3], 0, 50, gWidth, "center")
    love.graphics.printf("Escape: Exit\nP: Unpause\nR: Reset", font[1], 0, 195, gWidth, "center")
end

function debugUI()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(love.timer.getFPS() .. " FPS", font[2], 10, 10)
    love.graphics.print(wWidth .. "x" .. wHeight, font[2], 10, 25)
end
