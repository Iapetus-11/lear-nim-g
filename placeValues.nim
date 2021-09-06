import std/[algorithm, strutils, math]

stdout.write("> ")
let inp: string = readLine(stdin)
var places: seq[float]

for i in countdown(len(inp)-1, 0):
  places.add(float64(strutils.parseInt($inp[i])) * math.pow(10, float64(len(inp)-i-1)))

algorithm.reverse(places)

echo places
