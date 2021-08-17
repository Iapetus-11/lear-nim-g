import strformat
import csfml
import math
import sets

const BACKGROUND_COLOR = color(30, 30, 40)
const WINDOW_X = 1000
const WINDOW_Y = 1000

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

proc degToRad(degrees: float): float =
    return degrees * PI / 180

proc drawBase(w: RenderWindow) =
    w.clear(BACKGROUND_COLOR)

# https://www.gamedev.net/forums/topic/568216-how-do-i-create-a-circle-in-sfml/4634110/
# const double radius = ??;
# const int maxSides = 32;
# for ( int i = 0; i < 32; ++i ) {
#	double angle = (PI * 2) * static_cast<double>(i)/maxSides;
#	double y = sin(angle) * radius;
#	double x = cos(angle) * radius;
#   player.AddPoint((float)x, (float)y, sf::Color(0, 0, 255));
# }

# drawArc(window, vec2(200.0, 200.0), 180.0, 100.0, 50.0, 1000)
proc drawArc(w: RenderWindow, origin: Vector2f, angle: float, rotation: float, radius: float, maxSides: int, color: Color) =
    var vertices = newVertexArray(LineStrip, maxSides)

    for i in 0..maxSides-1:
        let a = degToRad(rotation) + degToRad(angle) * i.toFloat() / maxSides.toFloat()
        let y = sin(a) * radius
        let x = cos(a) * radius

        vertices[i] = vertex(origin + vec2(x, y), color)

    w.draw(vertices)
    vertices.destroy()

proc drawRecaman(w: RenderWindow, recamanSeq: seq[int], start: int, stop: int) =
    for i in start..stop-1:
        let r: float = recamanSeq[i].toFloat()
        drawArc(w, vec2(2, 2), 180, 0, r*5.0, ((r+1)*10).toInt, color(((255/recamanSeq.len)*r*5000).toInt, i, 255))

var ctxSettings = ContextSettings()
ctxSettings.antialiasingLevel = 16

var window = newRenderWindow(videoMode(WINDOW_X, WINDOW_Y), "Recaman's Sequence Render", WindowStyle.Default, ctxSettings)
window.verticalSyncEnabled = true

# prevents flickering on startup
drawBase(window)
window.display()

let recamanSeq = recaman(10_000)
var n = 1

while window.open:
    var event: Event

    while window.pollEvent(event):
        case event.kind:
        of EventType.Closed: window.close()
        of EventType.KeyPressed:
            case event.key.code:
            of KeyCode.Escape: window.close()
            of KeyCode.Right:
                if n < recamanSeq.high: n += 1
            of KeyCode.Left:
                if n > 2: n -= 1
            else:
                echo event.key.code
        else: discard

        if event.kind == EventType.KeyPressed and event.key.code != KeyCode.Right:
            drawBase(window)
            drawRecaman(window, recamanSeq, 0, n)
        else:
            drawRecaman(window, recamanSeq, n-1, n)

        window.title = &"Recaman's Sequence Render ({n})"
        window.display()

window.destroy()
