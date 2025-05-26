local Deck = {}
Deck.__index = Deck

local Card = require("src.Card")

function Deck.new(cards) -- Pass in the card list from CSV
    local self = setmetatable({}, Deck)
    self.cards = {}

    -- Load cards into the deck
    for _, cardData in ipairs(cards) do
        table.insert(self.cards, Card.new(cardData))
    end

    self:shuffle()
    return self
end

function Deck:shuffle()
    for i = #self.cards, 2, -1 do
        local j = math.random(i)
        self.cards[i], self.cards[j] = self.cards[j], self.cards[i]
    end
end

function Deck:drawTopCard()
    if #self.cards > 0 then
        return table.remove(self.cards, 1) -- Remove and return top card
    else
        return nil -- Deck is empty
    end
end

return Deck