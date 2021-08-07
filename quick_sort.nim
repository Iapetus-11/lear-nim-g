
proc swap(arr: var openArray[int], i: int, j: int) {.discardable.} =
    let temp: int = arr[i]
    arr[i] = arr[j]
    arr[j] = temp

proc partition(arr: var openArray[int], iLow: int, iHigh: int): int =
    let pivot: int = arr[iHigh]
    var i: int = iLow - 1

    for j in iLow..(iHigh-1):
        if (arr[j] < pivot):
            i += 1
            swap(arr, i, j)
        
    swap(arr, i + 1, iHigh)
    return i + 1

proc quickSort(arr: var openArray[int], iLow: int, iHigh: int) {.discardable.} =
    if iLow < iHigh:
        let pIndex: int = partition(arr, iLow, iHigh)

        quickSort(arr, iLow, pIndex - 1)
        quickSort(arr, pIndex + 1, iHigh)

when isMainModule:
    var arr = [1, 5, 9, 6, 2, 1, 4, 12, 11, 3, 7]
    echo arr
    quickSort(arr, 0, arr.len - 1)
    echo arr
