import Testing
@testable import CodingInterview

struct Problem38_8Tests {
    struct TestCase {
        let sales: [Int]
        let expected: Int
    }

    @Test(
        "Problem 38.8 - returns most consecutive days with at most 3 bad days",
        arguments: [
            TestCase(
                sales: [0, 14, 7, 9, 0, 20, 10, 0, 10],
                expected: 6
            ),
            TestCase(
                sales: [10, 10, 10],
                expected: 3
            ),
            TestCase(
                sales: [5, 5, 5, 5],
                expected: 3
            ),
            TestCase(
                sales: [],
                expected: 0
            ),
            TestCase(
                sales: [5],
                expected: 1
            ),
            TestCase(
                sales: [10],
                expected: 1
            ),
            TestCase(
                sales: [5, 10, 5, 10, 5, 10, 5],
                expected: 6
            ),
        ]
    )
    func testMostConsecutiveDaysWithAtMostThreeBadDays(testCase: TestCase) {
        #expect(mostConsecutiveDaysWithAtMostThreeBadDays(in: testCase.sales) == testCase.expected)
    }
}
