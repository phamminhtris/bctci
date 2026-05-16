import Testing
@testable import CodingInterview

struct Problem38_10Tests {
    struct TestCase {
        let projectedSales: [Int]
        let campaignDays: Int
        let expected: Int
    }

    @Test(
        "Problem 38.10 - returns maximum consecutive good days after 5-sale boosts",
        arguments: [
            TestCase(
                projectedSales: [8, 4, 8],
                campaignDays: 3,
                expected: 1
            ),
            TestCase(
                projectedSales: [10, 5, 8],
                campaignDays: 1,
                expected: 2
            ),
            TestCase(
                projectedSales: [8, 8, 8],
                campaignDays: 3,
                expected: 3
            ),
            TestCase(
                projectedSales: [],
                campaignDays: 0,
                expected: 0
            ),
            TestCase(
                projectedSales: [10, 10, 10],
                campaignDays: 0,
                expected: 3
            ),
            TestCase(
                projectedSales: [4, 5, 9, 10],
                campaignDays: 2,
                expected: 3
            ),
            TestCase(
                projectedSales: [4, 5, 9],
                campaignDays: 3,
                expected: 2
            ),
        ]
    )
    func testMaximumConsecutiveGoodDaysAfterFiveSaleBoosts(testCase: TestCase) {
        #expect(
            maximumConsecutiveGoodDaysAfterFiveSaleBoosts(
                in: testCase.projectedSales,
                campaignDays: testCase.campaignDays
            ) == testCase.expected
        )
    }
}
