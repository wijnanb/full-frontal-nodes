ll = require "lazylines"
#_ = require("underscore")._
process.stdin.resume()
input = new ll.LineReadStream process.stdin

data = []
buffer = null
count = 0
init = false
num_lists = null

input.on "line", (line) ->
    unless init
        init = true
        num_lists = parseInt line
        return

    number = parseInt line

    if count is 0
        data.push buffer if buffer?

        count = number
        buffer = []
    else
        buffer.push number
        count--

input.on "end", ->
    data.push buffer if buffer?
    #console.log "data", data

    output = []
    #_.each data, (list) ->
    #    output += _.min(list) + " " + _.max(list) + "\n"
    data.forEach (list) ->
        min = max = list[0]
        list.forEach (number) ->
            min = number if number < min
            max = number if number > max
        output.push min + " " + max

    console.log output.join('\n')