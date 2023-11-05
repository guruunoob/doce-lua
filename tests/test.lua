local docelua = require("../src")

local lexer = docelua.Lexer.new([[
    12 + 5 *
]])

local parser = docelua.Parser.new(lexer)
parser:tokenize()

--[[
local lexer = docelua.Lexer.new(
    --*
    local identifier = 12.25e10
    -- Hellou This IS aga comment
    print("hello world!"..*--"index")
)

local tokens = lexer:tokenize()
]]

--[[
local expression = {
    {value = 3},
    {operator = "+"},
    {value = 5},
    {operator = "*"},
    {value = 10},
}

function expression:contains(operators: {string}): {number?}
    local found = {}

    for i, value in ipairs(self) do
        if not value.operator then continue end

        if table.find(operators, value.operator) then
            table.insert(found, i)
        end
    end

    return found
end


print({["nivel 1:"] = expression:contains({"^", "%"})})
print({["nivel 1:"] = expression:contains({"*", "/"})})
print({["nivel 1:"] = expression:contains({"+", "-"})})
]]