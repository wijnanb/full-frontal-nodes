`
    // JAVASCRIPT INCLUDES HERE
`

# Read input
ll = require "lazylines"
process.stdin.resume()
input = new ll.LineReadStream process.stdin

# debug logging
debug = true
if debug then console.debug = (args...) -> console.log args.join ' '
else console.debug = (args...) ->


lines = []
result = "(empty)"

input.on "line", (line) ->
    line = line.replace /[\n\r]/,"" # strip newlines

    lines.push line

input.on "end", ->
    console.debug "input", lines.join(',')

    console.log result