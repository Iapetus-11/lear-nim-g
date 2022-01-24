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

    GRAVITY = 0.0098
    STICK_SIM_ITERS = 2

var
    points: seq[Point]
    sticks: seq[Stick]

proc gameInit() =
    setPalette(loadPalettePico8())

    points.setLen(0)
    sticks.setLen(0)

proc simulate(dt: float32) =
    for p in points:
        if not p.locked:
            let prevPos = p.pos

            p.pos += p.pos - p.prevPos
            p.pos += vec2(0, 1) * (GRAVITY * dt * dt)
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

proc controls() =
    discard

proc gameUpdate(dt: float32) =
    simulate(dt)
    controls()

proc gameDraw() =
    cls()

    setColor(1)
    for s in sticks:
        line(s.a.pos.x, s.a.pos.y, s.b.pos.x, s.b.pos.y)

    setColor(12)
    for p in points:
        circfill(p.pos.x, p.pos.y, 10)

nico.timeStep = 1 / FPS # set fps

nico.init("me.iapetus11", "simtest")
nico.createWindow("Simulation Test", WINDOW_X, WINDOW_Y, SCALE, false)
nico.run(gameInit, gameUpdate, gameDraw)
