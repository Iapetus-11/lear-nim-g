import std/strutils

let a: string = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

stdout.write("> ")

var s: string = readLine(stdin)
var result: string

for item in s:
    if strutils.isLowerAscii(item):
        result = result & a[len(a) - strutils.find(a, strutils.toUpperAscii(item)) - 1]
    else:
        result = result & a[len(a) - strutils.find(a, strutils.toLowerAscii(item)) - 1]

echo result
