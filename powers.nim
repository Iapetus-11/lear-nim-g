from strutils import parseFloat
import math

var number: float64 = parseFloat(readLine(stdin))

for i in countup(1, 10):
  echo math.pow(number, float64(i))
