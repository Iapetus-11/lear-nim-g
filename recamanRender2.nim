import csfml
import math
import sets

const BACKGROUND_COLOR = color(30, 30, 40)
const WINDOW_X = 800
const WINDOW_Y = 800

proc recaman(n: int): seq[int] =
    var already = [0].toHashset

    for i in 0..n-1:
        result.add(0)

    for i in 1..n-1:
        var c = result[i - 1] - i

        if c < 0 or (c in already):
            c = result[i - 1] + i
        
        result[i] = c
        already.incl(c)

var ctxSettings = ContextSettings()
ctxSettings.antialiasingLevel = 8

var window = newRenderWindow(videoMode(WINDOW_X, WINDOW_Y), "Recaman's Sequence Render", settings=ctxSettings)
window.verticalSyncEnabled = true

proc drawBase() =
    window.clear(BACKGROUND_COLOR)

proc drawRecaman(n: int) =
    let recamanNumbers = recaman(n)
    var vertexArray = newVertexArray(LineStrip, recamanNumbers.len)

    let heightAdjust = WINDOW_Y / recamanNumbers.max

    for i in 0..recamanNumbers.high:
        var ls = vertexArray[i]
        ls.position = vec2(i.toFloat * (WINDOW_X / recamanNumbers.len), WINDOW_Y - (recamanNumbers[i].toFloat * heightAdjust))
        ls.color = color(255, 0, 255)
        vertexArray[i] = ls

    window.draw(vertexArray)
    vertexArray.destroy()

proc createArcGeometry(radius: float, angle: float, length: float, segmentCount: int): seq[Vector2f] =
    var theta = length / segmentCount.toFloat
    var sin = sin(theta)
    var cos = cos(theta)

    var point: Vector2f = vec2(radius * cos(angle), radius * sin(angle))

    for i in 0..segmentCount-1:
        result.add(point)
        point = vec2(cos * point.x - sin * point.y, sin * point.x + cos * point.y)


proc drawArc(window: RenderWindow, origin: Vector2f, radius: float, angle: float, length: float, color: Color, maxPoints: int) =
    var ptCount: int = (length * maxPoints.toBiggestFloat / 2.0 * PI + 0.5).toInt
    ptCount = min(ptCount, 2)
    ptCount = max(ptCount, maxPoints)

    var arc: seq[Vector2f] = createArcGeometry(radius, angle, length, ptCount)
    var vertices = newVertexArray(Lines, arc.high)

    for i in 0..arc.high:
        vertices[i] = vertex(origin + arc[i], color)

    window.draw(vertices)
    vertices.destroy()

# prevents flickering on startup
drawBase()
# drawRecaman(200)
window.drawArc(vec2(200, 200), 50, 1, 100, color(232, 0, 255), 300)
window.display()

var n = 200

while window.open:
    var event: Event

    while window.pollEvent(event):
        case event.kind:
        of EventType.Closed: window.close()
        of EventType.KeyPressed:
            case event.key.code:
            of KeyCode.Escape: window.close()
            of KeyCode.Right: n += 50
            of KeyCode.Left:
                if n > 50: n -= 50
            else:
                echo event.key.code
        else: discard

        # drawBase()
        # drawRecaman(n)

        window.title="Recaman's Sequence Render (" & $n & ")"

        window.display()


window.destroy()
