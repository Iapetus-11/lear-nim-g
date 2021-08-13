proc formatNumber(number: int64): string =
    let numberString = $number
    var reverseNumber = ""

    for i in 0..numberString.high:
        if i mod 3 == 0:
            reverseNumber &= ","

        reverseNumber &= numberString[numberString.len-i-1]

    for i in 0..reverseNumber.high:
        result &= reverseNumber[reverseNumber.len-i-1]

    result = result[0..result.high-1]

when isMainModule:
    echo formatNumber(1233)
    echo formatNumber(123)
    echo formatNumber(999999)
    echo formatNumber(9999999999)
