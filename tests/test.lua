local docelua = require("../src")

local lexer = docelua.Lexer.new([[
    --*
    local identifier = 12.25e10
    -- Hellou This IS aga comment
    print("hello world!"..*--"index")
]])

local tokens = lexer:tokenize()