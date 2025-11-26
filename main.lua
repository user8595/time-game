function love.load()
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
    love.graphics.setDefaultFilter("nearest", "nearest")
    
    require("lua.defaults")
    require("lua.states")
    require("lua.save")
    require("lua.game")
    
    newSave("options.json", {audio = true, skin = 1, shakeEnabled = true})
    newSave("score.json", {normal = 0, random = 0, comboNormal = 0, comboRandom = 0})
    loadOptions()
    loadScore()
    
    -- game audio
    se = {
        miss = love.audio.newSource("/assets/se/miss.wav", "static"),
        hit_1 = love.audio.newSource("/assets/se/hit_1.wav", "static"),
        hit_2 = love.audio.newSource("/assets/se/hit_2.wav", "static"),
        sel_1 = love.audio.newSource("/assets/se/sel_1.wav", "static"),
        sel_2 = love.audio.newSource("/assets/se/sel_2.wav", "static"),
    }
    -- textures
    tex = {
        logo = love.graphics.newImage("/assets/icon.png"),
        button_2 = love.graphics.newImage("/assets/tex/button_2.png"),
        up = love.graphics.newImage("/assets/tex/key-up.png"),
        up_p = love.graphics.newImage("/assets/tex/key-up1.png"),
        down = love.graphics.newImage("/assets/tex/key-down.png"),
        down_p = love.graphics.newImage("/assets/tex/key-down1.png"),
        p = love.graphics.newImage("/assets/tex/key-p.png"),
        p_p = love.graphics.newImage("/assets/tex/key-p1.png"),
        f3 = love.graphics.newImage("/assets/tex/key-f3.png"),
        f3_p = love.graphics.newImage("/assets/tex/key-f31.png"),
        space = love.graphics.newImage("/assets/tex/key-space.png"),
    }
end

function love.keypressed(key)
    gameKey(key)
end

function love.update(dt)
    gameLoop(dt)
end

function love.resize(w, h)
    wWidth, wHeight = w, h
end

function love.focus(f)
    if not f then
        if state == "game" and not isPaused and not isFail and not isCountdown then
            isPaused = true
        end
    end
end

function love.draw()
    gameDisplay()
end
