import std/[random, sequtils, times]

randomize()

const CHARS = "abcdefhijklmnopqrstuvwxyzABCDEFHIJKLMNOPQRSTUVWXYZ123456789&%$#@!+-=".toSeq

proc generatePassword(n: int): string =
    for i in 0..n:
        result &= random.sample(CHARS)

when isMainModule:
    let start = getTime()

    for i in 0..999_999:
        # echo i, ". ", generatePassword(12)
        discard generatePassword(12)

    echo "1,000,000 passwords generated in ", (getTime() - start).inSeconds, "s"
