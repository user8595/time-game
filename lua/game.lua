local tableClear = require("table.clear")
local system = love.system

local progX = (gWidth - 120) / 2
local judgeY = 132

local modeStrings = {
    "Play endlessly.",
    "Play while the game's speed\nchanges every hit.",
    "Game configuration.",
    "About game."
}
local optStrings = {
    "Enable sound effects.",
    "Change button skin.",
    "Enable screen shake effect."
}

totalLife = -215
currLife = (lifeBar / 100)
local buttonYOff = 55
local fontCombo = font[2]

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
    redTint[4] = 0
    tCol = timingCol[1]
    isMiss = true
    tableClear(timingEffect)
    tableClear(pfEffect)
    tableClear(msEffect)
    tableClear(lMObj)
    speed = 1
    lastTimer = 0
    TimingTimer = 0
    seType = 0
    lifeBar = 100
    currP, maxP, pDisplay = 0, 0, 0
    combo, maxCombo = 0, 0
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
    combo = combo + 1
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
        speed = 0.1 * love.math.random(10, spdMax)
    end

    if shakeEnabled then
        if speed > 3.5 then
            isShakeHit = true
        end
    end
end

function gameOverlay()
    love.graphics.setColor(0.07, 0.05, 0.08, 0.85)
    love.graphics.rectangle("fill", 0, 0, oWidth, oHeight)
end

function lowHealthOverlay()
    love.graphics.setColor(redTint)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
end

local pauseW, pauseTime, textColVal = 240, 0, 0.15
function pauseDelay()
    love.graphics.setColor({1, 1, 1})
    love.graphics.rectangle("fill", 40, gHeight / 2 - 29, pauseW * pauseTime, 12)
    love.graphics.setColor({1, 1, 1, 0.25})
    love.graphics.rectangle("line", 40, gHeight / 2 - 29, pauseW, 12)
    love.graphics.setColor({1, 1, 1, textColVal})
    love.graphics.printf(".....", font[1], 0, gHeight / 2 + 30, gWidth, "center")
end

function pauseDelayFunc(dt)
    if isPauseDelay then
        pauseTime = pauseTime + dt
        if textColVal < 1 then
            textColVal = textColVal + (pauseTime * 0.045)
        end
    end
    if pauseTime > 1 then
        isPauseDelay = false
        isPaused = false
        pauseTime = 0
        textColVal = 0.15
    end
end

function gameUI()
    if state == "game" and not isCountdown then
        for _, v in ipairs(timingEffect) do
            love.graphics.setColor(v[1])
            love.graphics.rectangle("fill", v[2], v[3] + buttonYOff, v[4], v[5])
        end
        for _, v in ipairs(tObjCircle) do
            love.graphics.setColor(v[1])
            love.graphics.circle("fill", v[2], v[3], v[4])
        end
    end
    
    if timer > 1 then
        if buttonSkin == 1 then
            love.graphics.setColor({1, 0.75, 0.45, 0.75})
        elseif buttonSkin == 2 then
            love.graphics.setColor({1, 0.75, 0.45, 0.5})
        end
        if buttonSkin == 3 then
            love.graphics.setColor({1, 0.75, 0.45, 0.5})
            love.graphics.circle("fill", gWidth / 2 - 5, 85, 24)
        else
            love.graphics.rectangle("fill", gWidth / 2 - 25 - 5, 5 + buttonYOff, 50, 50)
        end
    end

    if buttonSkin == 1 then
        if mode == 2 then
            if speed < 3 then
                love.graphics.setColor(buttonCol)
            else
                love.graphics.setColor(buttonRed)
            end
        else
            love.graphics.setColor(buttonCol)
        end
        love.graphics.rectangle("fill", gWidth / 2 - 25, 10 + buttonYOff, 40, 40)
        love.graphics.setColor(textCol)
        love.graphics.printf("HIT!", font[2], 0, 25 + buttonYOff, gWidth - 6, "center")
    elseif buttonSkin == 2 then
        love.graphics.setColor(1, 0.7, 0.5, 0.65)
        love.graphics.rectangle("line", gWidth / 2 - 25, 10 + buttonYOff, 40, 40)
        if state ~= "game" or isCountdown then
        else
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(tex.button_2, gWidth / 2 - 25 + 20, 10 + buttonYOff + 20, 0, b2S, b2S, tex.button_2:getWidth() / 2, tex.button_2:getHeight() / 2)
        end
    elseif buttonSkin == 3 then
        love.graphics.setColor(1, 0.75, 0.25)
        love.graphics.push()
        love.graphics.translate(gWidth / 2 - 5, 85)
        love.graphics.rotate(math.pi * 1.5)
        if state ~= "game" or isCountdown then
        else
            love.graphics.arc("fill", 0, 0, 20, 0, circRad)
        end
        love.graphics.pop()
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

    if lifeBar <= 0 then
        love.graphics.setColor(0, 0, 0, 0)
    end
    
    love.graphics.rectangle("fill", gWidth - 15, 5 + 215, 7, totalLife * currLife)
    
    for _, lMiss in ipairs(lMObj) do
        love.graphics.setColor(lMiss[5])
        love.graphics.rectangle("fill", lMiss[1], lMiss[2], lMiss[3], lMiss[4])
    end

    love.graphics.setColor(white)
    love.graphics.printf({tipCol, string.format("%.2f", speed) .. "x | " .. string.format("%.0f", bpm) .. " bpm"}, font[2], 0, gHeight - 42, gWidth, "center")
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

    love.graphics.setColor(1, 1, 1)
    if combo >= 5 then
        love.graphics.print({{0.9, 0.45, 0.75, 1}, "COMBO\n", white, combo .. "x"}, fontCombo, 10, 155)
        fontCombo:setLineHeight(1.2)
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
    love.graphics.print(ver, font[2], 10, gHeight - 44)
    
    love.graphics.setColor(1, 1, 1)
    if titleState == 1 then
        love.graphics.push()
        love.graphics.translate(0, -6)
        love.graphics.push()
        love.graphics.translate(2, 0)
        for _, v in ipairs(timingEffect) do
            love.graphics.setColor(v[1])
            love.graphics.rectangle("fill", v[2], v[3] + buttonYOff, v[4], v[5])
        end
        for _, v in ipairs(tObjCircle) do
            love.graphics.setColor(v[1])
            love.graphics.circle("fill", v[2], v[3], v[4])
        end
        if titleSkin == 1 then
            love.graphics.setColor(TButtonCol)
            love.graphics.rectangle("fill", gWidth / 2 - 23, 40 + 55, 40, 40)
            love.graphics.setColor(TtextCol)
            love.graphics.printf("HIT!", font[2], 2, 55 + 55, gWidth - 6, "center")
        elseif titleSkin == 2 then
            love.graphics.setColor(1, 0.7, 0.5, 0.65)
            love.graphics.rectangle("line", gWidth / 2 - 23, 40 + 55, 40, 40)
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(tex.button_2, gWidth / 2 - 3, 40 + 75, 0, Tb2S, Tb2S, tex.button_2:getWidth() / 2, tex.button_2:getHeight() / 2)
        elseif titleSkin == 3 then
            love.graphics.setColor(1, 0.75, 0.25)
            love.graphics.push()
            love.graphics.translate(gWidth / 2 - 3, 115)
            love.graphics.rotate(math.pi * 1.5)
            love.graphics.arc("fill", 0, 0, 20, 0, (math.pi * 2) * titleAnimTime)
            love.graphics.pop()
        end
        love.graphics.pop()
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", 125, 147, 79 * titleAnimTime, 7)
        love.graphics.pop()
    elseif titleState == 2 then
        love.graphics.printf({{0.95, 0.5, 0.4}, "\n\n\ncontrols"}, font[1], 0, -2, gWidth, "center")
        if love.keyboard.isDown("p") then
            love.graphics.draw(tex.p_p, 80, 80, 0, 2, 2)
        else
            love.graphics.draw(tex.p, 80, 80, 0, 2, 2)
        end
        if love.keyboard.isDown("up") then
            love.graphics.draw(tex.up_p, 180, 80, 0, 2, 2)
        else
            love.graphics.draw(tex.up, 180, 80, 0, 2, 2)
        end
        if love.keyboard.isDown("down") then
            love.graphics.draw(tex.down_p, 215, 80, 0, 2, 2)
        else
            love.graphics.draw(tex.down, 215, 80, 0, 2, 2)
        end
        love.graphics.draw(tex.space, 80, 135, 0, 2, 2)
        if love.keyboard.isDown("f3") then
            love.graphics.draw(tex.f3_p, 215, 135, 0, 2, 2)
        else
            love.graphics.draw(tex.f3, 215, 135, 0, 2, 2)
        end
        if love.mouse.isDown(1) then
            love.graphics.draw(tex.mouse_h, 150, 139, 0, 2, 2)
        else
            love.graphics.draw(tex.mouse, 150, 139, 0, 2, 2)
        end
        love.graphics.printf("pause game", font[2], 80, 117, gWidth, "left")
        love.graphics.printf("adj. speed", font[2], 0, 117, gWidth - 80, "right")
        love.graphics.printf("hit button", font[2], 80, 173, gWidth, "left")
        love.graphics.printf("toggle vsync", font[2], 0, 173, gWidth - 80, "right")
    end
    
    -- i'll do anything but clean code
    if system.getOS() == "Android" or system.getOS() == "iOS" then
        love.graphics.printf({{0.95, 0.7, 0.4}, "\n\n\n\n\n\n\n\n\n\n\n\ntouch ", {1, 1, 1}, "anywhere to play",}, font[1], 0, 4, gWidth, "center")
    else
        love.graphics.printf({{1, 1, 1}, "\n\n\n\n\n\n\n\n\n\n\n\npress ", {0.95, 0.7, 0.4}, "space ", {1, 1, 1}, "to play",}, font[1], 0, 4, gWidth, "center")
    end
    love.graphics.setColor(1, 1, 1, 0.25)

    -- unironically works
    if TSwitchTimer < math.pi then
        love.graphics.printf("<      >", font[2], 0, gHeight - 85, gWidth, "center")
    end
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
    
    love.graphics.setColor(1, 1, 1)
    if mode == 1 then
        love.graphics.printf(modeStrings[1], font[2], 0, gHeight - 70, gWidth, "center")
        love.graphics.printf({white, "best perf. ", {0.5, 1, 1, 1}, hiPerf.normal, {1, 1, 1, 0.35}, " | ", white, "best combo ", {0.9, 0.45, 0.75, 1}, hiPerf.comboNormal .. "x"}, font[2], 0, gHeight - 90, gWidth, "center")
    elseif mode == 2 then
        love.graphics.printf(modeStrings[2], font[2], 0, gHeight - 70, gWidth, "center")
        if spdMax > 30 then
            if spdMax >= 50 then
                love.graphics.printf({white, "best perf. ", {0.5, 1, 1, 1}, hiPerf.random, {1, 1, 1, 0.35}, " | ", {0.9, 0.45, 0.75, 1}, hiPerf.comboRandom .. "x", red, "   max ", white, "< ", red, 0.1 * spdMax .. "x "}, font[2], 0, gHeight - 90, gWidth, "center")
            else
                love.graphics.printf({white, "best perf. ", {0.5, 1, 1, 1}, hiPerf.random, {1, 1, 1, 0.35}, " | ", {0.9, 0.45, 0.75, 1}, hiPerf.comboRandom .. "x", red, "   max ", white, "< ", red, 0.1 * spdMax .. "x ", white, ">"}, font[2], 0, gHeight - 90, gWidth, "center")
            end
        else
            if spdMax <= 15 then
                love.graphics.printf({white, "best perf. ", {0.5, 1, 1, 1}, hiPerf.random, {1, 1, 1, 0.35}, " | ", {0.9, 0.45, 0.75, 1}, hiPerf.comboRandom .. "x", red, "   max ", white, 0.1 * spdMax .. "x >"}, font[2], 0, gHeight - 90, gWidth, "center")
            else
                love.graphics.printf({white, "best perf. ", {0.5, 1, 1, 1}, hiPerf.random, {1, 1, 1, 0.35}, " | ", {0.9, 0.45, 0.75, 1}, hiPerf.comboRandom .. "x", red, "   max ", white, "< ".. 0.1 * spdMax .. "x >"}, font[2], 0, gHeight - 90, gWidth, "center")
            end
        end
    elseif mode == 3 then
        love.graphics.printf(modeStrings[3], font[2], 0, gHeight - 70, gWidth, "center")
    elseif mode == 4 then
        love.graphics.printf(modeStrings[4], font[2], 0, gHeight - 70, gWidth, "center")
    end
end

function optionsUI()
    love.graphics.setColor({1, 1, 1})
    love.graphics.printf("options", font[3], 0, 16, gWidth, "center")
    
    love.graphics.printf("sound", font[3], 40, 64, gWidth - 40, "left")
    if isAudio then
        love.graphics.printf("on", font[3], gWidth - 100, 64, 100, "center")
    else
        love.graphics.printf("off", font[3], gWidth - 100, 64, 100, "center")
    end

    love.graphics.printf("skin", font[3], 40, 64 + 26, gWidth - 40, "left")
    love.graphics.printf(buttonSkin, font[3], 40, 64 + 26, gWidth - 85, "right")

    love.graphics.printf("screenshake", font[3], 40, 64 + 26 * 2, gWidth - 40, "left")
    if shakeEnabled then
        love.graphics.printf("on", font[3], gWidth - 100, 64 + 26 * 2, 100, "center")
    else
        love.graphics.printf("off", font[3], gWidth - 100, 64 + 26 * 2, 100, "center")
    end

    love.graphics.printf("back", font[3], 0, 64 + 26 * 3 + 16, gWidth, "center")

    love.graphics.setColor(1, 1, 1, 0.15)
    love.graphics.rectangle("fill", 0, selYOpt, gWidth, 26)
    love.graphics.setColor(1, 1, 1)
    if optSel < 4 then
        love.graphics.printf("<    >", font[3], 40, selYOpt, gWidth - 60, "right")
    end

    love.graphics.setColor(1, 1, 1)
    if optSel == 1 then
        love.graphics.printf(optStrings[1], font[2], 0, gHeight - 70, gWidth, "center")
    elseif optSel == 2 then
        love.graphics.printf(optStrings[2], font[2], 0, gHeight - 70, gWidth, "center")
    elseif optSel == 3 then
        love.graphics.printf(optStrings[3], font[2], 0, gHeight - 70, gWidth, "center")
    end
end

function aboutUI()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(tex.logo, gWidth / 2 - 30, gHeight / 2 - 54, 0, 0.23, 0.23)
    love.graphics.printf("time\n", font[3], 0, gHeight / 2 - 124, gWidth, "center")
    love.graphics.printf({{0.5, 0.5, 0.5}, "simple one keyed\ntiming game\n\n\n\n\n\n© 2025 eightyfivenine\nlicensed under the MIT license."}, font[1], 0, gHeight / 2 - 105, gWidth, "center")
    
    love.graphics.setColor(1, 1, 1, 0.15)
    love.graphics.rectangle("fill", 0, 90 + 26 * 4.25, gWidth, 26)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("back", font[3], 0, 90 + 26 * 4.25, gWidth, "center")
end

function pauseUI()
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("- PAUSED -", font[3], 0, 50, gWidth, "center")
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.printf("Up/Down to navigate", font[2], 0, 140, gWidth, "center")
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("resume", font[3], 0, 162, gWidth, "center")
    love.graphics.printf("retry", font[3], 0, 162 + 26, gWidth, "center")
    love.graphics.printf("quit", font[3], 0, 162 + 26 * 2, gWidth, "center")
    love.graphics.setColor(1, 1, 0.75, 0.15)
    love.graphics.rectangle("fill", 0, oYSel, gWidth, 26)
end

function failUI()
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf({{0.95, 0.7, 0.4}, "- RESULTS -"}, font[3], 0, 30, gWidth, "center")
    love.graphics.printf({timingCol[2], "PF: " .. pf, timingCol[3], "\nGR: " .. great, timingCol[4], "\nGD: " .. good, timingCol[1], "\nMS: " .. miss, {0.9, 0.45, 0.75, 1}, "\nMAX COMBO: " .. maxCombo .. "x", {1, 1, 1}, "\nTOTAL: " .. pf + great + good}, font[1], 0, 58, gWidth, "center")
    
    if mode == 2 then
        if spdMax < 30 then
            love.graphics.printf({red, "max: ", white, 0.1 * spdMax .. "x"}, font[1], 0, 192, gWidth, "center")
        else
            love.graphics.printf({red, "max: " .. 0.1 * spdMax .. "x"}, font[1], 0, 192, gWidth, "center")
        end
    end
    
    --TODO: Change color on high score
    love.graphics.printf({{0.95, 0.7, 0.6}, string.format("%.2f", pDisplay) .. "%\n" .. string.format("%02d", math.floor(min)) .. ":" .. string.format("%02d", math.floor(sec))}, font[2], 0, 167, gWidth, "center")
    
    love.graphics.printf({{1, 0.5, 0.25}, "Escape", {1, 1, 1}, " to exit"}, font[2], 0, fTextY + 10, gWidth, "center")
    love.graphics.printf({{0.95, 0.7, 0.2}, "R", {1, 1, 1}, " to restart"}, font[2], 0, fTextY + 27, gWidth, "center")
end

function debugUI()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(love.timer.getFPS() .. " FPS", font[2], 10, 10)
    love.graphics.print(love.graphics.getWidth() .. "x" .. love.graphics.getHeight(), font[2], 10, 25)
end
