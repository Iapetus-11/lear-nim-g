import strutils
import nigui
import net

const REQUEST = "\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\xff\x00\xfe\xfe\xfe\xfe\xfd\xfd\xfd\xfd\x124Vx"
const MAX_PACKET_SIZE = 65507

type ServerStatus = object
    motd: string
    version: string
    protocol: int
    player_count: int
    max_players: int
    world: string
    gamemode: string

proc checkStatus(host: var string, port: int): ServerStatus =
    let sock = newSocket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)
    sock.sendTo(host, Port(port), REQUEST)

    var data = ""
    var incomingPort = Port(0)
    discard sock.recvFrom(data, MAX_PACKET_SIZE, host, incomingPort)

    let dataSplit = data.split(';')

    return ServerStatus(
        motd: dataSplit[1],
        version: dataSplit[3],
        protocol: dataSplit[2].parseInt,
        player_count: dataSplit[4].parseInt,
        max_players: dataSplit[5].parseInt,
        world: dataSplit[7],
        gamemode: dataSplit[8]
    )

proc main() {.discardable.} =
    app.init()

    var
        window = newWindow("Bedrock Server Status")
        windowContainer = newLayoutContainer(Layout_Vertical)
        horizon = newLayoutContainer(Layout_Horizontal)
        labelContainer = newLayoutContainer(Layout_Vertical)
        serverAddressTextBox = newTextBox()
        checkStatusButton = newButton("Check Status")
        motdLabel = newLabel("MOTD: ")
        versionLabel = newLabel("Version: ")
        playersLabel = newLabel("Players: ")
        worldLabel = newLabel("World: ")
        gamemodeLabel = newLabel("Gamemode: ")
    
    window.iconPath = "emerald.png"
    window.width = 400.scaleToDpi
    window.height = 175.scaleToDpi

    window.add(windowContainer)
    windowContainer.add(horizon)
    windowContainer.add(labelContainer)

    horizon.add(checkStatusButton)
    horizon.add(serverAddressTextBox)
    
    labelContainer.add(motdLabel)
    labelContainer.add(versionLabel)
    labelContainer.add(playersLabel)
    labelContainer.add(worldLabel)
    labelContainer.add(gamemodeLabel)

    proc updateServerStatus() =
        let serverSplit = serverAddressTextBox.text.split(':')
        var host: string
        var port: int

        if serverSplit.len == 1:
            host = serverSplit[0]
            port = 19132
        elif serverSplit.len > 1:
            host = serverSplit[0]
            port = serverSplit[1].parseInt
        
        try:
            let status = checkStatus(host, port)

            motdLabel.text = "MOTD: " & status.motd & " "
            versionLabel.text = "Version: " & status.version & " | Protocol: " & $status.protocol & " "
            playersLabel.text = "Players: " & $status.player_count & "/" & $status.max_players & " "
            worldLabel.text = "World: " & status.world & " "
            gamemodeLabel.text = "Gamemode: " & status.gamemode & " "
        except OSError:
            motdLabel.text = "MOTD: ERROR"
            versionLabel.text = "Version: ERROR"
            playersLabel.text = "Players: ERROR"
            worldLabel.text = "World: ERROR"
            gamemodeLabel.text = "Gamemode: ERROR"

    checkStatusButton.onClick = proc(event: ClickEvent) =
        updateServerStatus()

    serverAddressTextBox.onKeyDown = proc(event: Keyboardevent) =
        if event.key == Key_Return:
            updateServerStatus()

    window.show()
    app.run()

when isMainModule:
    main()


