import Testing
@testable import CodingInterview

struct Problem43_2Tests {
    struct TestCase {
        let likes: [Int]
        let dislikes: [Int]
        let periods: [[Int]]
        let expected: [Int]
    }

    @Test(
        "Problem 43.2 - returns positive day counts for each inclusive period",
        arguments: [
            TestCase(
                likes: [6, 3, 4, 8, 7, 2, 6, 5, 0, 1],
                dislikes: [6, 0, 8, 0, 0, 0, 1, 8, 0, 2],
                periods: [[0, 1], [0, 5], [5, 8], [3, 3]],
                expected: [1, 4, 2, 1]
            ),
            TestCase(
                likes: [1],
                dislikes: [0],
                periods: [[0, 0], [0, 0]],
                expected: [1, 1]
            ),
            TestCase(
                likes: [0],
                dislikes: [0],
                periods: [[0, 0]],
                expected: [0]
            ),
            TestCase(
                likes: [5, 4, 3, 2],
                dislikes: [1, 4, 4, 1],
                periods: [[0, 0], [1, 1], [0, 3], [2, 3]],
                expected: [1, 0, 2, 1]
            ),
        ]
    )
    func testPositiveDaysDuringPeriods(testCase: TestCase) {
        let actual = positiveDaysDuringPeriods(
            testCase.likes,
            dislikes: testCase.dislikes,
            periods: testCase.periods
        )

        #expect(actual == testCase.expected)
    }
}
