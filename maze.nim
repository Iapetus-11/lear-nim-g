import random; randomize()
# import csfml

# const BACKGROUND_COLOR = color(30, 30, 40)
# const WINDOW_X = 800
# const WINDOW_Y = 600

# var ctxSettings = ContextSettings()
# ctxSettings.antialiasingLevel = 16

# var window = newRenderWindow(videoMode(WINDOW_X, WINDOW_Y), "My Window", settings=ctxSettings)
# window.verticalSyncEnabled = true

proc doMaze(sizeX: int, sizeY: int) =
    var maze = newSeq[seq[bool]]()

    for x in 0..sizeX-1:
        maze.add(newSeq[bool]())

        for y in 0..sizeY-1:
            maze[x].add(rand(100)/100 > 0.4)

    for x in 0..sizeX-1:
        for y in 0..sizeY-1:
            var o = " "
            
            if maze[x][y]:
                o = "█"

            stdout.write(o)
        stdout.writeLine("")

doMaze(20, 40)

# while window.open:
#     var event: Event

#     while window.pollEvent(event):
#         case event.kind:
#         of EventType.Closed: window.close()
#         of EventType.KeyPressed:
#             if event.key.code == KeyCode.Escape:
#                 window.close()
#             else:
#                 echo event.key.code
#         else: discard

# window.destroy()
