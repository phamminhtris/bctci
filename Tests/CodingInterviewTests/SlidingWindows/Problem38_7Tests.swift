import Testing
@testable import CodingInterview

struct Problem38_7Tests {
    struct TestCase {
        let sales: [Int]
        let expected: Int
    }

    @Test(
        "Problem 38.7 - returns longest alternating good/bad-day sequence",
        arguments: [
            TestCase(
                sales: [8, 9, 20, 0, 9],
                expected: 3
            ),
            TestCase(
                sales: [0, 0, 0],
                expected: 1
            ),
            TestCase(
                sales: [5, 10, 5, 10],
                expected: 4
            ),
            TestCase(
                sales: [],
                expected: 0
            ),
            TestCase(
                sales: [10],
                expected: 1
            ),
            TestCase(
                sales: [9, 10],
                expected: 2
            ),
            TestCase(
                sales: [10, 10, 9],
                expected: 2
            ),
            TestCase(
                sales: [10, 10, 9, 10, 9, 9, 10],
                expected: 4
            ),
        ]
    )
    func testLongestAlternatingGoodBadDays(testCase: TestCase) {
        #expect(longestAlternatingGoodBadDays(in: testCase.sales) == testCase.expected)
    }
}
