import Testing
@testable import CodingInterview

struct Problem38_5Tests {
    struct TestCase {
        let sales: [Int]
        let expected: Int
    }

    @Test(
        "Problem 38.5 - returns most consecutive days with no bad days",
        arguments: [
            TestCase(
                sales: [0, 14, 7, 12, 10, 20],
                expected: 3
            ),
            TestCase(
                sales: [10, 10, 10],
                expected: 3
            ),
            TestCase(
                sales: [5, 5, 5],
                expected: 0
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
                sales: [9, 10, 10, 9, 10],
                expected: 2
            ),
        ]
    )
    func testMostConsecutiveGoodDays(testCase: TestCase) {
        #expect(mostConsecutiveGoodDays(in: testCase.sales) == testCase.expected)
    }
}
