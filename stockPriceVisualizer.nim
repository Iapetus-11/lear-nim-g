import std/[strformat, os, json, strutils, tables]
import csfml

const
    BACKGROUND_COLOR = color(30, 30, 40)
    WINDOW_X: cint = 800
    WINDOW_Y: cint = 600

var
    ctxSettings = ContextSettings(antialiasingLevel: 16)
    window = newRenderWindow(videoMode(WINDOW_X, WINDOW_Y), "Stock Price Visualizer",
            settings = ctxSettings)
    stock = paramStr(1)
    stockData = parseJson(readFile(fmt"dump/{stock.toUpperAscii()}.json"))
    stockValues = block:
        let fields = stockData.getFields()
        var result = newSeq[float](fields.len)

        for p in fields.values:
            let pf = p.getFloat()

            if pf > 0:
                result.add(pf)
            else:
                result.add(0)

        result
    maxStockValue = stockValues.max
    lenStockValues = stockValues.len

window.verticalSyncEnabled = true

proc drawStonk(w: RenderWindow, d: seq[float]) =
    var vertices = newVertexArray(PrimitiveType.LineStrip, lenStockValues)

while window.open:
    var
        event: Event
        doExit = false

    if doExit:
        break

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

window.destroy()
