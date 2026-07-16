import Testing

@testable import CodingInterview

struct Problem34_7Tests {
    struct TestCase {
        let input: [Int]
        let left: Int
        let right: Int
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
        "Problem 34.7 - reverses the nodes between left and right inclusive",
        arguments: [
            TestCase(input: [1, 2, 3, 4, 5], left: 1, right: 3, expected: [1, 4, 3, 2, 5]),
            TestCase(input: [1, 2, 3, 4, 5], left: 0, right: 4, expected: [5, 4, 3, 2, 1]),
            TestCase(input: [1, 2, 3], left: 1, right: 2, expected: [1, 3, 2]),
            TestCase(input: [1, 2], left: 0, right: 1, expected: [2, 1]),
        ]
    )
    func testReversesSection(testCase: TestCase) {
        let head = buildList(testCase.input)
        let result = reverseBetween(head, left: testCase.left, right: testCase.right)

        #expect(values(result) == testCase.expected)
    }

    @Test(
        "Problem 34.7 - reverses up to the last node when only right is out of bounds",
        arguments: [
            TestCase(input: [1, 2, 3, 4, 5], left: 2, right: 7, expected: [1, 2, 5, 4, 3]),
            TestCase(input: [7], left: 0, right: 3, expected: [7]),
        ]
    )
    func testClampsRight(testCase: TestCase) {
        let head = buildList(testCase.input)
        let result = reverseBetween(head, left: testCase.left, right: testCase.right)

        #expect(values(result) == testCase.expected)
    }

    @Test(
        "Problem 34.7 - leaves the list untouched when left is out of bounds",
        arguments: [
            TestCase(input: [1, 2], left: 5, right: 6, expected: [1, 2]),
            TestCase(input: [], left: 0, right: 2, expected: []),
        ]
    )
    func testLeftOutOfBounds(testCase: TestCase) {
        let head = buildList(testCase.input)
        let result = reverseBetween(head, left: testCase.left, right: testCase.right)

        #expect(values(result) == testCase.expected)
    }

    @Test("Problem 34.7 - reverses nodes in place")
    func testReversesInPlace() {
        let head = buildList([1, 2, 3, 4])!
        let second = head.next
        let third = head.next?.next
        let result = reverseBetween(head, left: 1, right: 2)

        #expect(result === head)
        #expect(result?.next === third)
        #expect(result?.next?.next === second)
        #expect(values(result) == [1, 3, 2, 4])
    }
}
