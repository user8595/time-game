function gameDisplay()
    love.graphics.push()
    love.graphics.translate((wWidth - gWidth) / 2, (wHeight - gHeight) / 2 + 23)
    gameUI()
    love.graphics.pop()
    
    if state == "title" or isPaused then
        gameOverlay()
    else
    end

    love.graphics.push()
    love.graphics.translate((wWidth - gWidth) / 2, (wHeight - gHeight) / 2 + 23)
    if state == "title" then
        titleUI()
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
        if not isPaused then
            if key == "space" and timer > 0.75 and timer < 0.85 then
                good = good + 1
                lastTimer = timer
                timer = 0
                buttonCol[4] = 0
                buttonTime = 0
            end
            
            if key == "space" and timer > 0.85 and timer < 0.95 then
                great = great + 1
                lastTimer = timer
                timer = 0
                buttonCol[4] = 0
                buttonTime = 0
            end
        
            if key == "space" and timer > 0.95 and timer < 1.05 then
                pf = pf + 1
                lastTimer = timer
                timer = 0
                buttonCol[4] = 0
                buttonTime = 0
                isPF = true
            end
        
            if key == "space" and timer > 1.05 and timer < 1.15 then
                great = great + 1
                lastTimer = timer
                timer = 0
                buttonCol[4] = 0
                buttonTime = 0
            end
        
            if key == "space" and timer > 1.15 and timer < 1.25 then
                good = good + 1
                lastTimer = timer
                timer = 0
                buttonCol[4] = 0
                buttonTime = 0
            end
        
            if key == "up" then
                speed = speed + .1
                buttonTime = 0
                timer = 0
                lastTimer = 0
                buttonCol[4] = 0
                textCol[4] = 0
            end
        
            if key == "down" then
                speed = speed - .1
                buttonTime = 0
                timer = 0
                lastTimer = 0
                buttonCol[4] = 0
                textCol[4] = 0
            end
        end
        
        if isPaused then
            if key == "r" then
                gameInit()
            end
            if key == "escape" then
                state = "title"
                gameInit()
            else
            end
        end
        
        if key == "p" then
            if not isPaused then
                isPaused = true
            else
                isPaused = false
            end
        end
    else
        if key == "escape" then
            love.event.quit(0)
        end

        if key == "space" then
            state = "game"
        end
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
    if not isPaused and state == "game" then
        pW = width * (timer / 1.25)

        timer = timer + dt * speed
        buttonTime = buttonTime + dt * speed
        if isPF then
            animHitTime = animHitTime + dt
        end

        if timer > 1.25 then
            lastTimer = timer
            timer = 0
            miss = miss + 1
        end
        if buttonTime < 1 then
            buttonCol[4] = buttonCol[4] + dt
            textCol[4] = textCol[4] + dt
        end
        if buttonTime > 1 and timer < 1 then
            buttonCol[4] = 0
            textCol[4] = 0
            buttonTime = 0
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
        if speed < 0 then
            speed = 0
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
    end

    if state == "title" or isPaused then
        white[4] = 0.15
        tipCol[4] = 0.15
    else
        white[4] = 1
        tipCol[4] = 1
    end
end
