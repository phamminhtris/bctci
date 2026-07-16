import Testing
@testable import CodingInterview

struct Problem27_15Tests {
    func isValidPartition(_ arr: [Int], pivot: Int) -> Bool {
        var seenEqual = false
        var seenGreater = false
        for x in arr {
            if x < pivot {
                if seenEqual || seenGreater { return false }
            } else if x == pivot {
                if seenGreater { return false }
                seenEqual = true
            } else {
                seenGreater = true
            }
        }
        return true
    }

    @Test func example1() {
        var arr = [1, 7, 2, 3, 3, 5, 3]
        let original = arr.sorted()
        quickSortPartition(&arr, pivot: 4)
        #expect(isValidPartition(arr, pivot: 4))
        #expect(arr.sorted() == original)
    }

    @Test func example2() {
        var arr = [1, 7, 2, 3, 3, 5, 3]
        let original = arr.sorted()
        quickSortPartition(&arr, pivot: 3)
        #expect(isValidPartition(arr, pivot: 3))
        #expect(arr.sorted() == original)
    }

    @Test func emptyArray() {
        var arr: [Int] = []
        quickSortPartition(&arr, pivot: 5)
        #expect(arr.isEmpty)
    }

    @Test func singleElement() {
        var arr = [42]
        quickSortPartition(&arr, pivot: 42)
        #expect(arr == [42])
    }

    @Test func allEqualToPivot() {
        var arr = [3, 3, 3, 3]
        quickSortPartition(&arr, pivot: 3)
        #expect(isValidPartition(arr, pivot: 3))
        #expect(arr.sorted() == [3, 3, 3, 3])
    }

    @Test func allLessThanPivot() {
        var arr = [1, 2, 3, 4]
        quickSortPartition(&arr, pivot: 10)
        #expect(isValidPartition(arr, pivot: 10))
        #expect(arr.sorted() == [1, 2, 3, 4])
    }

    @Test func allGreaterThanPivot() {
        var arr = [5, 6, 7, 8]
        quickSortPartition(&arr, pivot: 1)
        #expect(isValidPartition(arr, pivot: 1))
        #expect(arr.sorted() == [5, 6, 7, 8])
    }
}
