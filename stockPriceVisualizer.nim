import std/[strformat, os, json, strutils, tables]
import csfml

const
    BACKGROUND_COLOR = color(30, 30, 40)
    WINDOW_X: cint = 1280
    WINDOW_Y: cint = 796

iterator enumerate[T](s: seq[T]): tuple[i: int, v: T] =
    var i = 0

    for e in s:
        yield (i, e)
        i += 1

proc isNan(n: float): bool =
    return not (n > 0 or n < 0 or n == 0)

proc smoothedMax(s: seq[float]): float =
    let
        actualMax = s.max
        mid = s.high / 2

    for i, e in enumerate(s):
        var adj = (abs(mid - float(i)) + 1.0) / float(s.len) * 10.0
        result += max(e / adj, actualMax)

    result /= float(s.len)

proc drawStonk(w: RenderWindow, d: seq[float], m: float, c: tuple[x1: int, x2: int, y1: int,
        y2: int], f: Font, o: int, dT: bool, aM: float) =
    let
        l = d.len
        h = float(c.y2 - c.y1)
        widthAdjust = float(c.x2 - c.x1) / float(l)
        heightAdjust = h / m

    var vertices = newVertexArray(PrimitiveType.LineStrip, l)

    for i in 0..l-1:
        let xC = float(i) * widthAdjust + float(c.x1)
        vertices[i] = vertex(
            vec2(
                xC,
                h - d[i] * heightAdjust + float(c.y1)
            ),
            color(20, 255, 255)
        )

        if dT:
            var t = newText(&"{o + i + 1}", f, 12)
            t.position = vec2(xC, cfloat(c.y2) + 2)
            w.draw(t)
            t.destroy()

    let yTO = h/10.0

    for i in 0..9:
        var t = newText(&"{aM/10.0 * (10.0-i.float):.2f}", f, 10)
        t.position = vec2(cfloat(c.x1-18), cfloat(c.y1) + float(i) * yTO)
        w.draw(t)
        t.destroy()


    w.draw(vertices)
    vertices.destroy()

let
    stock = paramStr(1)
    stockPrices = block:
        let
            data = parseJson(readFile(stock))
            fields = block:
                var result: seq[JsonNode]
                for f in data.getFields().values:
                    result.add(f)
                result

        var
            result = newSeq[float]()
            started = false # should be false in prod
            i = 0

        for fNode in fields:
            var pF: float

            try: # dataset do be kinda shit tho
                pf = fNode.getFloat(fields[i-1].getFloat(fields[i-2].getFloat(fields[i-3].getFloat(-1.0))))
            except IndexDefect:
                pf = -1.0

            if isNan(pf) or pf <= 0.0:
                if started:
                    result.add(0)
            else:
                started = true
                result.add(pf)

            i += 1

        result
    stockPricesMax = stockPrices.max
    stockPricesLen = stockPrices.len

var
    ctxSettings = ContextSettings(antialiasingLevel: 16)
    window = newRenderWindow(videoMode(WINDOW_X, WINDOW_Y), &"Stock Price Visualization [{stock}]",
            WindowStyle.Default, ctxSettings)
    event: Event
    r = 0..stockPricesLen-1
    rOuter = 0..stockPricesLen-1
    fontRobotoBlack: Font = newFont("Roboto-Black.ttf")

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
    window.drawStonk(stockPrices, stockPricesMax, (20, int(WINDOW_X) - 20, 20, int(WINDOW_Y / 2) -
            20), fontRobotoBlack, 0, false, stockPricesMax)

    let
        mPos = window.mouse_getPosition
        mPosAX = int(float(stockPricesLen) / float(WINDOW_X) * float(mPos.x))

    try:
        r = max(mPosAX-15, 0)..min(mPosAX+14, stockPricesLen)
        rOuter = max(mPosAX-119, 0)..min(mPosAX+120, stockPricesLen)
        window.drawStonk(stockPrices[r], stockPrices[rOuter].smoothedMax, (20, int(WINDOW_X) - 20,
                int(WINDOW_Y / 2) + 20, int(WINDOW_Y) - 20), fontRobotoBlack, r.a, true,
                        stockPrices[r].max)
    except RangeDefect, IndexDefect:
        window.drawStonk(stockPrices, stockPricesMax, (20, int(WINDOW_X) - 20, int(WINDOW_Y / 2) +
                20, int(WINDOW_Y) - 20), fontRobotoBlack, 0, false, stockPricesMax)

    window.display()

fontRobotoBlack.destroy()
window.destroy()
