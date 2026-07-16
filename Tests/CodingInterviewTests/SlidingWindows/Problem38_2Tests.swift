import Testing
@testable import CodingInterview

struct Problem38_2Tests {
    struct TestCase {
        let sales: [Int]
        let days: Int
        let expected: Int
    }

    @Test(
        "Problem 38.2 - returns first day of highest k-day sales period",
        arguments: [
            TestCase(
                sales: [8, 1, 3, 7],
                days: 2,
                expected: 2
            ),
            TestCase(
                sales: [5, 10, 15, 5],
                days: 1,
                expected: 2
            ),
            TestCase(
                sales: [1, 2, 3],
                days: 3,
                expected: 0
            ),
            TestCase(
                sales: [9, 1, 1, 1],
                days: 2,
                expected: 0
            ),
            TestCase(
                sales: [1, 1, 9, 9],
                days: 2,
                expected: 2
            ),
            TestCase(
                sales: [4, 4, 1, 7, 1],
                days: 2,
                expected: 0
            ),
            TestCase(
                sales: [0, 0, 0],
                days: 1,
                expected: 0
            ),
        ]
    )
    func testMostSales(testCase: TestCase) {
        #expect(mostSales(in: testCase.sales, days: testCase.days) == testCase.expected)
    }
}
