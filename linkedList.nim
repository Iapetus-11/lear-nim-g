type
    Node[T] = ref object of RootObj
        value: T
        next: Node[T]

    LinkedList[T] = ref object of RootObj
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

proc `$`[T](n: Node[T]): string =
    return "Node<" & repr(n.value) & ">"

proc `$`[T](l: LinkedList[T]): string =
    result = "LinkedList(["
    var count = 0

    for node in nodes(l):
        result &= $node & ", "
        count += 1
    
    if count > 0:
        result = result[0..result.high-2]

    return result & "])"

proc add[T](l: LinkedList[T], value: T) =
    let newNode = Node[T](value: value, next: nil)

    echo l.len

    if l.len == 0:
        l.head = newNode
    else:
        var last: Node[T]

        for node in nodes[T](l):
            last = node

        last.next = newNode

var list = LinkedList[char](head: nil)
echo list

list.add('1')
echo list

list.add('s')
echo list

list.add('u')
echo list

list.add('s')
echo list
