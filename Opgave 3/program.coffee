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
        start_index = start_index + 1

        pizza = lines[start_index].split(' ').map((el)-> parseInt el)
        pizza = pizza.slice(1)

        max_result = 0
        for i in pizza
            first = pizza[i]
            l = (i - 1 + pizza.length) % pizza.length
            r = (i + 1 + pizza.length) % pizza.length

            result = eat(i,l,r,false) + first
            if result > max_result
                max_result = result

        console.log max_result


modulo = (v) ->
    (v + pizza.length) % pizza.length

eat = (i, l, r, alice_eat) ->
    if l is r
        if alice_eat
            return pizza[i]
        else
            return 0

    next_i = modulo(l)
    next_l = (l-1 + pizza.length) % pizza.length
    next_r = r
    next_alice_eat = not alice_eat

    left = eat(next_i, next_l, next_r, next_alice_eat)

    next_i = modulo(r)
    next_l = l
    next_r = (r+1 + pizza.length) % pizza.length
    next_alice_eat = not alice_eat
    right = eat(next_i, next_l, next_r, next_alice_eat)

    result = Math.max(left, right)

    if alice_eat
        return result + pizza[i]
    else
        return result
