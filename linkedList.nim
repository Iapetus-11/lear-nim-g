type
    Node[T] = ref object
        value: T
        next: Node[T]

    LinkedList[T] = ref object
        head: Node[T]

iterator nodes[T](l: LinkedList[T]): Node[T] =
    if l.head != nil:
        var node = l.head
        yield node
        node = node.next

        while node != nil:
            yield node
            node = node.next

proc len[T](l: LinkedList[T]): int =
    for n in nodes[T](l):
        result += 1

proc high[T](l: LinkedList[T]): int =
    return l.len - 1

proc nodeAt[T](l: LinkedList[T], index: int): Node[T] =
    var i = 0

    for n in nodes[T](l):
        if i == index:
            return n

        i += 1

proc `[]`[T](l: LinkedList[T], index: int): T =
    return l.nodeAt(index).value

proc `[]=`[T](l: LinkedList[T], index: int, value: T) =
    var i = 0

    for n in nodes[T](l):
        if i == index:
            n.value = value
            return

        i += 1

proc `$`[T](n: Node[T]): string =
    return "Node<" & repr(n.value) & ">"

proc `$`[T](l: LinkedList[T]): string =
    result = "LinkedList(["
    var count = 0

    for node in nodes[T](l):
        result &= $node & ", "
        count += 1

    if count > 0:
        result = result[0..result.high-2]

    return result & "])"

proc add[T](l: LinkedList[T], value: T) =
    let newNode = Node[T](value: value, next: nil)

    if l.len == 0:
        l.head = newNode
    else:
        var last: Node[T]

        for node in nodes[T](l):
            last = node

        last.next = newNode

proc delete[T](l: LinkedList[T], index: int) =
    if 0 > index or index > l.len:
        raise newException(IndexDefect, "Invalid index")

    if l.len == 0:
        raise newException(IndexDefect, "Can't delete an item from an empty LinkedList.")

    if l.len == 1:
        l.head = nil
    elif index == 0:
        l.head = l.nodeAt(1)
    elif index == l.high:
        l.nodeAt(l.high-1).next = nil
    else:
        l.nodeAt(index-1).next = l.nodeAt(index+1)

when isMainModule:
    import random
    randomize()

    var list = LinkedList[int](head: nil)

    for i in 0..20:
        list.add(rand(100))

    echo list

    list.delete(1)
    echo list

    list.delete(0)
    echo list

    list.delete(list.high)
    echo list
