import Testing
@testable import CodingInterview

struct Problem27_8Tests {
    struct TestCase {
        let arr1: [Int]
        let arr2: [Int]
        let arr3: [Int]
        let expected: [Int]
    }

    @Test(
        "Problem 27.8 - merges three sorted arrays and removes duplicates",
        arguments: [
            TestCase(
                arr1: [2, 3, 3, 4, 5, 7],
                arr2: [3, 3, 9],
                arr3: [3, 3, 9],
                expected: [2, 3, 4, 5, 7, 9]
            ),
            TestCase(
                arr1: [1, 2, 3],
                arr2: [2, 3, 4],
                arr3: [3, 4, 5],
                expected: [1, 2, 3, 4, 5]
            ),
            TestCase(
                arr1: [1, 1, 1, 1],
                arr2: [1, 1, 1],
                arr3: [1, 1],
                expected: [1]
            ),
        ]
    )
    func testMergesAndDedupes(testCase: TestCase) {
        #expect(
            mergeThreeSortedArraysUnique(testCase.arr1, testCase.arr2, testCase.arr3) == testCase.expected
        )
    }

    @Test(
        "Problem 27.8 - handles empty input arrays",
        arguments: [
            TestCase(arr1: [], arr2: [], arr3: [], expected: []),
            TestCase(arr1: [1, 2, 3], arr2: [], arr3: [], expected: [1, 2, 3]),
            TestCase(arr1: [], arr2: [2, 2, 5], arr3: [], expected: [2, 5]),
            TestCase(arr1: [], arr2: [], arr3: [4, 4, 6], expected: [4, 6]),
        ]
    )
    func testHandlesEmptyArrays(testCase: TestCase) {
        #expect(
            mergeThreeSortedArraysUnique(testCase.arr1, testCase.arr2, testCase.arr3) == testCase.expected
        )
    }

    @Test(
        "Problem 27.8 - handles negative values and boundary limits without duplicates"
    )
    func testHandlesNegativeAndBoundaryValues() {
        let result = mergeThreeSortedArraysUnique(
            [-1_000_000_000, -3, -3, 0],
            [-3, 0, 2],
            [-1_000_000_000, 1_000_000_000]
        )
        #expect(result == [-1_000_000_000, -3, 0, 2, 1_000_000_000])
    }
}
