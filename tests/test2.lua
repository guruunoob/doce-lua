local stdio = require("@lune/stdio")
 
-- Prompting the user for basic input
local text: string = stdio.prompt("text", "Please write some text")
local confirmed: boolean = stdio.prompt("confirm", "Please confirm this action")
 
-- Writing directly to stdout or stderr, without the auto-formatting of print/warn/error
stdio.write("Hello, ")
stdio.write("World! ")
stdio.write("All on the same line")
stdio.ewrite("\nAnd some error text, too")