import std/[strformat, strutils, times, sets, os]

# Uses a seq (aka mutable list) and a HashSet, It's slightly
# faster than recamanTable.nim but uses more memory I think
proc recaman(n: int): seq[int] =
    var already = [0].toHashset

    for i in 0..n-1:
        result.add(0)

    for i in 1..n-1:
        var c = result[i - 1] - i

        if c < 0 or (c in already):
            c = result[i - 1] + i
        
        result[i] = c
        already.incl(c)

when isMainModule:
    var n: int

    try:
        n = parseInt(paramStr(1))
    except IndexDefect:
        stdout.write("How many iterations? ")
        n = parseInt(readLine(stdin))
        
    let startTime = getTime()
    let result = recaman(n)
    let duration = inMilliSeconds(getTime() - startTime).toBiggestFloat / 1000

    echo result[result.high], &" ({duration:.2f} seconds)"
