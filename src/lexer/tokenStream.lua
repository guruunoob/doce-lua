--// Type
export type Token = {
    kind: "Digit" | "Word" | "Char" | "String" | "Operator",
    start: number,
    final: number,
}

export type Digit = Token & {
    decimal: number?,
    fractional: number?,
    exponential: number?,
}

export type Word = Token & {
    word: string,
}

export type Char = Token & {
    char: string,
}

export type String = Token & {
    text: string
}

export type Operator = Token & {
    operator: string,
}

export type Boolean = Token & {
    value: boolean
}


--// Scans
function LexerReference:buildToken(kind: "Digit" | "Word" | "Char" | "String" | "Operator", start: number, final: number, extra: {}): Token
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
function LexerReference:scanToken(): Token
    return self:scanOperator() or self:scanDigit() or self:scanWord() or self:scanString() or self:scanChar()
end

function LexerReference:scanDigit(): Digit?

    if not self:exists() or not (self:checkDigit() or self:checkChar(".")) then return end

    local decimal = ""
    local fractional = ""
    local exponential = ""

    local checkpoint = self:pos()

    local digit = self:popDigit()
    while self:exists() and digit do
        decimal ..= digit
        digit = self:popDigit()
    end

    if self:popChar(".") then
        digit = self:popDigit()

        while self:exists() and digit do
            fractional ..= digit
            digit = self:popDigit()
        end
    end

    if self:popChar("e") then
        digit = self:popDigit()

        while self:exists() and digit do
            exponential ..= digit
            digit = self:popDigit()
        end
    end

    local token = self:buildToken("Digit", checkpoint, self:pos() - 1, {
        decimal = tonumber(decimal),
        fractional = tonumber(fractional),
        exponential = tonumber(exponential),
    })

    return token
end

function LexerReference:scanWord(): Word?

    if not self:exists() or not (self:checkAlpha() or self:checkChar("_")) then return end

    local checkpoint = self:pos()

    local ident = ""
    while self:exists() and (self:checkAlpha() or self:checkDigit() or self:checkChar("_")) do
        ident ..= self:pop()
    end

    local token = self:buildToken("Word", checkpoint, self:pos() - 1, {
        ident = ident,
    })

    return token
end

function LexerReference:scanChar(): Char?

    if not self:exists() then return end

    local checkpoint = self:pos()
    local char = self:pop()

    local token = self:buildToken("Char", checkpoint, self:pos() - 1, {
        char = char,
    })

    return token
end

function LexerReference:scanString(): String?

    local init = self:popChar("\"") or self:popChar("\'")

    if not init then return end

    local text = ""
    local checkpoint = self:pos()

    while self:exists() and not self:checkChar(init) do
        text ..= self:pop()
    end

    self:pop()

    local token = self:buildToken("String", checkpoint, self:pos() - 1, {
        text = text,
    })

    return token
end

function LexerReference:scanOperator(): Operator?

    local isOperator, size = self:checkOperator()

    if not isOperator then return end

    local operator = ""
    local checkpoint = self:pos()

    if size < 2 then
        operator = self:pop()
    else
        operator = self:pop() .. self:pop()
    end

    local token = self:buildToken("Operator", checkpoint, self:pos() - 1, {
        operator = operator,
    })

    return token
end

function LexerReference:scanComment(): nil?
    local init = self:popSeq("--*") or self:popSeq("--[[") or self:popSeq("--")
    
    if not init then return end

    repeat
        self:pop()
    until not self:exists() or ((init == "--" and self:popChar("\n"))
        or (init == "--[[" and self:popSeq("]]"))
        or (init == "--*" and self:popSeq("*--")))
    
    print("scanned comment")
end


--// Factory
function LexerReference:tokenize()

    --// Enviroment
    local tokens = {}
    local index = 1

    --// Tokenize
    while self:exists() do
        self:skipBlank()
        self:scanComment()
        self:skipBlank()

        if not self:exists() then
            break
        end

        local token = self:scanToken()

        print("lexer token:", token)

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