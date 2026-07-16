import Testing
@testable import CodingInterview

struct Problem43_1Tests {
    struct TestCase {
        let views: [Int]
        let periods: [[Int]]
        let expected: [Int]
    }

    @Test(
        "Problem 43.1 - returns total views for each inclusive period",
        arguments: [
            TestCase(
                views: [3, 5, 4, 8, 7, 2, 5, 3, 2, 3],
                periods: [[0, 1], [0, 5], [5, 8], [3, 3]],
                expected: [8, 29, 12, 8]
            ),
            TestCase(
                views: [9],
                periods: [[0, 0], [0, 0]],
                expected: [9, 9]
            ),
            TestCase(
                views: [1, 2, 3, 4],
                periods: [[0, 0], [3, 3], [0, 3], [1, 2]],
                expected: [1, 4, 10, 5]
            ),
            TestCase(
                views: [0, 5, 0, 3],
                periods: [[0, 2], [2, 3], [0, 3]],
                expected: [5, 3, 8]
            ),
        ]
    )
    func testViewsDuringPeriods(testCase: TestCase) {
        let actual = viewsDuringPeriods(testCase.views, periods: testCase.periods)

        #expect(actual == testCase.expected)
    }
}
