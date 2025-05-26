local Card = {}
Card.__index = Card

function Card.new(data)
    local self = setmetatable({}, Card)
    self.name = data.name or "Unnamed"
    self.cost = tonumber(data.cost) or 0
    self.power = tonumber(data.power) or 0
    self.text = data.text or ""
    -- Load card image or set default here if needed
    return self
end

function Card:draw(x, y)
    -- Draw the card visually; for now, just print its name
    love.graphics.rectangle("line", x, y, 100, 150)
    love.graphics.print(self.name, x + 10, y + 10)
    love.graphics.print("Cost: " .. self.cost, x + 10, y + 30)
    love.graphics.print("Power: " .. self.power, x + 10, y + 50)
end

return Card
