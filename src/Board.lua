local Board = {}
Board.__index = Board

function Board.new()
    local self = setmetatable({}, Board)
    self.cardWidth = 60
    self.cardHeight = 90

    self.locations = {}
    for i = 1, 3 do
        self.locations[i] = {
            playerSlots = { nil, nil, nil, nil },
            enemySlots = { nil, nil, nil, nil }
        }
    end

    return self
end

function Board:draw()
    for locIndex, loc in ipairs(self.locations) do
        local baseX = 200 + (locIndex - 1) * 300
        local yOffsetPlayer = 400
        local yOffsetEnemy = 100

        for i = 1, 4 do
            love.graphics.rectangle("line", baseX + (i - 1) * 70, yOffsetPlayer, self.cardWidth, self.cardHeight)
            love.graphics.rectangle("line", baseX + (i - 1) * 70, yOffsetEnemy, self.cardWidth, self.cardHeight)
        end
    end
end

function Board:getHoveredSlot(x, y)
    for locIndex, loc in ipairs(self.locations) do
        local baseX = 200 + (locIndex - 1) * 300
        local yOffsetPlayer = 400

        for i = 1, 4 do
            local slotX = baseX + (i - 1) * 70
            if x >= slotX and x <= slotX + self.cardWidth and y >= yOffsetPlayer and y <= yOffsetPlayer + self.cardHeight then
                if not loc.playerSlots[i] then
                    return { location = locIndex, slotIndex = i }
                end
            end
        end
    end
    return nil
end

return Board