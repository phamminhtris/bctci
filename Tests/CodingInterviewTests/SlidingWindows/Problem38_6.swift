import Testing
@testable import CodingInterview

struct Problem38_6Tests {
    struct TestCase {
        let array: [Int]
        let expected: Int
    }

    @Test(
        "Problem 38.6 - returns maximum non-empty subarray sum",
        arguments: [
            TestCase(
                array: [1, 2, 3, -2, 1],
                expected: 6
            ),
            TestCase(
                array: [1, 2, 3, -2, 7],
                expected: 11
            ),
            TestCase(
                array: [1, 2, 3, -8, 7],
                expected: 7
            ),
            TestCase(
                array: [-2, -3, -4],
                expected: -2
            ),
            TestCase(
                array: [5],
                expected: 5
            ),
            TestCase(
                array: [-5],
                expected: -5
            ),
            TestCase(
                array: [-2, 1, -3, 4, -1, 2, 1, -5, 4],
                expected: 6
            ),
            TestCase(
                array: [0, -1, 0],
                expected: 0
            ),
        ]
    )
    func testMaxSubarraySum(testCase: TestCase) {
        #expect(maxSubarraySum(in: testCase.array) == testCase.expected)
    }
}
