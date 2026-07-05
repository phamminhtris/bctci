import Testing
@testable import CodingInterview

struct Problem27_9Tests {
    struct TestCase {
        let arr: [Int]
        let expected: [Int]
    }

    @Test(
        "Problem 27.9 - sorts valley-shaped arrays",
        arguments: [
            TestCase(arr: [8, 4, 2, 6], expected: [2, 4, 6, 8]),
            TestCase(arr: [1, 2], expected: [1, 2]),
            TestCase(arr: [2, 2, 1, 1], expected: [1, 1, 2, 2]),
        ]
    )
    func testSortsValleyShapedArrays(testCase: TestCase) {
        #expect(sortValleyArray(testCase.arr) == testCase.expected)
    }

    @Test("Problem 27.9 - handles a flat valley of all duplicate values")
    func testHandlesAllDuplicateValues() {
        #expect(sortValleyArray([4, 4, 4, 4]) == [4, 4, 4, 4])
    }

    @Test("Problem 27.9 - handles negative and boundary magnitude values")
    func testHandlesNegativeAndBoundaryValues() {
        let result = sortValleyArray([1_000_000_000, 0, -1_000_000_000, 500_000_000, 1_000_000_000])
        #expect(result == [-1_000_000_000, 0, 500_000_000, 1_000_000_000, 1_000_000_000])
    }
}
