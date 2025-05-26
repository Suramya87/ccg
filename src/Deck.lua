local Deck = {}
Deck.__index = Deck

local Card = require("src.Card")

function Deck.new()
    local self = setmetatable({}, Deck)
    self.cards = {}
    -- Load cards from CSV or predefined list
    self:loadCards()
    self:shuffle()
    return self
end

function Deck:loadCards()
--    local csvData = [[
--Wooden Cow,9,1,Vanilla
--Pegasus,3,5,Vanilla
--Minotaur,5,9,Vanilla
--Titan,6,12,Vanilla
--Zeus,4,4,"When Revealed: Lower the power of each card in your opponent's hand by 1."
--Ares,3,2,"When Revealed: Gain +2 power for each enemy card here."
--Medusa,2,3,"When ANY other card is played here, lower that card's power by 1."
--Cyclops,3,1,"When Revealed: Discard your other cards here, gain +2 power for each discarded."
--Poseidon,4,5,"When Revealed: Move away an enemy card here with the lowest power."
--Artemis,2,2,"When Revealed: Gain +5 power if there is exactly one enemy card here."
--Hera,3,3,"When Revealed: Give cards in your hand +1 power."
--Demeter,2,3,"When Revealed: Both players draw a card."
--Hades,3,4,"When Revealed: Gain +2 power for each card in your discard pile."
--Hercules,20,50,"When Revealed: Doubles its power if it's the strongest card here."
--Dionysus,3,3,"When Revealed: Gain +2 power for each of your other cards here."
--Hermes,1,2,"When Revealed: Moves to another location."
--Hydra,2,3,"Add two copies to your hand when this card is discarded."
--Ship of Theseus,3,4,"When Revealed: Add a copy with +1 power to your hand."
--Sword of Damocles,4,8,"End of Turn: Loses 1 power if not winning this location."
--Midas,5,3,"When Revealed: Set ALL cards here to 3 power."
--Aphrodite,3,4,"When Revealed: Lower the power of each enemy card here by 1."
--Athena,2,2,"Gain +1 power when you play another card here."
--Apollo,0,1,"When Revealed: Gain +1 mana next turn."
--]]

--    for line in csvData:gmatch("[^\r\n]+") do
--        -- Parse line into name, cost, power, text
--        -- Handle the optional quotes around the text field
--        local name, cost, power, text = line:match('([^,]+),([^,]+),([^,]+),"?(.+)"?')
--        if name and cost and power then
--            -- Remove surrounding quotes if present
--            if text then
--                text = text:gsub('^%s*"?', ''):gsub('"?%s*$', '')
--            else
--                text = ""
--            end

--            local card = Card.new(name, cost, power, text)
--            table.insert(self.cards, card)
--        end
--    end
end


function Deck:shuffle()
    for i = #self.cards, 2, -1 do
        local j = math.random(i)
        self.cards[i], self.cards[j] = self.cards[j], self.cards[i]
    end
end

function Deck:drawTopCard()
    return table.remove(self.cards)
end

return Deck
