local SlotRow = {}
SlotRow.__index = SlotRow

function SlotRow:new(x, y, cardWidth, cardHeight, slotCount)
    local self = setmetatable({}, SlotRow)
    self.x = x
    self.y = y
    self.cardWidth = cardWidth
    self.cardHeight = cardHeight
    self.slotCount = slotCount or 4
    self.cards = {}

    for i = 1, self.slotCount do
        self.cards[i] = nil
    end

    return self
end

function SlotRow:draw(highlightIndex)
    for i = 1, self.slotCount do
        local x = self.x + (i - 1) * (self.cardWidth + 20)
        local y = self.y

        -- Highlight slot if needed
        if highlightIndex == i then
            love.graphics.setColor(0.4, 0.4, 0.6)
            love.graphics.rectangle("fill", x, y, self.cardWidth, self.cardHeight)
        end

        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", x, y, self.cardWidth, self.cardHeight)

        local card = self.cards[i]
        if card then
            card.x = x
            card.y = y
            if card.draw then
                card:draw()
            end
        end
    end
end

function SlotRow:placeCard(card, slotIndex)
    if self.cards[slotIndex] == nil then
        self.cards[slotIndex] = card
        card.x = self.x + (slotIndex - 1) * (self.cardWidth + 20)
        card.y = self.y
        return true
    end
    return false
end

function SlotRow:clear()
    for i = 1, self.slotCount do
        self.cards[i] = nil
    end
end

function SlotRow:getCards()
    return self.cards
end

function SlotRow:getSlotAt(x, y)
    for i = 1, self.slotCount do
        local slotX = self.x + (i - 1) * (self.cardWidth + 20)
        local slotY = self.y
        local w = self.cardWidth
        local h = self.cardHeight

        if x >= slotX and x <= slotX + w and y >= slotY and y <= slotY + h then
            local hasCard = self.cards[i] ~= nil
            return {
                index = i,
                valid = not hasCard,
                hasCard = hasCard
            }
        end
    end
    return nil
end

return SlotRow
