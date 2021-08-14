import strutils
import bigints
import os

# ported from code by u/ggrogg

type Matrix22 = tuple[a: BigInt, b: BigInt, c: BigInt, d: BigInt]

proc `*`(x: Matrix22, y: Matrix22): Matrix22 =
    let a = x.a * x.b + x.b * y.c
    let b = x.a * y.b + x.b * y.d
    let c = x.c * y.a + x.d * y.c
    let d = x.c * y.b + x.d * y.d

    return (a, b, c, d)

proc pow(mat: Matrix22, n: BigInt): Matrix22 =
    if n == 0:
        return (1.initBigInt, 0.initBigInt, 0.initBigInt, 1.initBigInt)

    if n == 1:
        return mat

    if n mod 2 == 0:
        return mat * mat

    return mat * pow(mat, n-1)

proc fibonacci(n: BigInt): BigInt =
    let initial = (0.initBigInt, 1.initBigInt, 1.initBigInt, 1.initBigInt)
    return pow(initial, n).b

when isMainModule:
    echo fibonacci(paramStr(1).parseInt.initBigInt)
