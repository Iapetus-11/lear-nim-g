import csfml

const BACKGROUND_COLOR = color(30, 30, 40)
const WINDOW_X = 800
const WINDOW_Y = 600

var ctxSettings = ContextSettings()
ctxSettings.antialiasingLevel = 4

var window = newRenderWindow(videoMode(WINDOW_X, WINDOW_Y), "My Window", settings=ctxSettings)
window.verticalSyncEnabled = true

proc setActiveUnsafe(w: RenderWindow, active: bool): bool =
    result = block:
        window.active = active

proc setActive(w: RenderWindow, active: bool) {.discardable.} =
    let success = setActiveUnsafe(w, active)

    if not success:
        raise newException(CatchableError, "Unable to set active window state.")

var drawThread: system.Thread[void]

proc drawInThread() {.thread, gcsafe.} =
    window.setActive(true)

    window.clear(BACKGROUND_COLOR)

    let
        color = color(232, 0, 255)
        origin = vec2(600, 200)
        points = [
            origin,
            origin + vec2(10, 0),
            origin + vec2(10, 10),
            origin + vec2(20, 10)
        ]

    var vertices = newVertexArray(LineStrip, 10)
    for i in 0..points.high:
        vertices[i] = vertex(points[i], color)

    window.draw(vertices)
    vertices.destroy()

    window.display()

window.setActive(false)
createThread(drawThread, drawInThread)

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
