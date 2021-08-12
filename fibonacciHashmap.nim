import strutils
import tables

stdout.write("How many numbers of the Fibonacci sequence to calculate? ")
let n: int = strutils.parseInt(readLine(stdin))

var fibonacciCache: Table[int, int] = initTable[int, int]()

proc calculateFibonacci(x: int): int =
    if fibonacciCache.hasKey(x):
        return fibonacciCache[x]

    if x == 0:
        return 0

    if x == 1 or x == 2:
        return 1

    result = calculateFibonacci(x-1) + calculateFibonacci(x-2)
    fibonacciCache[x] = result

for i in 0..n:
    echo calculateFibonacci(i)
