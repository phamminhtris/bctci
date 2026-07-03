import Testing
@testable import CodingInterview

struct Problem27_3Tests {
    struct TestCase {
        let arr1: [Int]
        let arr2: [Int]
        let expected: [Int]
    }

    @Test(
        "Problem 27.3 - returns sorted intersection including duplicates",
        arguments: [
            TestCase(arr1: [1, 2, 3], arr2: [1, 3, 5], expected: [1, 3]),
            TestCase(arr1: [1, 1, 1], arr2: [1, 1], expected: [1, 1]),
            TestCase(arr1: [1, 2, 2, 3], arr2: [], expected: []),
            TestCase(arr1: [], arr2: [1, 2, 3], expected: []),
            TestCase(arr1: [1, 2, 2, 2, 4], arr2: [2, 2, 3, 4], expected: [2, 2, 4]),
            TestCase(arr1: [-3, -1, 0, 2], arr2: [-2, -1, 0, 0, 3], expected: [-1, 0]),
        ]
    )
    func testIntersectSortedArrays(testCase: TestCase) {
        #expect(intersectSortedArrays(testCase.arr1, testCase.arr2) == testCase.expected)
    }
}
