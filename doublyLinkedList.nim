
type
    Node[T] = ref object
        value: T
        prev: ptr Node[T]
        next: ptr Node[T]
