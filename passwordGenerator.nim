import random; randomize()
import sequtils

const CHARS = "abcdefhijklmnopqrstuvwxyzABCDEFHIJKLMNOPQRSTUVWXYZ123456789&%$#@!+-=".toSeq

proc generatePassword(n: int): string =
    for i in 0..n:
        result &= random.sample(CHARS)

echo generatePassword(10)
