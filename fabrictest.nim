import std/[tables]

import nico

import vec

type
    Point = ref object
        pos, prevPos: PVec2
        locked: bool

    Stick = ref object
        a, b: Point
        len: Pfloat

const
    WINDOW_X = 768
    WINDOW_Y = 480
    SCALE = 1

    FPS = 60

    GRAVITY = 980.0

    GRID_DIST = 10

    SIM_REPEAT = 3

proc newStick(a: Point, b: Point): Stick =
    return Stick(a: a, b: b, len: (a.pos - b.pos).mag)

var
    points: seq[Point]
    sticks: seq[Stick]

    lastPoint: Point

    paused = false

proc gameInit() =
    setPalette(loadPalettePico8())

    points.setLen(0)
    sticks.setLen(0)

    paused = false

proc simulate(dt: float32) =
    for p in points:
        if not p.locked:
            let prevPos = vec2(p.pos.x, p.pos.y)

            p.pos += p.pos - p.prevPos
            p.pos += vec2(0, (GRAVITY * dt * dt))
            p.prevPos = prevPos

    for i in 0 .. SIM_REPEAT - 1:
        for s in sticks:
            let
                sCenter = (s.a.pos + s.b.pos) / 2
                sDir = (s.a.pos - s.b.pos).norm

            if not s.a.locked:
                s.a.pos = sCenter + sDir * s.len / 2

            if not s.b.locked:
                s.b.pos = sCenter - sDir * s.len / 2

    # # cull objects outside window
    # var
    #     newPoints: seq[Point]
    #     newSticks: seq[Stick]

    # for s in sticks:
    #     if s.a.pos.y < WINDOW_Y * 10 and s.b.pos.y < WINDOW_Y * 10:
    #         newSticks.add(s)
    #         newPoints.add(s.a)
    #         newPoints.add(s.b)

    # shallowCopy(points, newPoints)
    # shallowCopy(sticks, newSticks)

proc controls() = # a
    if keyp(K_SPACE):
        paused = not paused

    if mousebtnp(0):
        let mousePos = vec2(mouse())
        var placePoint = true

        for p in points:
            if contains(p.pos, 4, mousePos):
                lastPoint = p
                placePoint = false
                break

        if placePoint:
            points.add(Point(pos: mousePos, prevPos: mousePos, locked: false))
            lastPoint = points[points.high]

    if mousebtnp(1) or keyp(K_L):
        let mousePos = vec2(mouse())

        for p in points:
            if contains(p.pos, 4, mousePos):
                p.locked = not p.locked
                break

    if mousebtnup(0) and not lastPoint.isNil:
        let mousePos = vec2(mouse())

        if not contains(lastPoint.pos, 4, mousePos):
            var endP: Point

            for p in points:
                if contains(p.pos, 4, mousePos):
                    endP = p

            if endP.isNil:
                points.add(Point(pos: mousePos, prevPos: mousePos, locked: false))
                endP = points[points.high]

            sticks.add(newStick(lastPoint, endP))

    if mousebtn(2):
        let mousePos = vec2(mouse())

        var dP: Point

        for i, p in points.pairs:
            if contains(p.pos, 10, mousePos):
                dP = p
                points.del(i)
                break

        if not dP.isNil:
            var cont = true

            while cont:
                cont = false

                for i, s in sticks.pairs:
                    if s.a == dP or s.b == dP:
                        sticks.del(i)
                        cont = true
                        break

    if keyp(K_M):
        gameInit()

        var pMap: Table[tuple[x: Pfloat, y: Pfloat], Point]

        for x in 40 .. WINDOW_X - 39:
            for y in 40 .. WINDOW_Y - 39:
                if x mod GRID_DIST == 0 and y mod GRID_DIST == 0:
                    let p = Point(pos: vec2(x, y), prevPos: vec2(x, y), locked: false)
                    points.add(p)
                    pMap[p.pos.toTuple] = p

        for p in points:
            if pMap.hasKey((p.pos + vec2(-GRID_DIST, 0)).toTuple):
                sticks.add(newStick(p, pMap[(p.pos + vec2(-GRID_DIST, 0)).toTuple]))

            if pMap.hasKey((p.pos + vec2(0, GRID_DIST)).toTuple):
                sticks.add(newStick(p, pMap[(p.pos + vec2(0, GRID_DIST)).toTuple]))

        paused = true

proc gameUpdate(dt: float32) =
    if not paused:
        simulate(dt)

    controls()

proc gameDraw() =
    cls()

    setColor(1)
    for s in sticks:
        line(s.a.pos.x, s.a.pos.y, s.b.pos.x, s.b.pos.y)
        line(s.a.pos.x-1, s.a.pos.y-1, s.b.pos.x-1, s.b.pos.y-1)
        line(s.a.pos.x+1, s.a.pos.y+1, s.b.pos.x+1, s.b.pos.y+1)

    setColor(12)

    for p in points:
        if p.locked:
            setColor(8)
            circfill(p.pos.x, p.pos.y, 3)
            setColor(12)
        else:
            circfill(p.pos.x, p.pos.y, 3)

nico.timeStep = 1 / FPS # set fps

nico.init("me.iapetus11", "simtest")
nico.createWindow("Simulation Test", WINDOW_X, WINDOW_Y, SCALE, false)
nico.run(gameInit, gameUpdate, gameDraw)
