import csfml
import math

const BACKGROUND_COLOR = color(30, 30, 40)
const WINDOW_X = 800
const WINDOW_Y = 600

type Vector2 = Vector2f or Vector2i

var ctxSettings = ContextSettings()
ctxSettings.antialiasingLevel = 16

var window = newRenderWindow(videoMode(WINDOW_X, WINDOW_Y), "Peen", settings=ctxSettings)
window.verticalSyncEnabled = true

proc setActiveUnsafe(w: RenderWindow, active: bool): bool =
    result = block:
        window.active = active

proc setActive(w: RenderWindow, active: bool) {.discardable.} =
    let success = setActiveUnsafe(w, active)

    if not success:
        raise newException(CatchableError, "Unable to set active window state.")

proc degToRad(degrees: float): float =
    return degrees * PI / 180

proc drawArc(w: RenderWindow, origin: Vector2f, angle: float, rotation: float, radius: float, maxSides: int, color: Color) =
    var vertices = newVertexArray(LineStrip, maxSides)

    for i in 0..maxSides-1:
        let a = degToRad(rotation) + degToRad(angle) * i.toFloat() / (maxSides.toFloat() - 1.0)
        let y = sin(a) * radius
        let x = cos(a) * radius

        vertices[i] = vertex(origin + vec2(x, y), color)

    w.draw(vertices)
    vertices.destroy()

proc drawLineStrip(w: RenderWindow, origin: Vector2, points: openArray[Vector2], color: Color) =
    var vertices = newVertexArray(LineStrip, points.len)

    for i in 0..points.high:
        vertices[i] = vertex(origin + points[i], color)

    w.draw(vertices)
    vertices.destroy()

var drawThread: system.Thread[void]

proc drawInThread() {.thread, gcsafe.} =
    window.setActive(true)

    window.clear(BACKGROUND_COLOR)

    var
        origin = vec2(400, 300)
        skin = color(241, 194, 125)
    
    window.drawArc(origin + vec2(0, -180), 180, 180, 30, 100, skin)
    window.drawLineStrip(origin + vec2(-30, -180), [vec2(0, 0), vec2(0, 180)], skin)
    window.drawLineStrip(origin + vec2(30, -180), [vec2(0, 0), vec2(0, 180)], skin)
    window.drawArc(origin + vec2(-30, -180) + vec2(0, 180) + vec2(0, 30), 270, 0, 30, 100, skin)
    window.drawArc(origin + vec2(-30, -180) + vec2(0, 180) + vec2(60, 30), 270, 270, 30, 100, skin)

    var color = color(232, 0, 232)
    origin = vec2(200, 300)

    window.drawLineStrip(origin, [vec2(0, 0), vec2(0, 20), vec2(20, 20), vec2(20, 0), vec2(0, 0)], color)
    window.drawLineStrip(origin + vec2(7, 7), [vec2(0, 0), vec2(0, 20), vec2(20, 20), vec2(20, 0), vec2(0, 0)], color)
    window.drawLineStrip(origin, [vec2(0, 0), vec2(7, 7), vec2(27, 7), vec2(20, 0)], color)
    window.drawLineStrip(origin + vec2(0, 20), [vec2(0, 0), vec2(7, 7), vec2(27, 7), vec2(20, 0)], color)

    window.display()
    # discard window.capture().saveToFile("sussy.png")
    window.setActive(false)

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
