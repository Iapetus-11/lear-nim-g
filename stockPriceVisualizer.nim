import std/[strformat, os, json, strutils, tables]
import csfml

const
    BACKGROUND_COLOR = color(30, 30, 40)
    WINDOW_X: cint = 800
    WINDOW_Y: cint = 600

proc isNan(n: float): bool =
    return not (n > 0 or n < 0 or n == 0)

proc drawStonk(w: RenderWindow, d: seq[float], m: float, y1: int, y2: int) =
    let
        l = d.len
        m = d.max
        widthAdjust = float(WINDOW_X) / float(l)
        heightAdjust = float(y2) / m

    var
        vertices = newVertexArray(PrimitiveType.LineStrip, l)

    for i in 0..l-1:
        vertices[i] = vertex(
            vec2(float(i) * widthAdjust, float(WINDOW_Y) - (float(y1) + d[i] * heightAdjust)),
            color(10, 115, 255)
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
            started = false

        for p in fields.values:
            let pf = p.getFloat()

            if (isNan(pf) or pf == 0.0) and started:
                result.add(0)
            else:
                started = true
                result.add(pf)

        result
    stockPricesMax = stockPrices.max

var
    ctxSettings = ContextSettings(antialiasingLevel: 16)
    window = newRenderWindow(videoMode(WINDOW_X, WINDOW_Y), &"Stock Price Visualization [{stock}]", WindowStyle.Default, ctxSettings)
    event: Event

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
    window.drawStonk(stockPrices, stockPricesMax, 10, 200)
    window.display()

window.destroy()
