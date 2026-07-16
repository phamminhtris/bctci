import Testing
@testable import CodingInterview

struct Problem39_1Tests {
    struct TestCase {
        let grid: [[Int]]
        let expected: Int
    }

    @Test(
        "Problem 39.1 - returns maximum path sum from top-left to bottom-right",
        arguments: [
            TestCase(
                grid: [
                    [1, 4, 3],
                    [2, 7, 6],
                    [5, 8, 9],
                ],
                expected: 29
            ),
            TestCase(
                grid: [[5]],
                expected: 5
            ),
            TestCase(
                grid: [[1, 2, 3]],
                expected: 6
            ),
            TestCase(
                grid: [
                    [1],
                    [2],
                    [3],
                ],
                expected: 6
            ),
            TestCase(
                grid: [
                    [1, 2, 3],
                    [4, 5, 6],
                ],
                expected: 16
            ),
        ]
    )
    func testMaximumPathSum(testCase: TestCase) {
        #expect(maximumPathSum(in: testCase.grid) == testCase.expected)
    }

    @Test("Problem 39.1 - handles a larger grid")
    func testMaximumPathSumWithLargerGrid() {
        let size = 10
        let grid = (0..<size).map { row in
            (0..<size).map { column in
                row == 0 || column == size - 1 ? 10 : 1
            }
        }

        #expect(maximumPathSum(in: grid) == 190)
    }
}
