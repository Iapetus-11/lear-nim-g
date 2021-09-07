import std/[strformat, os, json, strutils, tables]
import csfml

const
    BACKGROUND_COLOR = color(30, 30, 40)
    WINDOW_X: cint = 800
    WINDOW_Y: cint = 600

iterator enumerate[T](s: seq[T]): tuple[i: int, v: T] =
    var i = 0

    for e in s:
        yield (i, e)
        i += 1

proc isNan(n: float): bool =
    return not (n > 0 or n < 0 or n == 0)

proc smoothedMax(s: seq[float]): float =
    let mid = s.high / 2

    for i, e in enumerate(s):
        var adj = (abs(mid - float(i)) + 1.0) / float(s.len) * 5.0
        result += e / adj

    result /= float(s.len)

proc drawStonk(w: RenderWindow, d: seq[float], m: float, c: tuple[x1: int, x2: int, y1: int, y2: int]) =
    let
        l = d.len
        widthAdjust = float(c.x2 - c.x1) / float(l)
        heightAdjust = float(c.y2 - c.y1) / m

    var vertices = newVertexArray(PrimitiveType.LineStrip, l)

    for i in 0..l-1:
        vertices[i] = vertex(
            vec2(
                float(i) * widthAdjust + float(c.x1),
                float(c.y2 - c.y1) - d[i] * heightAdjust + float(c.y1)
            ),
            color(20, 255, 255)
        )

    w.draw(vertices)
    vertices.destroy()

let
    stock = paramStr(1).toUpperAscii()
    stockPrices = block:
        let
            data = parseJson(readFile(&"dump/{stock}.json"))
            fields = data.getFields()

        var
            result = newSeq[float]()
            started = false  # should be false in prod

        for p in fields.values:
            let pf = p.getFloat()

            if isNan(pf) or pf == 0.0:
                if started:
                    result.add(0)
            else:
                started = true
                result.add(pf)

        result
    stockPricesMax = stockPrices.max
    stockPricesLen = stockPrices.len

var
    ctxSettings = ContextSettings(antialiasingLevel: 16)
    window = newRenderWindow(videoMode(WINDOW_X, WINDOW_Y), &"Stock Price Visualization [{stock}]",
            WindowStyle.Default, ctxSettings)
    event: Event
    rDefault = 0..stockPricesLen-1
    r = rDefault
    rOuter = rDefault

window.verticalSyncEnabled = true

while window.open:
    if window.pollEvent(event):
        case event.kind:
        of EventType.Closed:
            window.close()
            break
        of EventType.KeyPressed:
            if event.key.code == KeyCode.Escape:
                window.close()
                break
        else: discard

    window.clear(BACKGROUND_COLOR)
    window.drawStonk(stockPrices, stockPricesMax, (20, int(WINDOW_X) - 20, 20, int(WINDOW_Y / 2) - 20))

    let mPos = window.mouse_getPosition

    if mPos.x <= 10 or mPos.x >= WINDOW_X - 10:
        window.drawStonk(stockPrices, stockPricesMax, (20, int(WINDOW_X) - 20, int(WINDOW_Y / 2) + 20, int(WINDOW_Y) - 20))
    else:
        r = max(int(mPos.x-15), 0)..min(int(mPos.x)+14, WINDOW_X)
        rOuter = max(int(mPos.x)-119, 0)..min(int(mPos.x)+120, WINDOW_X)
        window.drawStonk(stockPrices[r], stockPrices[rOuter].smoothedMax, (20, int(WINDOW_X) - 20, int(WINDOW_Y / 2) + 20, int(WINDOW_Y) - 20))
    
    window.display()

window.destroy()
