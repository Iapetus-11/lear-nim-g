import std/[math]
import nico

type
    PVec2* = object
        x*: PFloat
        y*: PFloat

proc vec2*(x: Pfloat, y: PFloat): PVec2 {.inline.} =
    return PVec2(x: x, y: y)

proc vec2*(p: tuple[x: int, y: int]): PVec2 {.inline.} =
    return PVec2(x: p.x.float, y: p.y.float)

proc toTuple*(v: PVec2): tuple[x: Pfloat, y: Pfloat] =
    return (v.x, v.y)

proc `$`*(v: PVec2): string =
    return "(" & $v.x & "," & $v.y & ")"

proc `+`*(a: PVec2, b: PVec2): PVec2 {.inline.} =
    return vec2(a.x + b.x, a.y + b.y)

proc `-`*(a: PVec2, b: PVec2): PVec2 {.inline.} =
    return vec2(a.x - b.x, a.y - b.y)

proc `*`*(a: PVec2, b: Pfloat): Pvec2 {.inline.} =
    result = PVec2()
    result.x = a.x * b
    result.y = a.y * b

proc `/`*(a: PVec2, b: Pfloat): PVec2 {.inline.} =
    result = PVec2()
    result.x = a.x / b
    result.y = a.y / b

proc rot*(v: PVec2, deg: Pfloat): PVec2 {.inline.} =
    let
        rad = degToRad(deg)
        cR = cos(rad)
        sR = sin(rad)

    return vec2(v.x * cR - v.y * sR, v.x * sR + v.y * cR)

proc mag*(v: PVec2): Pfloat {.inline.} =
    return sqrt(v.x * v.x + v.y * v.y)

proc norm*(v: PVec2): PVec2 {.inline.} =
    let m = v.mag

    return vec2(v.x / m, v.y / m)

proc contains*(cP: PVec2, cR: Pfloat, v: Pvec2): bool {.inline.} =
    return pow(v.x - cP.x, 2) + pow(v.y - cP.y, 2) < pow(cR, 2)

proc dist*(a: PVec2, b: Pvec2): Pfloat {.inline.} =
    return sqrt(pow(b.x - a.x, 2) + pow(b.y - a.y, 2))

# proc disti*(a: PVec2, b: Pvec2): Pfloat {.inline.} =
#     return sqrt(pow(b.x.int - a.x.int, 2) + pow(b.y.int - a.y.int, 2))
