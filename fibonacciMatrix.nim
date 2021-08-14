import strformat
import strutils
import bigints
import times
import os

# ported from code by u/ggrogg (credit to them)

type Matrix22 = tuple[a: BigInt, b: BigInt, c: BigInt, d: BigInt]

proc `*`(x: Matrix22, y: Matrix22): Matrix22 =
    let a = x.a * x.b + x.b * y.c
    let b = x.a * y.b + x.b * y.d
    let c = x.c * y.a + x.d * y.c
    let d = x.c * y.b + x.d * y.d

    return (a, b, c, d)

proc pow(mat: Matrix22, n: int): Matrix22 =
    if n == 0:
        return (1.initBigInt, 0.initBigInt, 0.initBigInt, 1.initBigInt)

    if n == 1:
        return mat

    if n mod 2 == 0:
        return pow(mat * mat, (n/2).toInt)

    return mat * pow(mat, n-1)

proc fibonacci(n: int): BigInt =
    let initial = (0.initBigInt, 1.initBigInt, 1.initBigInt, 1.initBigInt)
    return pow(initial, n).b

when isMainModule:
    var n: int

    try:
        n = parseInt(paramStr(1))
    except IndexDefect:
        stdout.write("What digit of the Fibonacci sequence to calculate? ")
        n = parseInt(readLine(stdin))
        
    let startTime = getTime()
    let result = fibonacci(n)
    let duration = inMilliSeconds(getTime() - startTime).toBiggestFloat / 1000

    echo result
    echo &"Finished in {duration:.2f} seconds."
