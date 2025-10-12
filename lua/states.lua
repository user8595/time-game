local progX = (gWidth - 120) / 2

function gameDisplay()
    love.graphics.push()
    love.graphics.translate((wWidth - gWidth) / 2, (wHeight - gHeight) / 2 + 23)
    gameUI()
    love.graphics.pop()
    
    if state == "title" or state == "mode" or isPaused or isFail then
        gameOverlay()
    else
    end

    love.graphics.push()
    love.graphics.translate((wWidth - gWidth) / 2, (wHeight - gHeight) / 2 + 23)
    if state == "title" then
        titleUI()
    end
    if state == "mode" then
        modeUI()
    end
    if isFail then
        failUI()
    end
    love.graphics.pop()
    
    if isPaused then
        pauseUI()
    end
    if isDebug then
        debugUI()
    end
end

function gameKey(key)
    if state == "game" then
        if not isPaused and not isFail then
            if key == "space" and timer > 0.75 and timer < 0.85 then
                table.insert(timingEffect, {{0.25, 0.5, 1, 1}, gWidth / 2 - 29, 6, 48, 48, 0})
                good = good + 1
                lifeBar = lifeBar + 3
                keyInit()
            end
            
            if key == "space" and timer > 0.85 and timer < 0.95 then
                table.insert(timingEffect, {{1, 0.5, 0.25, 1}, gWidth / 2 - 29, 6, 48, 48, 0})
                great = great + 1
                lifeBar = lifeBar + 4
                keyInit()
            end
        
            if key == "space" and timer > 0.95 and timer < 1.05 then
                table.insert(timingEffect, {{0.5, 1, 1, 1}, gWidth / 2 - 29, 6, 48, 48, 0})
                table.insert(pfEffect, {{0.5, 1, 1, 1}, progX + 88, 58, 13, 18, 0})
                pf = pf + 1
                lifeBar = lifeBar + 5
                keyInit()
            end
        
            if key == "space" and timer > 1.05 and timer < 1.15 then
                table.insert(timingEffect, {{1, 0.5, 0.25, 1}, gWidth / 2 - 29, 6, 48, 48, 0})
                great = great + 1
                lifeBar = lifeBar + 4
                keyInit()
            end
        
            if key == "space" and timer > 1.15 and timer < 1.25 then
                table.insert(timingEffect, {{0.25, 0.5, 1, 1}, gWidth / 2 - 29, 6, 48, 48, 0})
                good = good + 1
                lifeBar = lifeBar + 3
                keyInit()
            end
        
            if mode == 1 then
                if key == "up" and speed < 4 then
                    speed = speed + .1
                    buttonTime = 0
                    timer = 0
                    lastTimer = 0
                    TimingTimer = 0
                    buttonCol[4] = 0
                    textCol[4] = 0
                end
                
                if key == "down" and speed > 0.1 then
                    speed = speed - .1
                    buttonTime = 0
                    timer = 0
                    lastTimer = 0
                    TimingTimer = 0
                    buttonCol[4] = 0
                    textCol[4] = 0
                end
            end
        end
        
        
        if key == "p" and not isFail then
            if not isPaused then
                isPaused = true
            else
                isPaused = false
            end
        end
    end

    if state == "mode" then
        if key == "escape" then
            state = "title"
        end

        if key == "space" or key == "return" then
            state = "game"
            isExit = -1
        end

        if key == "up" then
            mode = mode - 1
            selY = selY - 26
        end
        if key == "down" then
            mode = mode + 1
            selY = selY + 26
        end

        if mode == 2 then            
            if key == "left" then
                spdMax = spdMax - 1
            end
            
            if key == "right" then
                spdMax = spdMax + 1
            end
        end
    end

    if state == "title" then
        if key == "space" or key == "return" then
            state = "mode"
            mode = 1
            selY = 64
            isExit = -1
        end
    end
    
    if isPaused then
        if key == "r" then
            gameInit()
        end
    end

    if isFail then
        if key == "escape" then
            gameInit()
            state = "title"
            isExit = -1
        end
    end

    if key == "escape" and state == "title" then
        isExit = isExit + 1
    elseif key == "escape" and state == "mode" then
        state = "title"
    elseif key == "escape" and state == "game" and isPaused then
        state = "title"
        isExit = 0
        gameInit()
    end
    
    if key == "f4" then
        if not isDebug then
            isDebug = true
        else
            isDebug = false
        end
    end
end

function gameLoop(dt)
    if isExit == 1 then
        love.event.quit(0)
    end

    if mode < 1 then
        mode = 2
        selY = 90
    end

    if mode > 2 then
        mode = 1
        selY = 64
    end

    if spdMax > 40 then
        spdMax = 40
    end

    if spdMax < 10 then
        spdMax = 10
    end

    if not isPaused and not isFail and state == "game" then
        pW = width * (timer / 1.25)
        TimingTimer = TimingTimer + dt
        timer = timer + dt * speed
        buttonTime = buttonTime + dt * speed
        
        if isPF then
            animHitTime = animHitTime + dt
        end

        -- health bar
        if lifeBar > 100 then
            lifeBar = 100
        end
        if lifeBar < 1 then
            lifeBar = 0
            isFail = true
        end

        if mode == 1 then
            if timer > 1.25 then
                lastTimer = timer
                timer = 0
                TimingTimer = 0
                miss = miss + 1
                lifeBar = lifeBar - 6
                isMiss = true
                table.insert(msEffect, {{1, 0.25, 0.25, 1}, progX + 118, 58, 8, 18, 0})
            end
        elseif mode == 2 then
            if timer > 1.25 then
                lastTimer = timer
                timer = 0
                TimingTimer = 0
                miss = miss + 1
                lifeBar = lifeBar - 6
                isMiss = true
                speed = 1
                table.insert(msEffect, {{1, 0.25, 0.25, 1}, progX + 118, 58, 8, 18, 0})
            end
        end

        if buttonTime < 1 then
            buttonCol[4] = buttonCol[4] + dt
            buttonRed[4] = buttonRed[4] + dt
            textCol[4] = textCol[4] + dt
        end
        
        if buttonTime > 1 and timer < 1 then
            buttonCol[4] = 0
            buttonRed[4] = 0
            textCol[4] = 0
            buttonTime = 0
        end

        if speed < 0.1 then
            speed = 0.1
        end
        if speed > 4 then
            speed = 4
        end
        
        if animHitTime > 0 and animHitTime < 0.1 then
            timingHit[4] = 1
        end
        if animHitTime > 0.1 and animHitTime < 0.5 then
            timingHit[4] = timingHit[4] - dt * 5
        end
        if animHitTime > 0.5 then
            isPF = false
            animHitTime = 0
            timingHit[4] = 0
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

        -- object hit effect
        -- values: colour, x, y, w, h, timer
        -- see in gameKey(key)
        for i, v in ipairs(timingEffect) do
            v[6] = v[6] + dt

            if v[6] > 0 then
                v[1][4] = v[1][4] - dt * 3
            end

            if v[6] > 0.75 then
                table.remove(timingEffect, i)
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

    if state == "title" or isPaused then
        white[4] = 0.15
        tipCol[4] = 0.15
    else
        white[4] = 1
        tipCol[4] = 1
    end
end
