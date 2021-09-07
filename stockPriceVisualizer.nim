import std/[strformat, os, json, strutils, tables]
import csfml

const
    BACKGROUND_COLOR = color(30, 30, 40)
    WINDOW_X: cint = 800
    WINDOW_Y: cint = 600

proc isNan(n: float): bool =
    return not (n > 0 or n < 0 or n == 0)

let
    stock = paramStr(1).toUpperAscii()
    stockPrices = block:
        let
            data = parseJson(readFile(&"dump/{stock.toUpperAscii()}.json"))
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
    ctxSettings = ContextSettings(antialiasingLevel: 16)
    window = newRenderWindow(videoMode(WINDOW_X, WINDOW_Y), "My Window", settings = ctxSettings)

window.verticalSyncEnabled = true

var
    event: Event

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
            else:
                echo event.key.code
        else: discard

    window.clear(BACKGROUND_COLOR)
    window.display()

window.destroy()
