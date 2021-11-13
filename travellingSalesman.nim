# Travelling Salesman Problem with ant colony optimization
# inspired by Sebastian Lague - https://www.youtube.com/watch?v=X-iSQQgOd1A

import std/[random, math, algorithm, sets, hashes]
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

proc distance(a: Point, b: Point): float =
    return sqrt(pow(float(b.x - a.x), 2.0) + pow(float(b.y - a.y), 2.0))

proc `$`(point: Point): string =
    return '(' & $point.x & ',' & $point.y & ')'

proc hash(point: Point): Hash =
    return hash($point)

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
        c.position = vec2(p.x.float - radius, p.y.float - radius)

        window.draw(c)
        c.destroy()

proc drawLine(window: RenderWindow, a: Point, b: Point, color: Color) =
    let vertices = newVertexArray(Lines, 2)

    vertices.append(vertex(vec2(a), color))
    vertices.append(vertex(vec2(b), color))

    window.draw(vertices)
    vertices.destroy()

proc drawPath(window: RenderWindow, path: seq[Point], allPoints: seq[Point]) =
    var vertices = newVertexArray(LineStrip)

    echo path

    for p in path:
        vertices.append(vertex(vec2(p), color(255, 30, 50)))
        window.clear(BACKGROUND_COLOR)
        window.drawPoints(allPoints, color(255, 30, 50), 4.0, 10)
        window.draw(vertices)
        window.display()
        sleep(milliseconds(200))

var urMom = initHashSet[Point]()

proc getPaths(window: RenderWindow, allPoints: seq[Point], points: seq[Point], exclude: var HashSet[Point] = urMom): seq[seq[Point]] =
    let start = points[0]
    exclude.incl(start)

    for i in 1..points.high:
        var tempPoints: seq[Point]
        tempPoints = points
        tempPoints.del(i)
        tempPoints.del(0)

        tempPoints.insert(points[i], 0)
        
        var newPaths = getPaths(window, allPoints, tempPoints, exclude)

        echo newPaths

        for path in newPaths:
            echo "hi"
            result.add(@[start] & path)
            window.drawPath(result[result.high], allPoints)

    return result


let
    ctxSettings = ContextSettings(antialiasingLevel: 16)
    window = newRenderWindow(videoMode(WINDOW_X, WINDOW_Y), "Travelling Salesman",
            settings = ctxSettings)

window.verticalSyncEnabled = true

var
    event: Event
    points = genPoints(6, 50)

proc drawLinesIncr(window: RenderWindow, lines: seq[array[2, Point]], color: Color, start: int,
        delayMs: int) =
    for i in 0..lines.high:
        window.clear(BACKGROUND_COLOR)

        for j in 0..i:
            window.drawLine(lines[j][0], lines[j][1], color)

        window.drawPoints(points, color(255, 30, 50), 4.0, 10)
        window.display()
        sleep(milliseconds(delayMs.int32))


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
                points = genPoints(6, 50)
            else: discard
        else: discard

    window.clear(BACKGROUND_COLOR)
    window.drawPoints(points, color(255, 30, 50), 4.0, 10)
    discard getPaths(window, points, points)

    window.display()

window.destroy()
