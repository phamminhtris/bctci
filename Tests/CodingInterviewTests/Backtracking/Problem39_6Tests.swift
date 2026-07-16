import Testing
@testable import CodingInterview

struct Problem39_6Tests {
    struct TestCase {
        let n: Int
        let expected: [Int]
    }

    @Test(
        "Problem 39.6 - returns jumping numbers smaller than n in ascending order",
        arguments: [
            TestCase(
                n: 34,
                expected: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 21, 23, 32]
            ),
            TestCase(
                n: 1,
                expected: []
            ),
            TestCase(
                n: 12,
                expected: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
            ),
            TestCase(
                n: 100,
                expected: [
                    1, 2, 3, 4, 5, 6, 7, 8, 9,
                    10, 12, 21, 23, 32, 34, 43, 45, 54, 56,
                    65, 67, 76, 78, 87, 89, 98,
                ]
            ),
        ]
    )
    func testJumpingNumbers(testCase: TestCase) {
        let actual = jumpingNumbers(smallerThan: testCase.n)

        #expect(actual == testCase.expected)
    }
}
