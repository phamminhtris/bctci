import Testing
@testable import CodingInterview

struct Problem27_6Tests {
    struct TestCase {
        let arr1: [Int]
        let arr2: [Int]
        let expected: [Int]
    }

    @Test(
        "Problem 27.6 - merges two non-empty sorted arrays including duplicates",
        arguments: [
            TestCase(arr1: [1, 3, 4, 5], arr2: [2, 4, 4], expected: [1, 2, 3, 4, 4, 4, 5]),
            TestCase(arr1: [1, 3, 5], arr2: [2, 4, 6], expected: [1, 2, 3, 4, 5, 6]),
            TestCase(arr1: [1, 2, 3], arr2: [4, 5, 6], expected: [1, 2, 3, 4, 5, 6]),
            TestCase(arr1: [4, 5, 6], arr2: [1, 2, 3], expected: [1, 2, 3, 4, 5, 6]),
            TestCase(arr1: [2, 2, 2], arr2: [2, 2], expected: [2, 2, 2, 2, 2]),
            TestCase(arr1: [-3, -1, 0], arr2: [-2, 5], expected: [-3, -2, -1, 0, 5]),
            TestCase(arr1: [7], arr2: [7], expected: [7, 7]),
            TestCase(arr1: [-1_000_000_000], arr2: [1_000_000_000], expected: [-1_000_000_000, 1_000_000_000]),
        ]
    )
    func testMergesNonEmptyArrays(testCase: TestCase) {
        #expect(mergeSortedArrays(testCase.arr1, testCase.arr2) == testCase.expected)
    }

    @Test(
        "Problem 27.6 - handles empty input arrays",
        arguments: [
            TestCase(arr1: [-1], arr2: [], expected: [-1]),
            TestCase(arr1: [], arr2: [2, 4, 4], expected: [2, 4, 4]),
            TestCase(arr1: [], arr2: [], expected: []),
        ]
    )
    func testEmptyArrays(testCase: TestCase) {
        #expect(mergeSortedArrays(testCase.arr1, testCase.arr2) == testCase.expected)
    }
}
