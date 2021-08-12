import algorithm
import sequtils

let alphabet = ('a'..'z').toSeq

proc sortKey(a: char, b: char): int =
    return cmp(a, b)

proc sortWord(s: string): string =
    var arr = cast[seq[char]](s)
    arr.sort(sortKey)

    for c in arr:
        result &= c

when isMainModule:
    echo sortWord("abc")
    echo sortWord("sussy")
    echo sortWord("alphabet")
    echo sortWord("frog")
