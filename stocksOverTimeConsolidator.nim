# compile with gc:arc or else this won't work!

import std/[os, json, sequtils, strformat, threadpool]

setMaxPoolSize(7)

var
    allStockData = %*{}
    i = 0
    files = toSeq(walkDir("dump", relative = true))
    filesLen = files.len
    responses = newSeq[FlowVar[tuple[f: string, j: JsonNode]]]()

proc loadStockData(filePath: string): tuple[f: string, j: JsonNode] =
    return (filePath[0..filePath.high-13], parseFile(&"dump/{filePath}"))

echo "Loading individual files..."

for file in files:
    stdout.write(&"{i+1}/{filesLen}\r")

    responses.add(spawn loadStockData(file.path))

    # keeps memory not crazyy
    if i mod 100 == 1:
        echo "\nCollecting responses..."

        for response in responses:
            let r = ^response
            allStockData[r.f] = r.j

        responses.setLen(0)

    i += 1


echo ""

echo "Dumping..."
writeFile("stocksOverTime.json", $allStockData)

echo "Done!"
