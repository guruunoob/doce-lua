--// Type
export type Token = {
    kind: "Expression",
    start: number,
    final: number,
}

export type Expression = Token & {
    decimal: number?,
    fractional: number?,
    exponential: number?,
}

--// Scans
function ParserReference:buildToken(kind: "Digit" | "Word" | "Char" | "String" | "Operator", start: number, final: number, extra: {}): Token
    local token = {
        kind = kind,
        start = start,
        final = final,
    }

    for index, value in extra do
        token[index] = value
    end

    return token
end
function ParserReference:scanToken(): Token
    return self:scanExpression()
end
function ParserReference:scanExpression(): Expression?

    local tokens = {}
    
    repeat
        local value = self:popValue()

        if not value then break end

        table.insert(tokens, value)

        local operator = self:popOperator()

        if not operator then break end

        table.insert(tokens, operator)
    until false

    if #tokens == 0 then return end

    if tokens[#tokens].kind == "Operator" then
        doceluaGlobals.throwError(self:source(), tokens[1].start, tokens[#tokens].final, "DoceLua Parser Error: Malformed expression!")
    end

    local token = self:buildToken("Expression", tokens[1].start, tokens[#tokens].final, {
        tokens = tokens,
    })

    return token
end


--// Factory
function ParserReference:tokenize()

    --// Enviroment
    local tokens = {}

    --// Tokenize
    while self:exists() do
        local token = self:scanToken()

        print("parser token:", token)

        table.insert(tokens, token)
    end

    --// Stream
    local self = setmetatable({}, {})

    function self:read()
        return tokens
    end

    --// Result
    return self
end


--// Export
return nil