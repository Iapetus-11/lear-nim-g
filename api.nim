import httpclient
import json

when isMainModule:
    stdout.write("Enter a Minecraft server: ")

    let server = readLine(stdin)
    let url = "https://api.iapetus11.me/mc/status/"&server

    let client = newHttpClient()
    let data = parseJson(client.getContent(url))

    echo "server       : ", server
    echo "success      : ", data["success"]
    echo "online       : ", data["online"]
    echo "latency      : ", data["latency"], "ms"
    echo "player count : ", data["players_online"], "/", data["players_max"]
