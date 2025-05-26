local Board = {}
Board.__index = Board

function Board.new()
    local self = setmetatable({}, Board)
    self.locations = {} -- Setup later
    return self
end

function Board:draw()
    love.graphics.print("Board Area", 900, 700)
end

return Board
