import csfml

var
    window = newRenderWindow(videoMode(800, 600), "My Window")

window.verticalSyncEnabled = true

while window.open:
    var event: Event

    while window.pollEvent(event):
        case event.kind:
        of EventType.Closed: window.close()
        of EventType.KeyPressed:
            if event.key.code == KeyCode.Escape:
                window.close()
            else:
                echo event.key.code
        else: discard


window.destroy()
