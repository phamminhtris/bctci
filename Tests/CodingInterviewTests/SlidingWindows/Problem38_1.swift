import Testing
@testable import CodingInterview

struct Problem38_1Tests {
    struct TestCase {
        let sales: [Int]
        let expected: Int
    }

    @Test(
        "Problem 38.1 - returns highest sales across any 7-day period",
        arguments: [
            TestCase(
                sales: [0, 3, 7, 12, 10, 5, 0, 1, 0, 15, 12, 11, 1],
                expected: 44
            ),
            TestCase(
                sales: [1, 2, 3, 4, 5, 6, 7],
                expected: 28
            ),
            TestCase(
                sales: [9, 8, 7, 6, 5, 4, 3, 1, 1],
                expected: 42
            ),
            TestCase(
                sales: [1, 1, 2, 3, 4, 5, 6, 7],
                expected: 28
            ),
        ]
    )
    func testMostWeeklySales(testCase: TestCase) {
        #expect(mostWeeklySales(sales: testCase.sales) == testCase.expected)
    }

    @Test(
        "Problem 38.1 - returns zero when there is no 7-day period",
        arguments: [
            [] as [Int],
            [0, 3, 7, 12],
            [1, 2, 3, 4, 5, 6],
        ]
    )
    func testFewerThanSevenDays(sales: [Int]) {
        #expect(mostWeeklySales(sales: sales) == 0)
    }
}
