local progX = (gWidth - 120) / 2
local pfP, grP, gdP = 2, 1.95, 1.5
currP, maxP = 0, 0

-- title screen anim & states
titleSkin, titleState, titleAnimTime = 1, 1, 0

function gameDisplay()
    -- game
    love.graphics.push()
    love.graphics.translate(tX, tY)
    gameUI()
    love.graphics.pop()
    
    -- background
    if isPaused or isFail or isCountdown or state ~= "game" then
        gameOverlay()
    else
    end

    if state == "game" then
        lowHealthOverlay()
    end
    
    -- menu & title
    love.graphics.push()
    love.graphics.translate((wWidth - gWidth) / 2, (wHeight - gHeight) / 2 + 23)
    if state == "title" then
        titleUI()
    end
    if state == "mode" then
        modeUI()
    end
    if state == "options" then
        optionsUI()
    end
    if state == "about" then
        aboutUI()
    end
    if isCountdown then
        countdownUI()
    end
    if isPauseDelay then
        pauseDelay()
    end
    love.graphics.pop()

    -- fail screen
    if mode ~= 2 then
        love.graphics.push()
        love.graphics.translate((wWidth - gWidth) / 2, (wHeight - gHeight) / 2 + 8)
            if isFail then
                failUI()
            end
        love.graphics.pop()
    else
        love.graphics.push()
        love.graphics.translate((wWidth - gWidth) / 2, (wHeight - gHeight) / 2 + 10)
            if isFail then
                failUI()
            end
        love.graphics.pop()
    end
    
    -- pause screen
    love.graphics.push()
    love.graphics.translate((wWidth - gWidth) / 2, (wHeight - gHeight) / 2)
    if isPaused and not isPauseDelay then
        pauseUI()
    end

    love.graphics.pop()
    
    if isDebug then
        debugUI()
    end

    for i, txt in ipairs(textInfo) do
        love.graphics.setColor(1, 1, 1, 0.5)
        love.graphics.printf(txt[1], font[2], (wWidth - gWidth) / 2, love.graphics.getHeight() - 40 - 20 * (i - 1), gWidth, "center")
    end
end

function gameKey(key)
    -- somewhat a workaround
    if key == "f11" then
        if not love.window.getFullscreen() then
            love.window.setMode(800, 600, {fullscreen = true, fullscreentype = "exclusive"})
            wWidth, wHeight = 800, 600
        else
            love.window.setMode(gWidth, gHeight, {fullscreen = false})
            wWidth, wHeight = gWidth, gHeight
        end
    end

    if key == "f3" then
        if love.window.getVSync() == 0 then
            love.window.setVSync(1)
            table.insert(textInfo, {"vsync enabled", 0})
        else
            love.window.setVSync(0)
            table.insert(textInfo, {"vsync disabled", 0})
        end
    end

    if state == "game" then
        if not isPaused and not isFail and not isCountdown then
            if not love.keyboard.hasKeyRepeat() then
                if key == keys.hit and timer > 0.75 and timer < 0.85 then
                    if buttonSkin == 3 then
                        table.insert(tObjCircle, {{0.5, 1, 1, 1}, gWidth / 2 - 5, 85, 26, 0})
                    else
                        table.insert(timingEffect, {{0.5, 1, 1, 1}, eX, eY, eW, eH, eT})
                    end
                    good = good + 1
                    lifeBar = lifeBar + 3
                    keyInit()
                    currP = currP + gdP
                    maxP = maxP + pfP
                end
                
                if key == keys.hit and timer > 0.85 and timer < 0.95 then
                    if buttonSkin == 3 then
                        table.insert(tObjCircle, {{1, 0.5, 0.25, 1}, gWidth / 2 - 5, 85, 26, 0})
                    else
                        table.insert(timingEffect, {{1, 0.5, 0.25, 1}, eX, eY, eW, eH, eT})
                    end
                    great = great + 1
                    lifeBar = lifeBar + 4
                    keyInit()
                    currP = currP + grP
                    maxP = maxP + pfP
                end
            
                if key == keys.hit and timer > 0.95 and timer < 1.05 then
                    if buttonSkin == 3 then
                        table.insert(tObjCircle, {{0.5, 1, 1, 1}, gWidth / 2 - 5, 85, 26, 0})
                    else
                        table.insert(timingEffect, {{0.5, 1, 1, 1}, eX, eY, eW, eH, eT})
                    end
                    table.insert(pfEffect, {{0.5, 1, 1, 1}, progX + 88, 58, 13, 18, 0})
                    pf = pf + 1
                    lifeBar = lifeBar + 5
                    keyInit()
                    currP = currP + pfP
                    maxP = maxP + pfP
                end
                
                if key == keys.hit and timer > 1.05 and timer < 1.15 then
                    if buttonSkin == 3 then
                        table.insert(tObjCircle, {{1, 0.5, 0.25, 1}, gWidth / 2 - 5, 85, 26, 0})
                    else
                        table.insert(timingEffect, {{1, 0.5, 0.25, 1}, eX, eY, eW, eH, eT})
                    end
                    great = great + 1
                    lifeBar = lifeBar + 4
                    keyInit()
                    currP = currP + grP
                    maxP = maxP + pfP
                end
            
                if key == keys.hit and timer > 1.15 and timer < 1.25 then
                    if buttonSkin == 3 then
                        table.insert(tObjCircle, {{0.5, 1, 1, 1}, gWidth / 2 - 5, 85, 26, 0})
                    else
                        table.insert(timingEffect, {{0.5, 1, 1, 1}, eX, eY, eW, eH, eT})
                    end
                    good = good + 1
                    lifeBar = lifeBar + 3
                    keyInit()
                    currP = currP + gdP
                    maxP = maxP + pfP
                end
            end
            
            if mode == 1 then
                if key == "up" and speed < 5 then
                    if love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl") then
                        speed = speed + .25
                    else
                        speed = speed + .05
                    end

                    buttonTime = 0
                    timer = 0
                    lastTimer = 0
                    TimingTimer = 0
                    buttonCol[4] = 0
                    textCol[4] = 0
                    love.audio.play(se.sel_1)
                end
                    
                if key == "down" and speed > 0.1 then
                    speed = speed - .05
                    buttonTime = 0
                    timer = 0
                    lastTimer = 0
                    TimingTimer = 0
                    buttonCol[4] = 0
                    textCol[4] = 0
                    love.audio.play(se.sel_1)
                end
            end
        end

        if not isFail and not isCountdown and not isPauseDelay then
            if key == "p" or key == "escape" then
                if not isPaused then
                    isPaused = true
                    love.audio.play(se.sel_1)
                else
                    overSel = 1
                    oYSel = 162
                    isPauseDelay = true
                    love.audio.play(se.sel_1)
                end
            end
        end
    end

    if state == "mode" and state ~= "about" then
        if key == "escape" then
            state = "title"
            love.audio.play(se.sel_2)
        end

        if mode == 1 or mode == 2 then
            if key == keys.hit or key == "return" then
                state = "game"
                isCountdown = true
                isExit = -1
                love.audio.play(se.sel_2)
            end
        end
        
        if mode == 2 and state ~= "game" then
            love.keyboard.setKeyRepeat(true)
        else
            love.keyboard.setKeyRepeat(false)
        end

        if mode == 3 then
            if key == keys.hit or key == "return" then
                optSel = 1
                state = "options"
                love.audio.play(se.sel_2)
            end
        end

        if mode == 4 then
            if key == keys.hit or key == "return" then
                state = "about"
                backState = 0
                love.audio.play(se.sel_2)
            end
        end

        if key == "up" then
            mode = mode - 1
            selY = selY - 26
            love.audio.play(se.sel_1)
        end
        if key == "down" then
            mode = mode + 1
            selY = selY + 26
            love.audio.play(se.sel_1)
        end

        if mode == 2 then            
            if key == "left" then
                spdMax = spdMax - 1
                if spdMax >= 15 then
                    love.audio.play(se.sel_1)
                end
            end
            
            if key == "right" then
                spdMax = spdMax + 1
                if spdMax <= 50 then
                    love.audio.play(se.sel_1)
                end
            end
        end
    end

    if state == "options" then
        if key == "up" and optSel == 4 then
            selYOpt = selYOpt - 26 + 10
            love.audio.play(se.sel_1)
        end

        if key == "down" and optSel == 3 then
            selYOpt = selYOpt + 26 - 10
            love.audio.play(se.sel_1)
        end

        if key == "up" then
            optSel = optSel - 1
            selYOpt = selYOpt - 26
            love.audio.play(se.sel_1)
        end

        if key == "down" then
            optSel = optSel + 1
            selYOpt = selYOpt + 26
            love.audio.play(se.sel_1)
        end
        
        if optSel == 1 then
            if key == "left" or key == "right" then
                if isAudio then
                    isAudio = false
                else
                    isAudio = true
                end
                love.audio.play(se.sel_2)
            end
        end

        if optSel == 2 then
            if key == "left" then
                buttonSkin = buttonSkin - 1
                love.audio.play(se.sel_2)
            end
            if key == "right" then
                buttonSkin = buttonSkin + 1
                love.audio.play(se.sel_2)
            end
        end

        if optSel == 3 then
            if key == "left" or key == "right" then
                if shakeEnabled then
                    shakeEnabled = false
                else
                    shakeEnabled = true
                end
                love.audio.play(se.sel_2)
            end
        end

        if optSel == 4 then
            if key == keys.hit or key == "return" then
                state = "mode"
                optSel = 1
                selYOpt = 64
                if isAudio ~= decO.audio or buttonSkin ~= decO.skin or shakeEnabled ~= decO.shakeEnabled then
                    saveData("options.json", {audio = isAudio, skin = buttonSkin, shakeEnabled = shakeEnabled})
                end
                love.audio.play(se.sel_2)
            end
        end
    end

    if state == "about" then
        if key == keys.hit and backState < 1 or key == "return" and backState < 1 then
            backState = backState + 1
        elseif key == keys.hit or key == "return" then
            state = "mode"
            love.audio.play(se.sel_2)
        end
    end

    if state == "title" then
        if key == keys.hit or key == "return" then
            state = "mode"
            mode = 1
            selY = 64
            isExit = -1
            love.audio.play(se.sel_1)
        end

        if key == "left" then
            titleState = titleState - 1
            love.audio.play(se.sel_1)
        end

        if key == "right" then
            titleState = titleState + 1
            love.audio.play(se.sel_1)
        end
    end
    
    if isPaused then
        if not isPauseDelay then
            if key == "up" then
                overSel = overSel - 1
                oYSel = oYSel - 26
                love.audio.play(se.sel_1)
            end
            if key == "down" then
                overSel = overSel + 1
                oYSel = oYSel + 26
                love.audio.play(se.sel_1)
            end
        end
        if key == "return" or key == keys.hit then
            if overSel == 1 then
                isPauseDelay = true
                love.audio.play(se.sel_1)
                overSel = 1
                oYSel = 162
            end
            if overSel == 2 then
                gameInit()
                isCountdown = true
                love.audio.play(se.sel_2)
                overSel = 1
                oYSel = 162
            end
            if overSel == 3 then
                state = "mode"
                isExit = -1
                love.audio.play(se.sel_2)
                gameInit()
                overSel = 1
                oYSel = 162
            end
        end
    end

    if isFail then
        if key == "escape" then
            gameInit()
            state = "title"
            isExit = -1
            love.audio.play(se.sel_2)
        end
        if key == "r" then
            gameInit()
            isCountdown = true
            isFail = false
            love.audio.play(se.sel_2)
        end
    end

    if key == "escape" and state == "title" then
        isExit = isExit + 1
        love.audio.play(se.sel_2)
    elseif key == "escape" and state == "mode" then
        state = "title"
        love.audio.play(se.sel_2)
    elseif key == "escape" and state == "options" then
        state = "mode"
        optSel = 1
        selYOpt = 64
        if isAudio ~= decO.audio or buttonSkin ~= decO.skin or shakeEnabled ~= decO.shakeEnabled then
            saveData("options.json", {audio = isAudio, skin = buttonSkin, shakeEnabled = shakeEnabled})
        end
        love.audio.play(se.sel_2)
    end
    
    if key == "f4" then
        if not isDebug then
            isDebug = true
        else
            isDebug = false
        end
    end
end

TButtonCol, TtextCol = {1, 1 ,1, 0}, {0, 0, 0, 0}
Tb2S = 2.5
function gameLoop(dt)
    if not isAudio then
        love.audio.setVolume(0)
    else
        love.audio.setVolume(1)
    end

    for i, txt in ipairs(textInfo) do
        txt[2] = txt[2] + dt
        if txt[2] > 1 then
            table.remove(textInfo, i)
        end
    end

    if state ~= "game" then
        titleAnimTime = titleAnimTime + dt
        TButtonCol[4] = TButtonCol[4] + dt
        TtextCol[4] = TtextCol[4] + dt
        Tb2S = (titleAnimTime * 2.5)

        -- title state in pages
        if titleState < 1 then
            titleState = 2
        end

        if titleState > 2 then
            titleState = 1
        end

        -- title animation
        if titleAnimTime > 1 then
            titleSkin = titleSkin + 1
            titleAnimTime = 0
            TButtonCol[4], TtextCol[4], Tb2S = 0, 0, 0
            if titleSkin > 3 then
                table.insert(tObjCircle, {{0.5, 1, 1, 1}, gWidth / 2 - 3, 115, 26, 0})
            else
                table.insert(timingEffect, {{0.5, 1, 1, 1}, eX + 2, eY + 30, eW, eH, eT})
            end
        end

        if titleSkin > 3 then
            titleSkin = 1
        end

        -- ctrl + c - v
        for i, v in ipairs(timingEffect) do
            v[6] = v[6] + dt
            
            if v[6] > 0 then
                v[1][4] = v[1][4] - dt * 3
            end
            
            if v[6] > 0.75 then
                table.remove(timingEffect, i)
            end
        end
        for i, v in ipairs(tObjCircle) do
            v[5] = v[5] + dt
            
            if v[5] > 0 then
                v[1][4] = v[1][4] - dt * 3
            end
            
            if v[5] > 0.75 then
                table.remove(tObjCircle, i)
            end
        end
    else
        titleState = 1
        titleSkin = 1
        titleAnimTime = 0
        TButtonCol[4], TtextCol[4], Tb2S = 0, 0, 0
    end
    
    if not isPaused and not isPauseDelay and state == "game" then
        if love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl") then
            love.keyboard.setKeyRepeat(true)
        else
            love.keyboard.setKeyRepeat(false)
        end
    end

    if state == "options" then
        if optSel < 1 then
            optSel = 4
            selYOpt = 64 + 26 * 3 + 16
        end
        
        if optSel > 4 then
            optSel = 1
            selYOpt = 64
        end
    end

    if buttonSkin < 1 then
        buttonSkin = 3
    end
    
    if buttonSkin > 3 then
        buttonSkin = 1
    end

    bpm = 60 * speed

    if state == "mode" then
        se.sel_2:setPitch(1.25)
    end
    
    pauseDelayFunc(dt)

    -- red tint on low health
    if not isFail then
        if lifeBar <= 15 and redTint[4] < 0.05 then
            redTint[4] = redTint[4] + dt * 0.2
        elseif lifeBar > 15 and redTint[4] > 0 then
            redTint[4] = redTint[4] - dt * 0.1
        end
    end

    if isFail then
        redTint[4] = 0.02
        -- save score
        if mode == 1 then
            if pf > hiPerf.normal then
                saveData("score.json", {normal = pf, random = hiPerf.random, comboNormal = hiPerf.comboNormal, comboRandom = hiPerf.comboRandom})
            end
            
            if maxCombo > hiPerf.comboNormal then
                saveData("score.json", {normal = hiPerf.normal, random = hiPerf.random, comboNormal = maxCombo, comboRandom = hiPerf.comboRandom})
            end
            loadScore()
        end

        if mode == 2 then
            if pf > hiPerf.random then
                saveData("score.json", {normal = hiPerf.normal, random = pf, comboNormal = hiPerf.comboNormal, comboRandom = hiPerf.comboRandom})
            end

            if maxCombo > hiPerf.comboRandom then
                saveData("score.json", {normal = hiPerf.normal, random = hiPerf.random, comboNormal = hiPerf.comboNormal, comboRandom = maxCombo})
            end
            loadScore()
        end
    end

    if isShake or isShakeHit then
        shakeTime = shakeTime + dt
    else
        tX, tY = (wWidth - gWidth) / 2, (wHeight - gHeight) / 2 + 23
    end

    if shakeTime > 0 and isShake then
        tX, tY = (wWidth - gWidth) / 2 + love.math.random(2.25, -2.25), (wHeight - gHeight) / 2 + 23 + love.math.random(2.25, -2.25)
    end
    
    if shakeTime > 0 and isShakeHit and speed > 3.5 then
        tX, tY = (wWidth - gWidth) / 2 + love.math.random(1.25, -1.25), (wHeight - gHeight) / 2 + 23 + love.math.random(1.25, -1.25)
    end

    if shakeTime > 0 and isShakeHit and speed > 4.25 then
        tX, tY = (wWidth - gWidth) / 2 + love.math.random(1.65, -1.65), (wHeight - gHeight) / 2 + 23 + love.math.random(1.65, -1.65)
    end

    if shakeTime > 0 and isShakeHit and speed > 4.5 then
        tX, tY = (wWidth - gWidth) / 2 + love.math.random(2, -2), (wHeight - gHeight) / 2 + 23 + love.math.random(2, -2)
    end
    
    if shakeTime > 0.05 and isShake then
        shakeTime = 0
        isShake = false
    end

    if shakeTime > 0.05 and isShakeHit then
        shakeTime = 0
        isShakeHit = false
    end

    if isExit == 1 then
        love.event.quit(0)
    end

    if mode < 1 then
        mode = 4
        selY = 90 + 26 * 2
    end

    if mode > 4 then
        mode = 1
        selY = 64
    end

    if mode == 2 then
        fTextY = 205
    end

    if spdMax > 50 then
        spdMax = 50
    end

    if spdMax < 15 then
        spdMax = 15
    end

    if isPaused then
        if overSel < 1 then
            overSel = 3
            oYSel = 162 + 26 * 2
        end
        if overSel > 3 then
            overSel = 1
            oYSel = 162
        end
    end

    if isCountdown then
        countdownCool = countdownCool + dt
    end

    if countdownCool > 0 and countdownCool < 0.025 then
        se.sel_2:setPitch(1.25)
        love.audio.play(se.sel_2)
    end

    if countdownCool > 1 and countdownCool < 1.025 then
        se.sel_2:setPitch(1)
        love.audio.play(se.sel_2)
    end

    if countdownCool > 2 then
        isCountdown = false
        countdownCool = 0
        se.sel_2:setPitch(1)
    end

    if not isPaused and not isFail and not isCountdown and state == "game" then
        pW = width * (timer / 1.25)
        TimingTimer = TimingTimer + dt
        timer = timer + dt * speed
        b2S = (timer * 2.5)
        circRad = (math.pi * 2) * timer
        buttonTime = buttonTime + dt * speed
        sec = sec + dt
        if sec > 59 then
            sec = 0
            min = min + 1
        end

        if currP > 0 then
            pDisplay = (currP / maxP) * 100
        end

        if isPF then
            animHitTime = animHitTime + dt
        end

        -- health bar
        if lifeBar > 100 then
            lifeBar = 100
        end
        if lifeBar < 1 then
            se.miss:setPitch(0.9)
            lifeBar = 0
            isFail = true
        end

        if mode == 1 then
            if timer > 1.25 and lifeBar > 0 then
                lastTimer = timer
                timer = 0
                TimingTimer = 0
                miss = miss + 1
                lifeBar = lifeBar - 16
                seType = 0
                combo = 0
                isMiss = true
                love.audio.play(se.miss)
                if shakeEnabled then
                    isShake = true
                end
                maxP = maxP + pfP
                table.insert(msEffect, {{1, 0.25, 0.25, 1}, progX + 118, 58, 8, 18, 0})
                -- mirror of lifebar values
                table.insert(lMObj, {gWidth - 15, 5 + 215, 7, totalLife * currLife, {1, 0.25, 0.25, 0.6}})
            end
        elseif mode == 2 then
            if timer > 1.25 and lifeBar > 0 then
                lastTimer = timer
                timer = 0
                TimingTimer = 0
                miss = miss + 1
                lifeBar = lifeBar - 16
                seType = 0
                isMiss = true
                speed = 1
                combo = 0
                love.audio.play(se.miss)
                if shakeEnabled then
                    isShake = true
                end
                maxP = maxP + pfP
                table.insert(msEffect, {{1, 0.25, 0.25, 1}, progX + 118, 58, 8, 18, 0})
                table.insert(lMObj, {gWidth - 15, 5 + 215, 7, totalLife * currLife, {1, 0.25, 0.25, 0.6}})
            end
        end
        
        if buttonTime < 1 then
            buttonCol[4] = buttonCol[4] + dt * speed
            buttonRed[4] = buttonRed[4] + dt * speed
            textCol[4] = textCol[4] + dt * speed
        end
        
        if buttonTime > 1 and timer < 1 then
            buttonCol[4] = 0
            buttonRed[4] = 0
            textCol[4] = 0
            buttonTime = 0
        end

        if combo > maxCombo then
            maxCombo = combo
        end

        if speed < 0.1 then
            speed = 0.1
        end
        if speed > 5 then
            speed = 5
        end
        
        if animHitTime > 0.5 then
            isPF = false
            animHitTime = 0
        end

        if timer > 0.75 and timer < 0.85 then
            tCol = timingCol[4]
        elseif timer > 0.85 and timer < 0.95 then
            tCol = timingCol[3]
        elseif timer > 0.95 and timer < 1.05 then
            tCol = timingCol[2]
        elseif timer > 1.05 and timer < 1.15 then
            tCol = timingCol[3]
        elseif timer > 1.15 and timer < 1.25 then
            tCol = timingCol[4]
        else
            tCol = timingCol[5]
        end

        for i, v in ipairs(timingEffect) do
            v[6] = v[6] + dt

            if v[6] > 0 then
                v[1][4] = v[1][4] - dt * 3
            end

            if v[6] > 0.75 then
                table.remove(timingEffect, i)
            end
        end

        for i, v in ipairs(tObjCircle) do
            v[5] = v[5] + dt
            
            if v[5] > 0 then
                v[1][4] = v[1][4] - dt * 3
            end
            
            if v[5] > 0.75 then
                table.remove(tObjCircle, i)
            end
        end

        for i, v in ipairs(pfEffect) do
            v[6] = v[6] + dt

            if v[6] > 0 then
                v[1][4] = v[1][4] - dt * 3
            end

            if v[6] > 0.75 then
                table.remove(pfEffect, i)
            end
        end

        for i, v in ipairs(msEffect) do
            v[6] = v[6] + dt

            if v[6] > 0 then
                v[1][4] = v[1][4] - dt * 3
            end

            if v[6] > 0.75 then
                table.remove(msEffect, i)
            end
        end
    end

    for i, v in ipairs(lMObj) do
        v[5][4] = v[5][4] - dt * 1.6
        if v[5][4] < 0 then
            table.remove(lMObj, i)
        end
    end

    if state == "title" or isPaused then
        white[4] = 0.15
        tipCol[4] = 0.15
    else
        white[4] = 1
        tipCol[4] = 1
    end
end
