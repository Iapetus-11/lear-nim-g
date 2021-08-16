import sequtils
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

var window = newRenderWindow(videoMode(800, 800), "My Window")
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

        let recamanNumbers = recaman(200)
        var vertexArray = newVertexArray(Lines)

        # i, 800-recamanNumbers[i]

        for i in 0..recamanNumbers.high:
            var ls = vertexArray[i]
            ls.position = vec2(i.toFloat, 800.0 - recamanNumbers[i].toFloat)
            ls.color = color(255, 0, 255)
            ls.texCoords = ls.position
            vertexArray[i] = ls

        window.draw(vertexArray)

        window.display()


window.destroy()
