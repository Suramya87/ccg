local GameState = require("src.GameState")

function love.load()
    GameState:load()
end

function love.update(dt)
    GameState:update(dt)
end

function love.draw()
    GameState:draw()
end

function love.mousepressed(x, y, button)
    GameState:mousePressed(x, y, button)
end

function love.mousemoved(x, y, dx, dy)
    GameState:mouseMoved(x, y)
end

function love.mousereleased(x, y, button)
    GameState:mouseReleased(x, y, button)
end