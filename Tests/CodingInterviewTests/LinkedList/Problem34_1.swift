import Testing

@testable import CodingInterview

struct Problem34_1Tests {
    @Test("Problem 34.1 - pushFront updates size and popBack returns tail")
    func testPushFront() {
        let list = SinglyLinkList<Int>()

        list.pushFront(1)
        list.pushFront(2)
        list.pushFront(3)

        #expect(list.size == 3)
        #expect(list.popBack() == 1)
        #expect(list.size == 2)
        #expect(list.popBack() == 2)
        #expect(list.size == 1)
        #expect(list.popBack() == 3)
        #expect(list.size == 0)
    }

    @Test("Problem 34.1 - pushBack appends and popBack removes in reverse insert order")
    func testPushBack() {
        let list = SinglyLinkList<Int>()

        list.pushBack(1)
        list.pushBack(2)
        list.pushBack(3)

        #expect(list.size == 3)
        #expect(list.popBack() == 3)
        #expect(list.size == 2)
        #expect(list.popBack() == 2)
        #expect(list.size == 1)
        #expect(list.popBack() == 1)
        #expect(list.size == 0)
    }

    @Test("Problem 34.1 - popBack on empty list returns nil")
    func testPopBackEmptyList() {
        let list = SinglyLinkList<Int>()

        #expect(list.popBack() == nil)
        #expect(list.size == 0)
    }

    @Test("Problem 34.1 - popBack on single element clears list")
    func testPopBackSingleElement() {
        let list = SinglyLinkList<Int>()

        list.pushFront(10)
        let removed = list.popBack()
        let afterEmpty = list.popBack()

        #expect(removed == 10)
        #expect(afterEmpty == nil)
        #expect(list.size == 0)
    }

    struct ContainsCase {
        let values: [Int]
        let target: Int
        let expected: Bool
    }

    @Test(
        "Problem 34.1 - contains",
        arguments: [
            ContainsCase(values: [1, 2, 3], target: 2, expected: true),
            ContainsCase(values: [1, 2, 3], target: 4, expected: false),
            ContainsCase(values: [5, 7, 7, 9], target: 7, expected: true),
            ContainsCase(values: [8, 9], target: 8, expected: true),
            ContainsCase(values: [], target: 1, expected: false),
            ContainsCase(values: [0], target: 0, expected: true)
        ]
    )
    func testContains(_ testCase: ContainsCase) {
        let list = SinglyLinkList<Int>()
        for value in testCase.values {
            list.pushBack(value)
        }

        #expect(list.contains(testCase.target) == testCase.expected)
    }
}
