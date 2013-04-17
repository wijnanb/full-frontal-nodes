`
    // JAVASCRIPT INCLUDES HERE
`

# Read input
ll = require "lazylines"
process.stdin.resume()
input = new ll.LineReadStream process.stdin

# debug logging
debug = false
if debug then console.debug = (args...) -> console.log args.join ' '
else console.debug = (args...) ->


lines = []
result = "(empty)"
pizza = null

input.on "line", (line) ->
    line = line.replace /[\n\r]/,"" # strip newlines
    lines.push line

input.on "end", ->
    n_opgaves = parseInt lines[0]
    start_index = 0

    for o in [0..n_opgaves-1]
    #for o in [0..3]
        start_index = start_index + 1

        pizza = lines[start_index].split(' ').map((el)-> parseInt el)
        pizza = pizza.slice(1)

        max_result = 0
        max_result_b = 0
        diff = -1

        for i in [0..pizza.length-1]
            result_a = pizza[i]
            result_b = 0
            alternate = true
            l = (i - 1 + pizza.length) % pizza.length
            r = (i + 1 + pizza.length) % pizza.length

            for j in [0..pizza.length-2]
                max = 0

                if pizza[l] > pizza[r]
                    max = pizza[l]
                    l = modulo(l-1)
                else
                    max = pizza[r]
                    r = modulo(r+1)

                if alternate
                    result_b += max 
                else
                    result_a += max
                alternate = not alternate

            #result = eat(i,l,r,false, first, 0)
            #console.log result_a + "-" + result_b
            new_diff = Math.abs(result_a - result_b)
            #console.log "DIFF " + new_diff + " " + result_a + " " + result_b
            #console.log new_diff
            #if new_diff < diff or diff == -1
            if result_a > max_result
                max_result = result_a
                max_result_b = result_b
                diff = new_diff

        console.log max_result


modulo = (v) ->
    (v + pizza.length) % pizza.length

