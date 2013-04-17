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
    n_dozen = 0
    n_bogen = 0

    for o in [0..n_opgaves-1]
        dozen = []
        iteraties = []
        start_index = start_index + 2 + n_dozen * n_bogen
        n_dozen = parseInt lines[start_index]
        n_bogen = parseInt lines[start_index+1]

        console.debug n_dozen, n_bogen, start_index

        for d in [0..n_dozen-1]
            offset = d*n_bogen

            bogen = lines.slice start_index+2+offset, start_index+2+offset+n_bogen

            doos =
                bogen: []
                start_stukken: {}
                max_lengtes: {}

            for boog in bogen
                koppel = boog.split " "
                doos.bogen.push [parseInt(koppel[0]), parseInt(koppel[1])]
                doos.bogen.push [parseInt(koppel[1]), parseInt(koppel[0])]
                doos.start_stukken[koppel[0]] = true
                doos.start_stukken[koppel[1]] = true
                doos.max_lengtes[koppel[0]] = 0
                doos.max_lengtes[koppel[1]] = 0


            dozen.push doos

        for d in [1..dozen.length]
            checkDoos(dozen, d)

        console.log dozen[0], dozen[1]

        return

        start_stukken = {}
        volgende_stukken = {}
        for boog in dozen[0].bogen
            start_stukken[boog[0]] = true
            volgende_stukken[boog[0]] = true
        console.debug start_stukken

        for d in [n_dozen-1..1]
            doos = dozen[d]
            for b in [0..n_bogen]
                eind_stuk = '' + doos.bogen[b][1]
                if not start_stukken[eind_stuk] and not volgende_stukken[eind_stuk]
                    console.debug "pruned ", d, b, eind_stuk
                    console.debug start_stukken, volgende_stukken
                    doos.bogen[b] = null
            volgende_stukken = {}
            for boog in doos.bogen
                if boog
                    volgende_stukken[boog[0]] = true
            console.debug volgende_stukken



        doos = dozen[0]

        max_boog_length = 0

        for boog in doos.bogen
            if not boog
                continue
            start_stuk = boog[0]
            boog_length = addBoog(dozen, 1, start_stuk, boog[1])

            unless boog_length > 1
                if boog[0] == boog[1]
                    boog_length = 1

            if boog_length > max_boog_length
                max_boog_length = boog_length

        console.log max_boog_length


checkDoos = (dozen, cur_doos_idx) ->
    doos = dozen[cur_doos_idx]
    next_doos = dozen[cur_doos_idx + 1]
    first_doos = dozen[0]
    for b in [0..doos.bogen.length]
        eind_stuk = doos.bogen[b][1]
        ml = 0
        if next_doos and next_doos.start_stukken[eind_stuk]
            ml = next_doos.max_lengtes[eind_stuk] + 1
        if first_doos.start_stukken[eind_stuk]
            ml = 1

        if doos.max_lengtes[doos.bogen[b][0]] < ml
            doos.max_lengtes[doos.bogen[b][0]] = ml



addBoog = (dozen, cur_doos_idx, start_stuk, huidig_stuk) ->
    max_boog_length = 0
    if cur_doos_idx >= dozen.length
        return 0
    cur_doos = dozen[cur_doos_idx]
    for boog in cur_doos.bogen
        if not boog
            continue
        if boog[0] == huidig_stuk
            boog_length = addBoog(dozen, cur_doos_idx+1, start_stuk, boog[1])
            unless boog_length > 1
                if boog[1] == start_stuk
                    boog_length = cur_doos_idx + 1

            if boog_length > max_boog_length
                max_boog_length = boog_length

     return max_boog_length

