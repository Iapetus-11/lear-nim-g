import std/random; randomize()

type Maze = seq[seq[char]]

proc drawMaze(maze: Maze) =
    for y in 0..maze.high:
        for x in 0..maze[y].high:
            stdout.write(maze[y][x])

        stdout.writeLine("")

proc newMaze(sizeX: int, sizeY: int): Maze =  # blank spaces
    for x in 0..sizeX-1:
        result.add(newSeq[char]())
        for y in 0..sizeY-1:
            result[x].add('u')

proc countSurroundingCells(maze: Maze, wall: tuple[x: int, y: int]): int =
    result = 0

    if maze[wall.y-1][wall.x] == 'c':
        result += 1
    
    if maze[wall.y+1][wall.x] == 'c':
        result += 1

    if maze[wall.y][wall.x-1] == 'c':
        result += 1

    if maze[wall.y][wall.x+1] == 'c':
        result += 1

proc doMaze(sizeX: int, sizeY: int) =
    var maze = newMaze(sizeX, sizeY)
    var walls: seq[tuple[x: int, y: int]]

    let start = (x: 2, y: maze.high-1)

    walls.add((start.y-1, start.x))
    walls.add((start.y, start.x-1))
    walls.add((start.y, start.x+1))
    walls.add((start.y+1, start.x))

    maze[start.y-1][start.x] = 'w'
    maze[start.y][start.x-1] = 'w'
    maze[start.y][start.x+1] = 'w'
    maze[start.y+1][start.x] = 'w'

    proc addWall(wall: tuple[x: int, y: int]) =
        if countSurroundingCells(maze, wall) < 2:
            maze[wall.y][wall.x] = 'c'

            if wall.y != 0:
                if maze[wall.y-1][wall.x] != 'c':
                    maze[wall.y-1][wall.x] = 'w'

                if not walls.contains((x: wall.x, y: wall.y-1)):
                    walls.add((x: wall.x, y: wall.y-1))

    while walls.len > 0:
        let randomWall = walls[(rand(100).toFloat/100.0 * walls.high.toFloat).toInt]
        echo randomWall

        if randomWall.x != 0:
            if maze[randomWall.y][randomWall.x-1] == 'u' and maze[randomWall.y-1][randomWall.x] == 'c':
                addWall(randomWall)
                walls.delete(walls.find(randomWall))
            
            continue

        if randomWall.y != 0:
            if maze[randomWall.y-1][randomWall.x] == 'u' and maze[randomWall.y+1][randomWall.x+1] == 'c':
                addWall(randomWall)
                walls.delete(walls.find(randomWall))
            
            continue

        if randomWall.y != maze.high:
            if maze[randomWall.y+1][randomWall.x] == 'u' and maze[randomWall.y-1][randomWall.x] == 'c':
                addWall(randomWall)
                walls.delete(walls.find(randomWall))
            
            continue

        if randomWall.x != maze[0].high:
            if maze[randomWall.y][randomWall.x+1] == 'u' and maze[randomWall.y][randomWall.x-1] == 'c':
                addWall(randomWall)
                walls.delete(walls.find(randomWall))
            
            continue

    for y in 0..sizeY-1:
        for x in 0..sizeX-1:
            if maze[y][x] == 'u':
                maze[y][x] = 'w'

    drawMaze(maze)







    drawMaze(maze)
    

doMaze(10, 30)
