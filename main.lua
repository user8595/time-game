require("lua.defaults")
require("lua.states")
require("lua.game")

function love.load()
    love.graphics.setBackgroundColor(0.03, 0.03, 0.03)
    -- game audio
    se = {
        miss = love.audio.newSource("/assets/se/miss.wav", "static"),
        hit_1 = love.audio.newSource("/assets/se/hit_1.wav", "static"),
        hit_2 = love.audio.newSource("/assets/se/hit_2.wav", "static"),
        sel_1 = love.audio.newSource("/assets/se/sel_1.wav", "static"),
        sel_2 = love.audio.newSource("/assets/se/sel_2.wav", "static"),
    }
end

function love.keypressed(key)
    gameKey(key)
end

function love.update(dt)
    gameLoop(dt)
end

function love.draw()
    gameDisplay()
end
