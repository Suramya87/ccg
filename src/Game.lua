-- src/Game.lua
local Game = {}
Game.__index = Game

local Player = require("src.Player")
local Board = require("src.Board")

function Game.new(cards)
    local self = setmetatable({}, Game)
    self.turn = 1
    self.phase = "play"
    self.maxPoints = 15

    -- Initialize players and board
    self.player = Player.new("Player")
    self.enemy = Player.new("AI", true)
    self.board = Board.new()

    -- Load decks from card data (table of card info)
    self.player:loadDeck(cards)
    self.enemy:loadDeck(cards)

    -- Deal initial hands
    self:dealInitialHands()

    return self
end

function Game:dealInitialHands()
    for i = 1, 3 do
        self.player:drawCard()
        self.enemy:drawCard()
    end
end

function Game:update(dt)
    -- Put turn progression and game rules here
    -- e.g. advance phases, check win condition
end

function Game:playCard(player, card, location)
    -- Handle a player playing a card to a board location
    -- e.g. deduct mana, place card, trigger effects
end

function Game:isGameOver()
    -- Return true if someone reached max points or other end conditions
end

return Game
