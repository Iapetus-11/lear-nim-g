import csfml
import math
import sets
import os

const BACKGROUND_COLOR = color(30, 30, 40)

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

var
    window = newRenderWindow(videoMode(800, 800), "My Window")
    renderThread: system.Thread[void]

window.verticalSyncEnabled = true

proc drawBase() =
    window.clear(BACKGROUND_COLOR)

# prevents flickering on startup
drawBase()
window.display()

while window.open:
    var event: Event

    while window.pollEvent(event):
        case event.kind:
        of EventType.Closed: window.close()
        of EventType.KeyPressed:
            if event.key.code == KeyCode.Escape:
                window.close()
            else:
                echo event.key.code
        else: discard

        drawBase()

        for x in 0..799:
            for yI in 700..800:
                let y = math.sin(x.toFloat + yI.toFloat) * yI.toFloat

                let circle = newCircleShape()
                circle.radius = 1
                circle.position = vec2(x, y.toInt)

                window.draw(circle)

        window.display()


window.destroy()
