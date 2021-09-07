import std/[strformat, os, json, strutils, tables]
import csfml

const
    BACKGROUND_COLOR = color(30, 30, 40)
    WINDOW_X: cint = 1080
    WINDOW_Y: cint = 796

proc isNan(n: float): bool =
    return not (n > 0 or n < 0 or n == 0)

var
    stock = paramStr(1)
    stockData = parseJson(readFile(fmt"dump/{stock.toUpperAscii()}.json"))
    stockValues = block:
        let fields = stockData.getFields()
        var
            result = newSeq[float]()
            started = false

        for p in fields.values:
            let pf = p.getFloat()

            if isNan(pf) or pf == 0.0:
                if started:
                    result.add(0)
            else:
                started = true
                result.add(pf)

        result
    maxStockValue = stockValues.max
    lenStockValues = stockValues.len
    heightAdjust = float(WINDOW_Y - 40) / maxStockValue / 2
    ctxSettings = ContextSettings(antialiasingLevel: 16)
    window = newRenderWindow(videoMode(WINDOW_X, WINDOW_Y), &"Stock Price Visualizer [{stock}]",
            settings = ctxSettings)

window.verticalSyncEnabled = true

proc drawStonk(w: RenderWindow, d: seq[float], yO: float) =
    let l = d.len
    let widthAdjust = float(WINDOW_X - 40) / float(l)
    var vertices = newVertexArray(PrimitiveType.LineStrip, l)

    for i in 0..l-1:
        vertices[i] = vertex(
            vec2(float(i) * widthAdjust + 20.0, float(WINDOW_Y) / 2.0 - (d[i] * heightAdjust) + yO),
            color(10, 115, 225)
        )

    window.draw(vertices)
    vertices.destroy()

var r = 0..lenStockValues-1

while window.open:
    var event: Event

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
                else: discard
        else: discard

    let mPos = window.mouse_getPosition

    if mPos.x < 0 or mPos.x > WINDOW_X:
        r = 0..lenStockValues-1
    else:
        r = max([int(mPos.x)-14, 0])..min([int(mPos.x)+15, WINDOW_X])

    window.clear(BACKGROUND_COLOR)
    window.drawStonk(stockValues, 0)
    window.drawStonk(stockValues[r], float(WINDOW_Y) / 2.0)
    window.display()

window.destroy()
