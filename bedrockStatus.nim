import std/[strutils, net]

const REQUEST = "\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\xff\x00\xfe\xfe\xfe\xfe\xfd\xfd\xfd\xfd\x124Vx"
const MAX_PACKET_SIZE = 65507

proc main() {.discardable.} =
    stdout.write("Enter a Minecraft Bedrock Edition server: ")
    let serverSplit = readLine(stdin).split(':')

    var host: string
    var port: int

    if serverSplit.len == 1:
        host = serverSplit[0]
        port = 19132
    elif serverSplit.len > 1:
        host = serverSplit[0]
        port = serverSplit[1].parseInt

    let sock = newSocket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)
    sock.sendTo(host, Port(port), REQUEST)

    var data = ""
    var incomingPort = Port(0)
    discard sock.recvFrom(data, MAX_PACKET_SIZE, host, incomingPort)

    let dataSplit = data.split(';')

    echo "motd           : ", dataSplit[1]
    echo "version        : ", dataSplit[3], " | Protocol ", dataSplit[2]
    echo "players online : ", dataSplit[4], "/", dataSplit[5]
    echo "world          : ", dataSplit[7]
    echo "gamemode       : ", dataSplit[8]

when isMainModule:
    main()
