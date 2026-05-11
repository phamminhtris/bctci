import Testing
@testable import CodingInterview

struct Problem37_1Tests {
    @Test("Problem 37.1 - empty heap returns nil and has zero size")
    func testEmptyHeap() {
        let heap = Heap<Int>(isHigherPriority: <)

        #expect(heap.size == 0)
        #expect(heap.top() == nil)
        #expect(heap.pop() == nil)
        #expect(heap.size == 0)
    }

    @Test("Problem 37.1 - min heap pops values in ascending order")
    func testMinHeapOrdering() {
        let heap = Heap<Int>(isHigherPriority: <)

        [5, 1, 9, 3, 7, 2].forEach { heap.push($0) }

        #expect(heap.size == 6)
        #expect(heap.top() == 1)
        #expect(popAll(from: heap) == [1, 2, 3, 5, 7, 9])
        #expect(heap.size == 0)
        #expect(heap.top() == nil)
    }

    @Test("Problem 37.1 - max heap pops values in descending order")
    func testMaxHeapOrdering() {
        let heap = Heap<Int>(isHigherPriority: >)

        [5, 1, 9, 3, 7, 2].forEach { heap.push($0) }

        #expect(heap.size == 6)
        #expect(heap.top() == 9)
        #expect(popAll(from: heap) == [9, 7, 5, 3, 2, 1])
        #expect(heap.size == 0)
    }

    @Test("Problem 37.1 - heap handles duplicate values")
    func testDuplicateValues() {
        let heap = Heap<Int>(isHigherPriority: <)

        [4, 1, 4, 2, 1].forEach { heap.push($0) }

        #expect(popAll(from: heap) == [1, 1, 2, 4, 4])
    }

    @Test("Problem 37.1 - top does not remove the value")
    func testTopDoesNotMutate() {
        let heap = Heap<Int>(isHigherPriority: <)

        heap.push(3)
        heap.push(1)

        #expect(heap.top() == 1)
        #expect(heap.top() == 1)
        #expect(heap.size == 2)
        #expect(heap.pop() == 1)
        #expect(heap.size == 1)
    }

    private func popAll(from heap: Heap<Int>) -> [Int] {
        var values: [Int] = []

        while let value = heap.pop() {
            values.append(value)
        }

        return values
    }
}
