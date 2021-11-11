# Travelling Salesman Problem with ant colony optimization
# inspired by Sebastian Lague - https://www.youtube.com/watch?v=X-iSQQgOd1A

import std/[random, math, algorithm]
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

proc drawLinesIncr(window: RenderWindow, lines: seq[array[2, Point]], color: Color, delayMs: int) =
    for i in 0..lines.high:
        if i != 0:
            sleep(milliseconds(delayMs.int32))

        window.drawLine(lines[i][0], lines[i][1], color)
        window.display()

proc getOptimalPath(window: RenderWindow, points: seq[Point]): seq[Point] =
    if points.len == 0:
        return

    let start = points[0]
    var
        lowestDistance = distance(start, points[1])
        nearestPoint = points[1]
        nearestPointIdx = 1

    for i in 2..points.high:
        let d = distance(start, points[i])

        if lowestDistance > d:
            lowestDistance = d
            nearestPoint = points[i]
            nearestPointIdx = i

    result.add(start)
    result.add(nearestPoint)

    var newPoints = points
    newPoints.del(nearestPointIdx)
    newPoints.insert(nearestPoint, 0)

    for p in getOptimalPath(window, newPoints):
        result.add(p)




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

    window.clear(BACKGROUND_COLOR)
    window.drawPoints(points, color(255, 30, 50), 4.0, 10)
    window.getPaths(points)

    window.display()

window.destroy()
