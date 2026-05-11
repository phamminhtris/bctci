import Testing
@testable import CodingInterview

struct Problem37_1Tests {
    @Test("Problem 37.1 - empty heap returns nil and has zero size")
    func testEmptyHeap() {
        let heap = BinaryHeap<Int>(isHigherPriority: <)

        #expect(heap.size == 0)
        #expect(heap.top() == nil)
        #expect(heap.pop() == nil)
        #expect(heap.size == 0)
    }

    @Test("Problem 37.1 - min heap pops values in ascending order")
    func testMinHeapOrdering() {
        let heap = BinaryHeap<Int>(isHigherPriority: <)

        [5, 1, 9, 3, 7, 2].forEach { heap.push($0) }

        #expect(heap.size == 6)
        #expect(heap.top() == 1)
        #expect(popAll(from: heap) == [1, 2, 3, 5, 7, 9])
        #expect(heap.size == 0)
        #expect(heap.top() == nil)
    }

    @Test("Problem 37.1 - max heap pops values in descending order")
    func testMaxHeapOrdering() {
        let heap = BinaryHeap<Int>(isHigherPriority: >)

        [5, 1, 9, 3, 7, 2].forEach { heap.push($0) }

        #expect(heap.size == 6)
        #expect(heap.top() == 9)
        #expect(popAll(from: heap) == [9, 7, 5, 3, 2, 1])
        #expect(heap.size == 0)
    }

    @Test("Problem 37.1 - max heap handles duplicates and negative values")
    func testMaxHeapWithDuplicatesAndNegativeValues() {
        let heap = BinaryHeap<Int>(isHigherPriority: >)

        [0, -10, 4, 4, -1, Int.min, Int.max].forEach { heap.push($0) }

        #expect(heap.top() == Int.max)
        #expect(popAll(from: heap) == [Int.max, 4, 4, 0, -1, -10, Int.min])
        #expect(heap.pop() == nil)
    }

    @Test("Problem 37.1 - heap handles duplicate values")
    func testDuplicateValues() {
        let heap = BinaryHeap<Int>(isHigherPriority: <)

        [4, 1, 4, 2, 1].forEach { heap.push($0) }

        #expect(popAll(from: heap) == [1, 1, 2, 4, 4])
    }

    @Test("Problem 37.1 - top does not remove the value")
    func testTopDoesNotMutate() {
        let heap = BinaryHeap<Int>(isHigherPriority: <)

        heap.push(3)
        heap.push(1)

        #expect(heap.top() == 1)
        #expect(heap.top() == 1)
        #expect(heap.size == 2)
        #expect(heap.pop() == 1)
        #expect(heap.size == 1)
    }

    @Test("Problem 37.1 - single element pop clears heap")
    func testSingleElement() {
        let heap = BinaryHeap<Int>(isHigherPriority: <)

        heap.push(42)

        #expect(heap.size == 1)
        #expect(heap.top() == 42)
        #expect(heap.pop() == 42)
        #expect(heap.size == 0)
        #expect(heap.pop() == nil)
    }

    @Test("Problem 37.1 - heap can be reused after draining")
    func testPushAfterDraining() {
        let heap = BinaryHeap<Int>(isHigherPriority: <)

        [2, 1].forEach { heap.push($0) }
        #expect(popAll(from: heap) == [1, 2])

        [3, 0].forEach { heap.push($0) }
        #expect(heap.top() == 0)
        #expect(popAll(from: heap) == [0, 3])
    }

    @Test("Problem 37.1 - interleaved push and pop preserves ordering")
    func testInterleavedOperations() {
        let heap = BinaryHeap<Int>(isHigherPriority: <)

        [10, 4, 8].forEach { heap.push($0) }
        #expect(heap.pop() == 4)

        heap.push(3)
        heap.push(12)

        #expect(heap.pop() == 3)
        #expect(heap.top() == 8)
        #expect(heap.pop() == 8)

        heap.push(1)

        #expect(popAll(from: heap) == [1, 10, 12])
    }

    @Test("Problem 37.1 - min heap handles negative and extreme values")
    func testNegativeAndExtremeValues() {
        let heap = BinaryHeap<Int>(isHigherPriority: <)

        [0, -1, Int.max, Int.min, 5].forEach { heap.push($0) }

        #expect(popAll(from: heap) == [Int.min, -1, 0, 5, Int.max])
    }

    @Test("Problem 37.1 - heap supports other comparable types")
    func testStringValues() {
        let heap = BinaryHeap<String>(isHigherPriority: <)

        ["delta", "alpha", "charlie", "bravo"].forEach { heap.push($0) }

        #expect(popAll(from: heap) == ["alpha", "bravo", "charlie", "delta"])
    }

    @Test("Problem 37.1 - heap uses provided priority closure")
    func testCustomPriorityClosure() {
        let heap = BinaryHeap<Int> { abs($0) < abs($1) }

        [10, -1, 5, -2, 7].forEach { heap.push($0) }

        #expect(popAll(from: heap) == [-1, -2, 5, 7, 10])
    }

    private func popAll<T>(from heap: BinaryHeap<T>) -> [T] {
        var values: [T] = []

        while let value = heap.pop() {
            values.append(value)
        }

        return values
    }
}
