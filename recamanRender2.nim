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

proc degToRad(degrees: float): float =
    return degrees * PI / 180

# https://www.gamedev.net/forums/topic/568216-how-do-i-create-a-circle-in-sfml/4634110/
# const double radius = ??;
# const int maxSides = 32;
# for ( int i = 0; i < 32; ++i ) {
#	double angle = (PI * 2) * static_cast<double>(i)/maxSides;
#	double y = sin(angle) * radius;
#	double x = cos(angle) * radius;
#   player.AddPoint((float)x, (float)y, sf::Color(0, 0, 255));
# }


proc drawArc(window: RenderWindow, origin: Vector2f, angle: float, rotation: float, radius: float, maxSides: int) =
    var vertices = newVertexArray(LineStrip, maxSides)

    for i in 0..maxSides-1:
        let a = degToRad(rotation) + degToRad(angle) * i.toFloat()/maxSides.toFloat()
        let y = sin(a) * radius
        let x = cos(a) * radius

        vertices[i] = vertex(origin + vec2(x, y), color(232, 0, 255))

    window.draw(vertices)


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

# prevents flickering on startup
drawBase()
drawRecaman(200)
drawArc(window, vec2(200.0, 200.0), 180.0, 100.0, 50.0, 1000)
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

        # window.title="Recaman's Sequence Render (" & $n & ")"

        # window.display()


window.destroy()
