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

input.on "line", (line) ->
    line = line.replace /[\n\r]/,"" # strip newlines
    lines.push line

input.on "end", ->
    n_opgaves = parseInt lines[0]
    start_index = -1
    n_knopen = 0
    n_bogen = 0

    for o in [0..n_opgaves-1]
        knopen = []
        iteraties = []
        start_index = start_index + 1 + n_knopen + 1 + n_bogen
        n_knopen = parseInt lines[start_index]

        keien = lines.slice start_index+1, start_index+1+n_knopen
        bogen_index = start_index+1+n_knopen
        n_bogen = parseInt lines[bogen_index]
        bogen = lines.slice bogen_index+1, bogen_index+1+n_bogen

        console.debug "keien", keien
        console.debug "bogen", bogen

        for n_kei in keien
            knoop =
                keien: parseInt n_kei
                buren: []
            knopen.push knoop

        for boog in bogen
            boog = boog.split ' '
            console.debug boog
            knopen[parseInt boog[0]-1].buren.push parseInt boog[1]-1
            knopen[parseInt boog[1]-1].buren.push parseInt boog[0]-1

        #console.log knopen
        iteraties.push printKeien knopen

        for i in [0..1000000]
            knopen = nextStep knopen
            current = printKeien knopen

            foundIndex = iteraties.indexOf(current)
            console.debug foundIndex
            if foundIndex > -1
                result = i - foundIndex+1
                console.debug "found", foundIndex
                console.log result
                break
            else
                iteraties.push current
                console.debug iteraties

nextStep = (knopen) ->
    for knoop in knopen
        knoop.te_geef = Math.floor knoop.keien / knoop.buren.length

    for knoop in knopen
        for buur in knoop.buren
            knopen[buur].keien += knoop.te_geef
            knoop.keien -= knoop.te_geef

    return knopen

printKeien = (knopen) ->
    buff = []
    for knoop in knopen
        buff.push knoop.keien

    return buff.join ','


