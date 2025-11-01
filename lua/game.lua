local tableClear = require("table.clear")
local progX = (gWidth - 120) / 2
local judgeY = 132
local modeStrings = {
    "Play endlessly.",
    "Play while the game's speed\nchanges every hit.",
    "Game configuration.",
    "About game."
}
local totalLife = -215
local currLife = (lifeBar / 100)
local buttonYOff = 55
fTextY = 190
seType = 0

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
    seType = 0
    lifeBar = 100
    currP, maxP, pDisplay = 0, 0, 0
    min, sec = 0, 0
    isPaused = false
    isFail = false
    se.miss:setPitch(1)
    se.sel_2:setPitch(1.25)
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
    seType = seType + 1

    if seType % 1 == 0 then
        love.audio.play(se.hit_1)
        love.audio.stop(se.hit_2)
    end
    if seType % 2 == 0 then
        love.audio.stop(se.hit_1)
        love.audio.play(se.hit_2)
    end
    
    if mode == 2 then
        speed = 1 * (0.1 * love.math.random(10, spdMax))
    end
end

function gameOverlay()
    love.graphics.setColor(0, 0, 0, 0.85)
    love.graphics.rectangle("fill", 0, 0, wWidth, wHeight)
end

function gameUI()
    for _, v in ipairs(timingEffect) do
        love.graphics.setColor(v[1])
        love.graphics.rectangle("fill", v[2], v[3] + buttonYOff, v[4], v[5])
    end
    
    if timer > 1 then
        love.graphics.setColor({1, 0.75, 0.45, 0.75})
        love.graphics.rectangle("fill", gWidth / 2 - 25 - 5, 5 + buttonYOff, 50, 50)
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
    
    --TODO: Add button skins
    love.graphics.rectangle("fill", gWidth / 2 - 25, 10 + buttonYOff, 40, 40)
    if showHit then
        love.graphics.setColor(textCol)
        love.graphics.printf("HIT!", font[2], 0, 25 + buttonYOff, gWidth - 6, "center")
    end

    love.graphics.setColor(tCol)
    love.graphics.rectangle("fill", progX, 62 + buttonYOff, pW, 10)

    for _, v in ipairs(pfEffect) do
        love.graphics.setColor(v[1])
        love.graphics.rectangle("fill", v[2], v[3] + buttonYOff, v[4], v[5])
    end
    
    love.graphics.setColor({0.5, 1, 1, 1})
    love.graphics.rectangle("line", progX + 90, 60 + buttonYOff, 9, 14)

    love.graphics.setColor(timingCol[1])
    love.graphics.rectangle("line", progX + 120, 60 + buttonYOff, 4, 14)

    for _, v in ipairs(msEffect) do
        love.graphics.setColor(v[1])
        love.graphics.rectangle("fill", v[2], v[3] + buttonYOff, v[4], v[5])
    end

    love.graphics.setColor(white)
    love.graphics.printf({timingCol[2], "PF " .. pf, timingCol[3], "\nGR " .. great, timingCol[4], "\nGD " .. good, timingCol[1], "\nMS " .. miss}, font[1], 10, 75, gWidth, "left")
    
    currLife = (lifeBar / 100)
    
    if lifeBar > 15 then
        love.graphics.setColor(white)
    else
        love.graphics.setColor(red)
    end

    -- any better solution though
    if lifeBar <= 0 then
        love.graphics.setColor(0, 0, 0, 0)
    end

    love.graphics.rectangle("fill", gWidth - 15, 5 + 215, 7, totalLife * currLife)

    love.graphics.setColor(white)
    love.graphics.printf({tipCol, string.format("%.2f", speed) .. "x | " .. bpm .. " bpm"}, font[2], 0, gHeight - 42, gWidth, "center")
    love.graphics.setColor({0.95, 0.7, 0.6, 0.05})
    love.graphics.rectangle("fill", 0, gHeight - 50, gWidth, 27)

    if lastTimer > 0.75 and lastTimer < 0.85 then
        love.graphics.setColor(timingCol[4])
        love.graphics.printf("-GOOD", font[3], 10, judgeY, gWidth - 24, "center")
    elseif lastTimer > 0.85 and lastTimer < 0.95 then
        love.graphics.setColor(timingCol[3])
        love.graphics.printf("-GREAT", font[3], 10, judgeY, gWidth - 24, "center")
    elseif lastTimer > 0.95 and lastTimer < 1.05 then
        love.graphics.setColor(timingCol[2])
        love.graphics.printf("PERFECT!!", font[3], 10, judgeY, gWidth - 24, "center")
    elseif lastTimer > 1.05 and lastTimer < 1.15 then
        love.graphics.setColor(timingCol[3])
        love.graphics.printf("GREAT-", font[3], 10, judgeY, gWidth - 24, "center")
    elseif lastTimer > 1.15 and lastTimer < 1.25 then
        love.graphics.setColor(timingCol[4])
        love.graphics.printf("GOOD-", font[3], 10, judgeY, gWidth - 24, "center")
    elseif lastTimer > 1.25 then
        love.graphics.setColor(timingCol[1])
        love.graphics.printf("MISS", font[3], 10, judgeY, gWidth - 24, "center")
    else
        love.graphics.setColor(tipCol)
        love.graphics.printf("Press SPACE on blue", font[2], 10, judgeY + 7, gWidth - 24, "center")
    end    

    love.graphics.setColor(white)
    if pDisplay == 0 then
        love.graphics.printf({tipCol, "0%"}, font[2], 10, gHeight - 42, gWidth - 24, "left")
    else
        love.graphics.printf({tipCol, string.format("%.2f", pDisplay) .. "%"}, font[2], 10, gHeight - 42, gWidth - 24, "left")
    end
    love.graphics.printf({tipCol, string.format("%02d", math.floor(min)) .. ":" .. string.format("%02d", math.floor(sec))}, font[2], 0, gHeight - 42, gWidth - 10, "right")

    if lastTimer > 0 and not isMiss then
        love.graphics.printf(string.format("%.3f", lastTimingTimer) .. "s", font[2], 0 , judgeY + 25, gWidth, "center")
    end
end

function countdownUI()
    love.graphics.setColor(1, 1, 1)
    if countdownCool > 0 and countdownCool < 1 then
        love.graphics.printf("READY", font[3], 0, 95, gWidth, "center")
    elseif countdownCool > 1 then
        love.graphics.printf("GO!!", font[3], 0, 95, gWidth, "center")
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
    love.graphics.printf("options", font[3], 0, 90 + 26, gWidth, "center")
    love.graphics.printf("about", font[3], 0, 90 + 26 * 2, gWidth, "center")

    love.graphics.setColor(1, 1, 1, 0.15)
    love.graphics.rectangle("fill", 0, selY, gWidth, 26)
    
    --TODO: Show best score on mode menu
    love.graphics.setColor(1, 1, 1)
    if mode == 1 then
        love.graphics.printf(modeStrings[1], font[2], 0, gHeight - 70, gWidth, "center")
    elseif mode == 2 then
        love.graphics.printf(modeStrings[2], font[2], 0, gHeight - 70, gWidth, "center")
        if spdMax < 30 then
            if spdMax == 10 then
                love.graphics.printf({red, "max ", white, 1 * (0.1 * spdMax) .. "x >"}, font[2], 0, gHeight - 90, gWidth, "center")
            elseif spdMax == 40 then
                love.graphics.printf({white, "< ", red, "max ", white, 1 * (0.1 * spdMax) .. "x"}, font[2], 0, gHeight - 90, gWidth, "center")
            else
                love.graphics.printf({white, "< ", red, "max ", white, 1 * (0.1 * spdMax) .. "x >"}, font[2], 0, gHeight - 90, gWidth, "center")
            end
        else
            if spdMax == 40 then
                love.graphics.printf({white, "< ", red, "max ", 1 * (0.1 * spdMax) .. "x"}, font[2], 0, gHeight - 90, gWidth, "center")
            else
                love.graphics.printf({white, "< ", red, "max ", 1 * (0.1 * spdMax) .. "x", white, " >"}, font[2], 0, gHeight - 90, gWidth, "center")
            end
        end
    elseif mode == 3 then
        love.graphics.printf(modeStrings[3], font[2], 0, gHeight - 70, gWidth, "center")
    elseif mode == 4 then
        love.graphics.printf(modeStrings[4], font[2], 0, gHeight - 70, gWidth, "center")
    end
end

function optionsUI()
    --TODO: Finish option menu
end

function aboutUI()
    --TODO: Finish About menu
end

function pauseUI()
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("- PAUSED -", font[3], 0, 50, gWidth, "center")
    love.graphics.printf({{1, 0.5, 0.25}, "Escape:", {1, 1, 1}, " Exit", {1, 1, 0.35}, "\nP:", {1, 1, 1}, " Unpause", {0.95, 0.7, 0}, "\nR:", {1, 1, 1}, " Reset"}, font[1], 0, 195, gWidth, "center")
end

function failUI()
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf({{0.95, 0.7, 0.4}, "- RESULTS -"}, font[3], 0, 30, gWidth, "center")
    love.graphics.printf({timingCol[2], "PF: " .. pf, timingCol[3], "\nGR: " .. great, timingCol[4], "\nGD: " .. good, timingCol[1], "\nMS: " .. miss, {1, 1, 1}, "\nTOTAL: " .. pf + great + good}, font[1], 0, 58, gWidth, "center")
    
    if mode == 2 then
        if spdMax < 30 then
            love.graphics.printf({red, "max: ", white, 1 * (0.1 * spdMax) .. "x"}, font[1], 0, 180, gWidth, "center")
        else
            love.graphics.printf({red, "max: " .. 1 * (0.1 * spdMax) .. "x"}, font[1], 0, 180, gWidth, "center")
        end
    end

    --TODO: Change color on high score
    love.graphics.printf({{0.95, 0.7, 0.6}, string.format("%.2f", pDisplay) .. "%\n" .. string.format("%02d", math.floor(min)) .. ":" .. string.format("%02d", math.floor(sec))}, font[2], 0, 152, gWidth, "center")
    
    love.graphics.printf({{1, 0.5, 0.25}, "Escape", {1, 1, 1}, " to exit"}, font[2], 0, fTextY, gWidth, "center")
    love.graphics.printf({{0.95, 0.7, 0.2}, "R", {1, 1, 1}, " to restart"}, font[2], 0, fTextY + 17, gWidth, "center")
end

function debugUI()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(love.timer.getFPS() .. " FPS", font[2], 10, 10)
    love.graphics.print(wWidth .. "x" .. wHeight, font[2], 10, 25)
end
