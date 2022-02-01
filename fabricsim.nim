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
    WINDOW_X = 946
    WINDOW_Y = 640
    SCALE = 1

    FPS = 60

    GRAVITY = 640.0

    GRID_DIST = 12

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

proc simulate(dt: float32) {.inline.} =
    for p in points:
        if not p.locked:
            let prevPos = vec2(p.pos.x, p.pos.y)

            p.pos = p.pos + (p.pos - p.prevPos)
            p.pos = p.pos + vec2(0, (GRAVITY * dt * dt))
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

proc controls() {.inline.} =
    if keyp(K_R): gameInit()

    if keyp(K_SPACE): paused = not paused

    # place new points
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

    # toggle if point is locked
    if mousebtnp(1) or keyp(K_L):
        let mousePos = vec2(mouse())

        for p in points:
            if contains(p.pos, 4, mousePos):
                p.locked = not p.locked
                break

    # draw line between two points
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

    # destroy points / lines
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

    # draw grid
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

nico.init("me.iapetus11", "fabricsim")
nico.createWindow("Fabric Sim", WINDOW_X, WINDOW_Y, SCALE, false)
nico.run(gameInit, gameUpdate, gameDraw)
