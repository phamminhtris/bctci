import Testing

@testable import CodingInterview

struct Problem34_6Tests {
    struct ReverseCase {
        let input: [Int]
        let expected: [Int]
    }

    private func buildList(_ values: [Int]) -> ListNode<Int>? {
        guard let first = values.first else {
            return nil
        }

        let head = ListNode(first)
        var curr = head
        for value in values.dropFirst() {
            curr.next = ListNode(value)
            curr = curr.next!
        }

        return head
    }

    private func values(_ node: ListNode<Int>?) -> [Int] {
        var curr = node
        var result: [Int] = []

        while let current = curr {
            result.append(current.value)
            curr = current.next
        }

        return result
    }

    @Test(
        "Problem 34.6 - revertList returns reversed values",
        arguments: [
            ReverseCase(input: [1, 2, 3], expected: [3, 2, 1]),
            ReverseCase(input: [10], expected: [10]),
            ReverseCase(input: [0, -1, 3, 0], expected: [0, 3, -1, 0]),
            ReverseCase(input: [5, 5, 5], expected: [5, 5, 5])
        ]
    )
    func testRevertListValues(_ testCase: ReverseCase) {
        let head = buildList(testCase.input)
        let reversed = revertList(head)

        #expect(values(reversed) == testCase.expected)
    }

    @Test("Problem 34.6 - revertList handles empty list")
    func testRevertListEmpty() {
        #expect(revertList(nil) == nil)
    }

    @Test("Problem 34.6 - revertList reverses nodes in place")
    func testRevertListInPlace() {
        let head = buildList([1, 2, 3])!
        let originalFirst = head
        let originalSecond = head.next
        let originalThird = head.next?.next
        let reversed = revertList(head)

        #expect(reversed === originalThird)
        #expect(reversed?.next === originalSecond)
        #expect(reversed?.next?.next === originalFirst)
        #expect(reversed?.next?.next?.next == nil)
        #expect(originalFirst.next == nil)
        #expect(values(reversed) == [3, 2, 1])
    }
}
