import csfml

const BACKGROUND_COLOR = color(30, 30, 40)
const WINDOW_X = 800
const WINDOW_Y = 600

var ctxSettings = ContextSettings()
ctxSettings.antialiasingLevel = 16

var window = newRenderWindow(videoMode(WINDOW_X, WINDOW_Y), "My Window", settings=ctxSettings)
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
