import strutils
import bigints

proc fibonacci(n: int) = 
    var
        i = initBigInt(1)
        j = initBigInt(0)
        count = 0

    for k in 1..n:
        let temp = i
        i = j
        j += temp
        
        count += 1
        
        echo "[", count, "]: ", j

when isMainModule:
    stdout.write("How many numbers of the Fibonacci sequence to calculate? ")
    let n: int = strutils.parseInt(readLine(stdin))
    fibonacci(n)
