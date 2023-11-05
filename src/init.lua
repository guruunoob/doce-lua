local stdio = require("@lune/stdio")
local process = require("@lune/process")



--// Import
local Lexer = require("./lexer")
local Parser = require("./Parser")


doceluaGlobals = {}
function doceluaGlobals.throwError(source: string, start: number, final: number, text: string)

    stdio.write("\n[")
    stdio.write(stdio.color("red"))
    stdio.write("ERROR")
    stdio.write(stdio.color("reset"))
    stdio.write("]\n")

    stdio.write(text.."\n")

    stdio.write("'")
    stdio.write(stdio.color("yellow"))
    stdio.write(source:sub(start, final))
    stdio.write(stdio.color("reset"))
    stdio.write("' <-- the error begin here :(\n")
    
    process.exit()
end


--// Export
return {
    Lexer = Lexer,
    Parser = Parser,
}