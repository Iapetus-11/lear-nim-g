import std/[math]
import nico

type
    PVec2* = ref object
        x*: PFloat
        y*: PFloat

proc vec2*(x: Pfloat, y: PFloat): PVec2 =
    return PVec2(x: x, y: y)

proc vec2*(p: tuple[x: int, y: int]): PVec2 =
    return PVec2(x: p.x.float, y: p.y.float)

proc `$`*(p: PVec2): string =
    return "(" & $p.x & "," & $p.y & ")"

proc `+`*(a: PVec2, b: PVec2): PVec2 =
    return vec2(a.x + b.x, a.y + b.y)

proc `+=`*(a: PVec2, b: PVec2) =
    a.x += b.x
    a.y += b.y

proc `-`*(a: PVec2, b: PVec2): PVec2 =
    return vec2(a.x - b.x, a.y - b.y)

proc `-=`*(a: PVec2, b: PVec2) =
    a.x -= b.x
    a.y -= b.y

proc `*`*(a: PVec2, b: Pfloat): Pvec2 =
    result = PVec2()
    result.x = a.x * b
    result.y = a.y * b

proc `*=`*(a: PVec2, b: Pfloat) =
    a.x = a.x * b
    a.y = a.y * b

proc `/`*(a: PVec2, b: Pfloat): PVec2 =
    result = PVec2()
    result.x = a.x / b
    result.y = a.y / b

proc `/=`*(a: PVec2, b: Pfloat) =
    a.x = a.x / b
    a.y = a.y / b

proc rot*(p: PVec2, deg: Pfloat): PVec2 =
    let rad = degToRad(deg)

    return vec2(p.x * cos(rad) - p.y * sin(rad), p.x * sin(rad) + p.y * cos(rad))

proc mag*(v: PVec2): Pfloat =
    return sqrt(v.x * v.x + v.y * v.y)

proc norm*(v: PVec2): PVec2 =
    let m = v.mag

    return vec2(v.x / m, v.y / m)

proc contains*(cP: PVec2, cR: Pfloat, v: Pvec2): bool =
    return pow(v.x - cP.x, 2) + pow(v.y - cP.y, 2) < pow(cR, 2)
