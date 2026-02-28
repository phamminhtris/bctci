
import Testing
@testable import CodingInterview

struct Problem31_6Tests {
    struct TestInput {
        let nums: [Int]
        let k: Int
        let expected: [Int]
    }

    @Test(
        "Problem 31.6 - kSmallest",
        arguments: [
            // Example 1
            TestInput(nums: [15, 4, 13, 8, 10, 5, 2, 20, 3, 9, 11, 27], k: 5, expected: [4, 3, 2, 5, 8]),
            // Example 2
            TestInput(nums: [5, 3, 1, 4, 2], k: 1, expected: [1]),
            // Example 3
            TestInput(nums: [5, 3, 1, 4, 2], k: 4, expected: [1, 2, 3, 4]),
            // k = 0
            TestInput(nums: [7, 6, 5], k: 0, expected: []),
            // k = n
            TestInput(nums: [10, -1, 3, 2], k: 4, expected: [-1, 2, 3, 10]),
            // negatives and zeros
            TestInput(nums: [-5, -10, 0, 7, -3], k: 3, expected: [-10, -5, -3]),
            // already ascending
            TestInput(nums: [1, 2, 3, 4], k: 2, expected: [1, 2]),
            // descending
            TestInput(nums: [4, 3, 2, 1], k: 2, expected: [1, 2]),
            // single element
            TestInput(nums: [42], k: 1, expected: [42]),
            // extremes
            TestInput(nums: [Int.max, 1, Int.min, 0], k: 2, expected: [Int.min, 0]),
        ]
    )
    func testKSmallest(testCase: TestInput) {
        let result = kSmallest(testCase.nums, k: testCase.k)
        // Order doesn't matter, so compare sorted results and size
        #expect(result.count == testCase.k)
        #expect(result.sorted() == testCase.expected.sorted())
    }
}
