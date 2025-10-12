require("lua.defaults")
require("lua.states")
require("lua.game")

function love.keypressed(key)
    gameKey(key)
end

function love.update(dt)
    gameLoop(dt)
end

function love.draw()
    gameDisplay()
end
