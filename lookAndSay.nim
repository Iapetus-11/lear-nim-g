import std/strutils

proc countCurrent(current: char, n: string): int =
    for c in n:
        if c == current:
            result += 1
        else:
            break

proc lookAndSay(n: string): string =
    var i = 0

    while i < n.len:
        let count = countCurrent(n[i], n[i..n.high])
        result &= $count & n[i]
        i += count


when isMainModule:
    stdout.write("How many iterations? ")
    let iterations = parseInt(readLine(stdin))

    var current = "1"

    for i in 0..iterations:
        echo current
        current = lookAndSay(current)
