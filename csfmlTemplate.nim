import csfml

const
    BACKGROUND_COLOR = color(30, 30, 40)
    WINDOW_X: cint = 800
    WINDOW_Y: cint = 600

let
    ctxSettings = ContextSettings(antialiasingLevel: 16)
    window = newRenderWindow(videoMode(WINDOW_X, WINDOW_Y), "My Window", settings = ctxSettings)

window.verticalSyncEnabled = true

var
    event: Event

while window.open:
    if window.pollEvent(event):
        case event.kind:
        of EventType.Closed:
            window.close()
            break
        of EventType.KeyPressed:
            if event.key.code == KeyCode.Escape:
                window.close()
                break
            else:
                echo event.key.code
        else: discard

    window.clear(BACKGROUND_COLOR)
    window.display()

window.destroy()
