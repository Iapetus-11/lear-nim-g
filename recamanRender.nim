import csfml
import sets
import os

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
    window = newRenderWindow(videoMode(800, 600), "My Window")
    renderThread: Thread[void]

window.verticalSyncEnabled = true

proc renderInThread() =
    {.gcsafe.}:
        while window.open:
            # draw
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

    window.clear(color(25, 25, 25))
    window.display()


window.destroy()
