import Testing

@testable import CodingInterview

struct Problem34_5Tests {
    struct CopyCase {
        let values: [Int]
    }

    private func buildList<T>(_ values: [T]) -> ListNode<T>? {
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

    private func values<T>(of node: ListNode<T>?) -> [T] {
        var curr = node
        var result: [T] = []

        while curr != nil {
            result.append(curr!.value)
            curr = curr?.next
        }

        return result
    }

    @Test(
        "Problem 34.5 - copyList clones values in order",
        arguments: [
            CopyCase(values: [1, 2, 3]),
            CopyCase(values: [10]),
            CopyCase(values: [0, -1, 0, 2]),
            CopyCase(values: [7, 7, 7])
        ]
    )
    func testCopyListValues(_ testCase: CopyCase) {
        let head = buildList(testCase.values)!
        let copied = copyList(head: head)

        #expect(values(of: copied) == testCase.values)
    }

    @Test("Problem 34.5 - copyList clones a one-node list")
    func testCopyListSingleNode() {
        let head = buildList([42])!
        let copied = copyList(head: head)

        #expect(values(of: copied) == [42])
    }

    @Test("Problem 34.5 - copyList handles generic values")
    func testCopyListGenericValues() {
        let head = buildList(["a", "b", "a"])
        let copied = copyList(head: head!)

        #expect(values(of: copied) == ["a", "b", "a"])
    }

    @Test("Problem 34.5 - copyList does not share node references with original")
    func testCopyListDeepCopy() {
        let input = [1, 2, 3]
        let head = buildList(input)!
        let copied = copyList(head: head)

        #expect(copied !== head)
        #expect(copied.next !== head.next)
        #expect(copied.next?.next !== head.next?.next)
    }

    @Test("Problem 34.5 - copyList mutation on original does not mutate copy")
    func testCopyListIndependence() {
        let head = buildList([1, 2, 3])!
        let copied = copyList(head: head)

        head.value = 99
        head.next?.value = 88

        #expect(values(of: head) == [99, 88, 3])
        #expect(values(of: copied) == [1, 2, 3])
    }
}
