import std/[sets, os]
import csfml

const
    BACKGROUND_COLOR = color(30, 30, 40)
    WINDOW_TITLE = "Recaman's Sequence Render"

when defined windows:
    import winim/lean

    let windowX = (GetSystemMetrics(SM_CXSCREEN).toFloat() / 1.25).toInt
    let windowY = (GetSystemMetrics(SM_CYSCREEN).toFloat() / 1.25).toInt
else:
    let windowX = 800
    let windowY = 600

proc recaman(n: int): seq[int] =
    var already = [0].toHashset

    for i in 0..n-1:
        result.add(0)

    for i in 1..n-1:
        var c = result[i - 1] - i

        if c < 0 or (c in already):
            c = result[i - 1] + i
        
        result[i] = c
        already.incl(c)

let
    recamanNumbers = recaman(100_001)
    recamanMaxes = block:
        var
            result: seq[int]
            currentMax = 0

        for i in 0..recamanNumbers.high:
            if recamanNumbers[i] > currentMax:
                currentMax = recamanNumbers[i]

            result.add(currentMax)

        result

proc drawBase(w: RenderWindow) =
    w.clear(BACKGROUND_COLOR)

proc drawRecaman(w: RenderWindow, n: int) =
    var vertices = newVertexArray(PrimitiveType.LineStrip, n)
    let heightAdjust = windowY / recamanMaxes[n]

    for i in 0..n-1:
        vertices[i] = vertex(
            vec2(i.toFloat * (windowX / n), windowY.toFloat() - (recamanNumbers[i].toFloat() * heightAdjust)),
            color(toInt((n/i)), toInt((i*255)/n), 255)
        )

    w.draw(vertices)
    vertices.destroy()

var
    ctxSettings = ContextSettings(antialiasingLevel: 16)
    window = newRenderWindow(videoMode(cast[cint](windowX), cast[cint](windowY)), WINDOW_TITLE, WindowStyle.Default, ctxSettings)
    numFont = newFont("Roboto-Black.ttf")
    numText = newText("200 | " & $recamanNumbers[200], numFont, 40)

numText.position = vec2(10, 0)

# prevents flickering on startup
window.drawBase()
window.drawRecaman(200)
window.draw(numText)
window.display()

var
    n = 200
    doPlay = false
    doExit = false
    doSave = false

while window.open:
    var event: Event

    if doExit:
        window.close()
        break

    while window.pollEvent(event) or doPlay:
        case event.kind:
        of csfml.EventType.Closed: window.close()
        of csfml.EventType.KeyPressed:
            case event.key.code:
            of KeyCode.Escape:
                doExit = true
                break
            of KeyCode.Right:
                if n + 50 < recamanNumbers.len: n += 50
            of KeyCode.Left:
                if n > 50: n -= 50
            of KeyCode.R: n = 200
            of KeyCode.S: doSave = true
            of KeyCode.Space:
                doPlay = not doPlay
                sleep(100)
            else: discard
        else: discard

        if doPlay:
            if n == recamanNumbers.high:
                doPlay = false
            else:
                n += 1

        numText.str = $n & " | " & $recamanNumbers[n]

        window.drawBase()
        window.drawRecaman(n)
        window.draw(numText)

        if doSave:
            window.title = "saving..."
            discard window.capture().saveToFile("recamanRender.png")
            doSave = false
            window.title = WINDOW_TITLE

        window.display()


window.destroy()
numFont.destroy()
numText.destroy()
