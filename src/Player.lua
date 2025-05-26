local Card = require("src.Card")

local Player = {}
Player.__index = Player

function Player.new(name, isAI)
    local self = setmetatable({}, Player)
    self.name = name
    self.isAI = isAI or false
    self.deck = {}
    self.hand = {}
    return self
end

function Player:loadDeck(cardDataList)
    for _, data in ipairs(cardDataList) do
        table.insert(self.deck, Card.new(data))
    end
end

function Player:drawCard()
    if #self.deck > 0 then
        local card = table.remove(self.deck, 1)
        table.insert(self.hand, card)
    end
end

function Player:drawHand()
    for i, card in ipairs(self.hand) do
        card:draw(100 + (i - 1) * 120, self.isAI and 50 or 400)
    end
end

return Player
