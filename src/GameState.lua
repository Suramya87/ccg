local GameState = {}
local Game = require("src.Game")
local Card = require("src.Card")
local Board = require("src.Board")

local MAX_HAND_SIZE = 5

local function loadCSV(filename)
    local cards = {}
    local file = love.filesystem.read(filename)
    if not file then return cards end

    local firstLine = true
    for line in string.gmatch(file, "[^\r\n]+") do
        if firstLine then
            firstLine = false -- Skip header
        else
            local fields = {}
            for value in string.gmatch(line, '([^,]+)') do
                table.insert(fields, value)
            end

            local data = {
                name = fields[1] or "Unknown",
                cost = tonumber(fields[2]) or 1,
                power = tonumber(fields[3]) or 1,
                text = fields[4] or "No effect"
            }

            table.insert(cards, Card.new(data))
        end
    end

    return cards
end

function GameState:load()
    self.allCards = loadCSV("assets/cards.csv")
    self:shuffleCards(self.allCards)

    self.game = Game.new(self.allCards)
    self.board = Board.new()
    self.discardPile = {}

    self.draggingCard = nil
    self.dragOffsetX = 0
    self.dragOffsetY = 0

    -- Draw initial hands
    self.game.player.hand = self:drawCards(3)
    self:updateHandPositions(self.game.player.hand, self.game.player.isAI)

    self.game.enemy.hand = self:drawCards(3)
    self:updateHandPositions(self.game.enemy.hand, self.game.enemy.isAI)
end

function GameState:shuffleCards(cardTable)
    for i = #cardTable, 2, -1 do
        local j = math.random(i)
        cardTable[i], cardTable[j] = cardTable[j], cardTable[i]
    end
end

function GameState:drawCards(count)
    local drawnCards = {}
    for i = 1, count do
        if #self.allCards > 0 then
            table.insert(drawnCards, table.remove(self.allCards, 1))
        end
    end
    return drawnCards
end

function GameState:updateHandPositions(hand, isAI)
    local startX = 100
    local y = isAI and 50 or 400
    local spacing = 120

    for i, card in ipairs(hand) do
        card.x = startX + (i - 1) * spacing
        card.y = y
    end
end

function GameState:update(dt)
    self.game:update(dt)
end

function GameState:draw()
    self.board:draw()
    self.game.player:drawHand()
    self.game.enemy:drawHand()

    if self.draggingCard then
        self.draggingCard:draw()
    end

    love.graphics.rectangle("line", 50, 300, 60, 90)
    love.graphics.print("Deck (" .. #self.allCards .. ")", 55, 320)

    love.graphics.rectangle("line", 50, 400, 60, 90)
    love.graphics.print("Discard (" .. #self.discardPile .. ")", 55, 420)
end

function GameState:mousePressed(x, y, button)
    if button == 1 then
        -- Click on deck to draw card only if hand not full
        if x >= 50 and x <= 110 and y >= 300 and y <= 390 then
            if #self.game.player.hand < MAX_HAND_SIZE then
                local drawn = self:drawCards(1)
                for _, card in ipairs(drawn) do
                    table.insert(self.game.player.hand, card)
                end
                self:updateHandPositions(self.game.player.hand, self.game.player.isAI)
            end
            return
        end

        -- Check if clicking on player's card to drag
        for i = #self.game.player.hand, 1, -1 do
            local card = self.game.player.hand[i]
            if card:contains(x, y) then
                self.draggingCard = card
                self.dragOffsetX = x - card.x
                self.dragOffsetY = y - card.y
                return
            end
        end
    end
end

function GameState:mouseMoved(x, y)
    if self.draggingCard then
        self.draggingCard.x = x - self.dragOffsetX
        self.draggingCard.y = y - self.dragOffsetY
    end
end

function GameState:mouseReleased(x, y, button)
    if self.draggingCard then
        local targetSlot = self.board:getHoveredSlot(x, y)
        local placed = false

        if targetSlot then
            local loc = self.board.locations[targetSlot.location]
            local slotIndex = targetSlot.slotIndex

            if not loc.playerSlots[slotIndex] and self.game.player.mana >= self.draggingCard.cost then
                loc.playerSlots[slotIndex] = self.draggingCard
                self.game.player.mana = self.game.player.mana - self.draggingCard.cost
                placed = true
            end
        end

        -- Remove card from hand regardless of outcome
        for i, c in ipairs(self.game.player.hand) do
            if c == self.draggingCard then
                table.remove(self.game.player.hand, i)
                break
            end
        end

        if not placed then
            table.insert(self.discardPile, self.draggingCard)
        end

        self:updateHandPositions(self.game.player.hand, self.game.player.isAI)
        self.draggingCard = nil
    end
end

function GameState:resolveCombat()
    for _, loc in ipairs(self.board.locations) do
        local playerTotal = 0
        local enemyTotal = 0

        for _, card in ipairs(loc.playerSlots) do
            if card then playerTotal = playerTotal + card.power end
        end
        for _, card in ipairs(loc.enemySlots) do
            if card then enemyTotal = enemyTotal + card.power end
        end

        local pointDiff = math.abs(playerTotal - enemyTotal)
        if playerTotal > enemyTotal then
            self.game.player.score = self.game.player.score + pointDiff
        elseif enemyTotal > playerTotal then
            self.game.enemy.score = self.game.enemy.score + pointDiff
        else
            if math.random(0, 1) == 1 then
                self.game.player.score = self.game.player.score + 1
            else
                self.game.enemy.score = self.game.enemy.score + 1
            end
        end
    end
end

function GameState:endTurn()
    self:resolveCombat()
    self.game.turn = self.game.turn + 1
    self.game.player.mana = self.game.turn
    self.game.enemy.mana = self.game.turn
    self.game:enemyTurn()

    if self.game.player.score >= 20 then
        print("Player Wins!")
        love.event.quit()
    end
    if self.game.enemy.score >= 20 then
        print("Enemy Wins!")
        love.event.quit()
    end
end

return GameState
