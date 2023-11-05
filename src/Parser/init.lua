--// Lexer
local Parser = {}
Parser.__index = Parser
ParserReference = Parser


--// Import
require("./tokenStream")


--// Constructor
function Parser.new(lexer)
    
    --// Enviroment
    local tokens: {LexerReference.LexerToken} = lexer:tokenize():read()
    local index = 1
    local self = setmetatable({}, Parser)

    --// Utils
    function self:source()
        return lexer:source()
    end

    function self:next()
        index += 1
    end

    function self:checkpoint(): () -> nil
        local checkpointIndex = index

        return function()
            index = checkpointIndex
        end
    end

    function self:exists(pos: number): boolean
        return tokens[index or pos] ~= nil
    end

    function self:pos(): number
        return index
    end

    function self:popChar(char: string?): LexerReference.Char?
        
        local token = tokens[index]

        if not token then return end
        if token.kind ~= "Char" then return end

        if (char and token.char == char) or not char then
            index += 1
            return token
        end
    end

    function self:popWord(word: string?): LexerReference.Word?

        local token = tokens[index]

        if not token then return end
        if token.kind ~= "Word" then return end

        if (word and token.word == word) or not word then
            index += 1
            return token
        end
    end

    function self:popDigit(): LexerReference.Digit?

        local token = tokens[index]

        if not token then return end
        if token.kind == "Digit" then
            index += 1
            return token
        end
    end

    function self:popString(): LexerReference.String?
        
        local token = tokens[index]

        if not token then return end
        if token.kind == "String" then
            index += 1
            return token
        end
    end

    function self:popBoolean(): LexerReference.Boolean?

        local token = tokens[index]

        if not token then return end
        if token.kind == "Word" and (token.word == "true" or token.word == "false") then
            index += 1
            return LexerReference:buildToken("Boolean", token.start, token.final, {
                value = token.word == "true",
            })
        end
    end

    function self:popNil(): LexerReference.Nil?
        
        local token = tokens[index]

        if not token then return end
        if token.kind == "Word" and token.word == "nil" then
            index += 1
            return LexerReference:buildToken("Nil", token.start, token.final, {})
        end
    end

    function self:popValue(): LexerReference.Digit? | LexerReference.String? | LexerReference.Boolean? | LexerReference.Nil? | LexerReference.Word?
        return self:popDigit() or self:popString() or self:popString() or self:popBoolean() or self:popNil() or self:popWord()
    end

    function self:popOperator(): LexerReference.Operator?
        
        local token = tokens[index]

        if not token then return end
        if token.kind == "Operator" then
            index += 1
            return token
        end
    end
    
    --// Result
    return self
end


--// Export
return Parser