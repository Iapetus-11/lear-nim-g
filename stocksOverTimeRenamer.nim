# compile with gc:arc or else this won't work!

import std/[os, sequtils, strformat, threadpool, strutils]

setMaxPoolSize(7)

var
    i = 0
    files = toSeq(walkDir("dump", relative=true))
    filesLen = files.len

proc renameStonkFile(filePath: string) =
    moveFile(&"dump/{filePath}", &"dump/{filePath[0..filePath.high-13]}.json")

echo "Loading individual files..."

for file in files:
    stdout.write(&"{i+1}/{filesLen}\r")
    
    if "-history.json" in file.path:
        spawn renameStonkFile(file.path)

    i += 1


sync()

echo "\nDone!"
