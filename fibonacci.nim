import strutils

stdout.write("How many numbers of the Fibonacci sequence to calculate? ")
let n: int = strutils.parseInt(readLine(stdin))

proc calculateFibonacci(x: int): int =
    if x == 0:
        return 0

    if x == 1 or x == 2:
        return 1

    return calculateFibonacci(x-1) + calculateFibonacci(x-2)

for i in 0..n:
    echo calculateFibonacci(i)
