--// Lexer
local Lexer = {}
Lexer.__index = Lexer
LexerReference = Lexer


--// Import
require("./tokenStream")


--// Constructor
function Lexer.new(source: string)
    
    --// Enviroment
    local chars = source:split("")
    local index = 1

    local self = setmetatable({}, Lexer)

    --// Utils
    function self:source(): string
        return source
    end
    function self:next(): boolean
        index += 1
    end
    function self:exists(): boolean
        return chars[index] ~= nil
    end
    function self:pos(): number
        return index
    end
    function self:size()
        return #chars
    end
    function self:pop(): string?
        index += 1
        return chars[index - 1]
    end
    function self:checkChar(objChar: string): boolean
        local char = chars[index]
        
        return char == objChar
    end
    function self:popChar(objChar: string): string?
        if not self:checkChar(objChar) then return end

        return self:pop()
    end
    function self:checkDigit(): boolean
        local char = chars[index]

        return tonumber(char) ~= nil
    end
    function self:popDigit(): string?
        if not self:checkDigit() then return end

        return self:pop()
    end
    function self:checkAlpha(): boolean
        local char = chars[index]

        return char:upper() ~= char:lower()
    end
    function self:checkSeq(objSeq: string): boolean
        if index + #objSeq > #chars then return false end

        local foundSeq = table.concat(chars, "", index, #objSeq + index - 1)
        
        return foundSeq == objSeq
    end
    function self:popSeq(objSeq: string)
        if not self:checkSeq(objSeq) then return else
            index += #objSeq

            return objSeq
        end
    end
    function self:checkOperator(): (boolean, number)
        local char = chars[index]
        local multiChar = chars[index]..(chars[index+1] or " ")

        local isMulti = multiChar == ".."
            or char == "=="
            or char == "~="
            or char == ">="
            or char == "<="
        
        if isMulti then return true, 2 else
            return char == "+"
                or char == "-"
                or char == "*"
                or char == "/"
                or char == "%"
                or char == "^"
                or char == ">"
                or char == "<", 1
        end
    end
    function self:popOperator()
        local isOperator, size = self:checkOperator(), 2

        if not isOperator then return end

        if size < 2 then
            return self:pop()
        else
            return self:pop() .. self:pop()
        end
    end
    function self:skipBlank()
        while self:exists()
            and (chars[index] == " "
            or chars[index] == "\n"
            or chars[index] == "\t"
            or chars[index] == "\v")
        do
            index += 1
        end
    end
    
    --// Result
    return self
end


--// Export
return Lexer