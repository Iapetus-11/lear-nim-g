import std/random; randomize()

proc doSomething(x: int) {.thread.} =
    let a = rand(100) + x
    echo a

proc main() =
    var threads: array[3, Thread[int]]

    for i in 0..threads.high:
        createThread(threads[i], doSomething, 1)

    joinThreads(threads)


when isMainModule:
    main()
