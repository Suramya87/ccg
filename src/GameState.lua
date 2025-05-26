-- src/GameState.lua
local GameState = {}
local Game = require("src.Game")
local Card = require("src.Card") -- required to create Card objects

-- CSV loader that returns actual Card objects
local function loadCSV(filename)
    local cards = {}
    local file = love.filesystem.read(filename)
    if not file then return cards end

    for line in string.gmatch(file, "[^\r\n]+") do
        -- Handle quoted text correctly
        local fields = {}
        local quoted = false
        local field = ""

        for i = 1, #line do
            local c = line:sub(i, i)
            if c == '"' then
                quoted = not quoted
            elseif c == ',' and not quoted then
                table.insert(fields, field)
                field = ""
            else
                field = field .. c
            end
        end
        table.insert(fields, field) -- last field

        -- Construct Card object
        local data = {
            name = fields[1],
            cost = tonumber(fields[2]),
            power = tonumber(fields[3]),
            text = fields[4] or ""
        }
        table.insert(cards, Card.new(data))
    end

    return cards
end

function GameState:new()
    local self = setmetatable({}, { __index = GameState })
    return self
end

function GameState:load()
    local cards = loadCSV("assets/cards.csv")
    self.game = Game.new(cards)
end

function GameState:update(dt)
    self.game:update(dt)
end

function GameState:draw()
    self.game.board:draw()

    if self.game.player then
        self.game.player:drawHand()
    end

    if self.game.enemy then
        self.game.enemy:drawHand()
    end
end

function GameState:mousepressed(x, y, button)
-- self.game:mousepressed(x, y, button)
end

function GameState:mousereleased(x, y, button)
-- self.game:mousereleased(x, y, button)
end

return GameState
