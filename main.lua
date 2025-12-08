local lovesize = require("lib.lovesize")
local mX, mY = love.mouse.getPosition()
local getOS = love.system.getOS()

function love.load()
    local system = love.system
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
    -- TODO: Finish mobile support
    if getOS == "Android" or getOS == "iOS" then
        love.graphics.setDefaultFilter("linear", "linear")
    else
        love.graphics.setDefaultFilter("nearest", "nearest")
    end
    -- duct tape
    gWindow = love.graphics.newCanvas(330, 280)
    gFull = love.graphics.newCanvas(480, 360)
    gCursor = love.mouse.newCursor("/assets/tex/cursor.png", 7, 7)
    lovesize.set(330, 280)
    love.mouse.setCursor(gCursor)
    
    require("lua.defaults")
    require("lua.states")
    require("lua.save")
    require("lua.game")
    
    if system.getOS() == "Android" or system.getOS() == "iOS" then
        love.window.setMode(330, 280, {fullscreen = true})
        oWidth, oHeight = 480, 360
    end
    
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
        mouse = love.graphics.newImage("/assets/tex/mouse.png"),
        mouse_h = love.graphics.newImage("/assets/tex/mouse_1.png"),
    }
end

function love.keypressed(key)
    gameKey(key)
end

function love.mousepressed(x, y, b, istouch)
    gameMouse(x, y, b, istouch)
end

function love.update(dt)
    gameLoop(dt)
    mX, mY = love.mouse.getPosition()
end

function love.resize(w, h)
    lovesize.resize(w, h)
end

function love.focus(f)
    if not f then
        if state == "game" and not isPaused and not isFail and not isCountdown then
            isPaused = true
        end
    end
end

function love.draw()
    love.graphics.setCanvas(gWindow)
    love.graphics.push()
    love.graphics.setBlendMode("alpha")
    love.graphics.clear(0, 0, 0, 0)
    gameDisplay()
    love.graphics.pop()
    love.graphics.setCanvas()
    
    love.graphics.setCanvas(gFull)
    love.graphics.push()
    love.graphics.setBlendMode("alpha")
    love.graphics.clear(0, 0, 0, 0)
    gameDisplay()
    love.graphics.pop()
    love.graphics.setCanvas()
    
    lovesize.begin()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setBlendMode("alpha", "premultiplied")
    if not love.window.getFullscreen() then
        love.graphics.draw(gWindow)
    else
        love.graphics.draw(gFull)
    end
    lovesize.finish()
end
