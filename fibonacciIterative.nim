import bigints

proc calculateFibonacci(n: int) = 
    var
        i = initBigInt(1)
        j = initBigInt(0)

    for k in 1..n+1:
        let temp = i
        i = j
        j += temp
        
        echo j

calculateFibonacci(100000)
