import std/[strutils, times]
import bigints

proc fibonacci(n: int): BigInt =
    var
        i = initBigInt(1)
        j = initBigInt(0)

    for k in 1..n:
        let temp = i
        i = j
        j += temp

    return j

when isMainModule:
    stdout.write("Calculate which digit of the Fibonacci sequence? ")
    let n: int = parseInt(readLine(stdin))
    let start = getTime()
    let result = fibonacci(n)
    let duration = (getTime() - start)
    echo result, "\n", duration.inNanoseconds(), "ns", " or ", duration.inMilliseconds(), "ms"
