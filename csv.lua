local csv = {}

function csv.parse(path)
    local data = {}
    local file = love.filesystem.read(path)
    local lines = {}

    for line in file:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end

    local headers = {}
    for header in lines[1]:gmatch("[^,]+") do
        table.insert(headers, header)
    end

    for i = 2, #lines do
        local values = {}
        for value in lines[i]:gmatch("[^,]+") do
            table.insert(values, value)
        end

        local row = {}
        for j = 1, #headers do
            row[headers[j]] = values[j]
        end
        table.insert(data, row)
    end

    return data
end

return csv
