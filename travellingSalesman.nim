# Travelling Salesman Problem with ant colony optimization
# inspired by Sebastian Lague - https://www.youtube.com/watch?v=X-iSQQgOd1A

import std/[random, math, strutils, sets, hashes, algorithm]
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

proc `$`(vertexArray: VertexArray): string =
    let count = vertexArray.vertexCount
    var vertices = newSeq[Vertex](count)

    for i in 0..count-1:
        vertices.add(vertexArray[i])

    return "VertexArray<" & $vertexArray.primitiveType & ">[" & vertices.join(", ") & "]"


proc drawPath(window: RenderWindow, path: seq[Point], allPoints: seq[Point]) =
    var vertices = newVertexArray(LineStrip, 0)

    for i, p in path.pairs:
        vertices.resize(i+1)
        vertices.append(vertex(vec2(p), color(255, 30, 50)))
        echo vertices

        window.clear(BACKGROUND_COLOR)
        window.drawPoints(allPoints, color(255, 30, 50), 4.0, 10)
        window.draw(vertices)
        vertices.destroy()
        window.display()
        sleep(milliseconds(200))

var exclude = initHashSet[Point]()

proc getPaths(window: RenderWindow, allPoints: seq[Point], points: seq[Point]): seq[seq[Point]] =
    if points.len == 0:
        exclude.clear()
        return

    let start = points[0]
    exclude.incl(start)

    for i in 1..points.high:
        if points[i] in exclude:
            continue

        var newPoints = points
        newPoints.delete(newPoints.binarySearch(start))
        newPoints.delete(newPoints.binarySearch(points[i]))
        newPoints.insert(points[i], 0)
        echo newPoints

        result.add(@[start] & getPaths(window, allPoints, newPoints))

        window.drawPath(result[result.high], allPoints)
        sleep(milliseconds(500))

    return result


let
    ctxSettings = ContextSettings(antialiasingLevel: 16)
    window = newRenderWindow(videoMode(WINDOW_X, WINDOW_Y), "Travelling Salesman",
            settings = ctxSettings)

window.verticalSyncEnabled = true

var
    event: Event
    points = genPoints(6, 50)

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

    # window.clear(BACKGROUND_COLOR)
    # window.drawPoints(points, color(255, 30, 50), 4.0, 10)
    discard getPaths(window, points, points)

    #window.display()

window.destroy()
