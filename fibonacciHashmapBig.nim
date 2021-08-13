import strutils
import bigints
import tables
import hashes
import math

stdout.write("How many numbers of the Fibonacci sequence to calculate? ")
let n: int = strutils.parseInt(readLine(stdin))

var fibonacciCache: Table[BigInt, BigInt] = initTable[BigInt, BigInt]()

proc calculateFibonacci(x: BigInt): BigInt =
    if fibonacciCache.hasKey(x):
        return fibonacciCache[x]

    if x == 0:
        return initBigInt(0)

    if x == 1 or x == 2:
        return initBigInt(1)

    result = calculateFibonacci(x-1) + calculateFibonacci(x-2)
    fibonacciCache[x] = result

for i in 0..n:
    echo "[", i, "]: ", calculateFibonacci(initBigInt(i))
