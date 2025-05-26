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
    GameState:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    GameState:mousereleased(x, y, button)
end
