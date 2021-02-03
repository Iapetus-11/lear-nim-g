import strutils

stdout.write("> ")
var num: int = strutils.parseInt(readLine(stdin))
var numstr: string

for i in countup(1, num-1):
  numstr &= $i

echo len(numstr)
