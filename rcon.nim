import std/[random, strutils, streams, net]

randomize()

const MessageTypes = (
    SERVERDATA_AUTH: 3,
    SERVERDATA_AUTH_RESPONSE: 2,
    SERVERDATA_EXECCOMMAND: 2,
    SERVERDATA_RESPONSE_VALUE: 0
)

stdout.write("Enter a server address: ")
let addrSplit = readLine(stdin).split(':')

var
    host: string
    port: Port

if addrSplit.len > 1:
    host = addrSplit[0]
    port = Port(parseInt(addrSplit[1]))
else:
    stdout.write("Enter a port: ")
    port = Port(parseInt(readLine(stdin)))

let sock = newSocket()
sock.connect(host, port)

proc sendMsg(messageType: int, message: string) {.discardable.} =
    var data = newStringStream()

    data.write(cast[int16](rand(2147483647)))
    data.write(cast[int16](messageType))
    data.write(cast[int16]((message & "\x00\x00").len))
    data.write(message & "\x00\x00")




