# Travelling Salesman Problem with ant colony optimization
# inspired by Sebastian Lague - https://www.youtube.com/watch?v=X-iSQQgOd1A

import std/random
import csfml

randomize()

type
    Point = ref object
        x: int
        y: int

const
    BACKGROUND_COLOR = color(30, 30, 40)
    WINDOW_X: cint = 800
    WINDOW_Y: cint = 600

proc vec2(point: Point): Vector2i =
    return vec2(point.x, point.y)

proc genPoints(n: int, padding: int): seq[Point] =
    result = newSeq[Point](n)

    for i in 0..n-1:
        result[i] = Point(x: padding + rand(WINDOW_X - padding * 2), y: padding + rand(WINDOW_Y -
                padding * 2))

proc drawPoints(window: RenderWindow, points: seq[Point], color: Color, radius: float,
        pointsPerCircle: int) =
    for p in points:
        let c = newCircleShape(radius, pointsPerCircle)

        c.fillColor = color
        c.position = vec2(p)

        window.draw(c)

        c.destroy()

proc solveBruteForceBlocking(window: RenderWindow, points: seq[Point]) =
    let start = points[0]

let
    ctxSettings = ContextSettings(antialiasingLevel: 16)
    window = newRenderWindow(videoMode(WINDOW_X, WINDOW_Y), "Travelling Salesman (Ants)",
            settings = ctxSettings)

window.verticalSyncEnabled = true

var
    event: Event
    points = genPoints(20, 50)

while window.open:
    if window.pollEvent(event):
        case event.kind:
        of EventType.Closed:
            window.close()
            break
        of EventType.KeyPressed:
            case event.key.code:
            of KeyCode.Escape:
                window.close()
                break
            of KeyCode.R:
                points = genPoints(10, 50)
            else: discard
        else: discard

    window.clear(BACKGROUND_COLOR)
    window.drawPoints(points, color(255, 30, 50), 4.0, 10)

    window.display()

window.destroy()
