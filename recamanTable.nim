import std/[strformat, strutils, tables, times, os]

# Slightly slower than recaman.nim (around 1.15x I think), but uses much less memory
proc recamanTable(n: int): Table[int, int] =
    for i in 0..n-1:
        result[i] = 0

    for i in 1..n-1:
        var c = result[i - 1] - i

        if c < 0 or (n in result):
            c = result[i - 1] + i

        result[i] = c

when isMainModule:
    var n: int

    try:
        n = parseInt(paramStr(1))
    except IndexDefect:
        stdout.write("How many iterations? ")
        n = parseInt(readLine(stdin))
        
    let startTime = getTime()
    let result = recamanTable(n)
    let duration = inMilliSeconds(getTime() - startTime).toBiggestFloat / 1000

    echo result[result.len-1], &" ({duration:.2f} seconds)"
