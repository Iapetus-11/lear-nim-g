import std/strutils


proc distance(n: int): int =
    var numstr: string

    for i in countup(1, n-1):
        numstr &= $i

    return len(numstr)


stdout.write("> ")
var num: int = strutils.parseInt(readLine(stdin))
echo distance(num)
