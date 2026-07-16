import Testing
@testable import CodingInterview

struct Problem27_14Tests {
    struct TestCase {
        let arr: [Int]
        let expectedCount: Int
        let expectedPrefix: [Int]
    }

    @Test(
        "Problem 27.14 - removes duplicates in place and returns the unique count",
        arguments: [
            TestCase(arr: [1, 2, 2, 3, 3, 3, 5], expectedCount: 4, expectedPrefix: [1, 2, 3, 5]),
            TestCase(arr: [], expectedCount: 0, expectedPrefix: []),
            TestCase(arr: [1, 1, 1], expectedCount: 1, expectedPrefix: [1]),
        ]
    )
    func testRemovesDuplicatesInPlace(testCase: TestCase) {
        var arr = testCase.arr
        let count = removeDuplicatesInPlace(&arr)
        #expect(count == testCase.expectedCount)
        #expect(Array(arr.prefix(count)) == testCase.expectedPrefix)
    }

    @Test("Problem 27.14 - handles an array with no duplicates")
    func testHandlesArrayWithNoDuplicates() {
        var arr = [1, 2, 3, 4]
        let count = removeDuplicatesInPlace(&arr)
        #expect(count == 4)
        #expect(Array(arr.prefix(count)) == [1, 2, 3, 4])
    }

    @Test("Problem 27.14 - handles negative values mixed with duplicates")
    func testHandlesNegativeValues() {
        var arr = [-5, -5, -2, 0, 0, 3]
        let count = removeDuplicatesInPlace(&arr)
        #expect(count == 4)
        #expect(Array(arr.prefix(count)) == [-5, -2, 0, 3])
    }
}
