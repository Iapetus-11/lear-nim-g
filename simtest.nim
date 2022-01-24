import nico

import simtestvec

type
    Point = ref object
        pos, prevPos: PVec2
        locked: bool

    Stick = ref object
        a, b: Point
        len: Pfloat

const
    WINDOW_X = 512
    WINDOW_Y = 512
    SCALE = 1

    FPS = 60

    GRAVITY = 980.0
    STICK_SIM_ITERS = 2

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

    for i in 0 .. STICK_SIM_ITERS - 1:
        for s in sticks:
            let
                sCenter = (s.a.pos + s.b.pos) / 2
                sDir = (s.a.pos - s.b.pos).norm

            if not s.a.locked:
                s.a.pos = sCenter + sDir * s.len / 2

            if not s.b.locked:
                s.b.pos = sCenter - sDir * s.len / 2

proc controls() = # a
    if keyp(K_SPACE):
        paused = not paused

    if mousebtnp(0):
        let mousePos = vec2(mouse())
        var placePoint = true

        for p in points:
            if contains(p.pos, 15, mousePos):
                lastPoint = p
                placePoint = false
                break
        
        if placePoint:
            points.add(Point(pos: mousePos, prevPos: mousePos, locked: false))
            lastPoint = points[points.high]

    if mousebtnp(1):
        let mousePos = vec2(mouse())

        for p in points:
            if contains(p.pos, 15, mousePos):
                p.locked = not p.locked
                break
    
    if mousebtnup(0) and not lastPoint.isNil:
        let mousePos = vec2(mouse())

        if not contains(lastPoint.pos, 15, mousePos):
            var endP: Point

            for p in points:
                if contains(p.pos, 15, mousePos):
                    endP = p
            
            if endP.isNil:
                points.add(Point(pos: mousePos, prevPos: mousePos, locked: false))
                endP = points[points.high]
                
            sticks.add(Stick(a: lastPoint, b: endP, len: (lastPoint.pos - endP.pos).mag))


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

    for p in points:
        if p.locked:
            setColor(8)
        else:
            setColor(12)

        circfill(p.pos.x, p.pos.y, 5)

nico.timeStep = 1 / FPS # set fps

nico.init("me.iapetus11", "simtest")
nico.createWindow("Simulation Test", WINDOW_X, WINDOW_Y, SCALE, false)
nico.run(gameInit, gameUpdate, gameDraw)
