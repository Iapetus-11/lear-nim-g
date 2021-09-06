import std/sets

proc isAnagram(a: string, b: string): bool =
    return a.len == b.len and difference(a.toHashSet, b.toHashSet).len == 0

when isMainModule:
    echo isAnagram("one", "noe")
    echo isAnagram("min", "nim")
    echo isAnagram("anagram", "margana")
    echo isAnagram("a gentleman", "elegant man")
    echo isAnagram("aa", "aaa")
    echo isAnagram("a", "b")
    echo isAnagram("bruh", "broooo")
