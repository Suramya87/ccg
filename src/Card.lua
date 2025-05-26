local Card = {}
Card.__index = Card

function Card.new(data)
    local self = setmetatable({}, Card)
    self.name = data.name
    self.cost = data.cost
    self.power = data.power
    self.text = data.text
    self.width = 60
    self.height = 90
    self.x = 0
    self.y = 0
    return self
end

function Card:contains(x, y)
    return x >= self.x and x <= self.x + self.width and
           y >= self.y and y <= self.y + self.height
end

function Card:draw(x, y)
    local drawX = x or self.x
    local drawY = y or self.y

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", drawX, drawY, self.width, self.height)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", drawX, drawY, self.width, self.height)
    love.graphics.print(self.name, drawX + 4, drawY + 4)
    love.graphics.print("Cost: " .. self.cost, drawX + 4, drawY + 20)
    love.graphics.print("Pwr: " .. self.power, drawX + 4, drawY + 35)
    love.graphics.setColor(1, 1, 1)
end

return Card
