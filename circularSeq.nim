type CircleSeq[T] = ref object
    s: seq[T]

proc `[]`[T](s: CircleSeq[T], i: int): T =
    return s.s[i mod s.s.len]

proc `[]=`[T](s: CircleSeq[T], i: int, value: T) =
    s.s[i mod s.s.len] = value

proc add[T](s: CircleSeq[T], value: T) =
    s.s.add(value)

proc len[T](s: CircleSeq[T]): int =
    return s.s.len

proc `$`[T](s: CircleSeq[T]): string =
    return "CircleSeq(" & $s.s & ")"

proc initCircleSeq[T](): CircleSeq[T] =
    return CircleSeq[T](s: newSeq[T]())

when isMainModule:
    var s = initCircleSeq[char]()

    echo s

    s.add('a')
    s.add('b')
    s.add('c')
    s.add('D')

    echo s

    for i in 0..s.len*2:
        echo i, ": ", s[i]

