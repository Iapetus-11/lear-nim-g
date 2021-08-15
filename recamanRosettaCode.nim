import sequtils, sets, strutils
import times
import strformat
import os

# modified from the Nim example on https://rosettacode.org/wiki/Recaman%27s_sequence
# this is slower than recaman.nim, but slightly faster than recamanTable.nim
 
iterator recaman(num: Positive = Natural.high): tuple[n, a: int; duplicate: bool] =
  var a = 0
  yield (0, a, false)
  var known = [0].toHashSet
  for n in 1..<num:
    var next = a - n
    if next <= 0 or next in known:
      next = a + n
    a = next
    yield (n, a, a in known)
    known.incl a

var n: int

try:
    n = parseInt(paramStr(1))
except IndexDefect:
    stdout.write("How many iterations? ")
    n = parseInt(readLine(stdin))

let startTime = getTime()
let result = toSeq(recaman(n)).mapIt(it.a)
let duration = inMilliSeconds(getTime() - startTime).toBiggestFloat / 1000
echo result[result.high], &" ({duration:.2f} seconds)"
