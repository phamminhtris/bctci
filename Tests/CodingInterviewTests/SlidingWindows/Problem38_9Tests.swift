import Testing
@testable import CodingInterview

struct Problem38_9Tests {
    struct TestCase {
        let projectedSales: [Int]
        let campaignDays: Int
        let expected: Int
    }

    @Test(
        "Problem 38.9 - returns maximum consecutive good days after campaign boosts",
        arguments: [
            TestCase(
                projectedSales: [5, 0, 20, 0, 5],
                campaignDays: 2,
                expected: 3
            ),
            TestCase(
                projectedSales: [0, 10, 0, 10],
                campaignDays: 1,
                expected: 3
            ),
            TestCase(
                projectedSales: [5, 5, 5],
                campaignDays: 3,
                expected: 3
            ),
            TestCase(
                projectedSales: [10, 10, 10],
                campaignDays: 1,
                expected: 3
            ),
            TestCase(
                projectedSales: [9],
                campaignDays: 1,
                expected: 1
            ),
            TestCase(
                projectedSales: [9, 10, 9],
                campaignDays: 1,
                expected: 2
            ),
            TestCase(
                projectedSales: [5, 10, 5, 10, 5],
                campaignDays: 2,
                expected: 4
            ),
        ]
    )
    func testMaximumConsecutiveGoodDaysAfterCampaign(testCase: TestCase) {
        #expect(
            maximumConsecutiveGoodDaysAfterCampaign(
                in: testCase.projectedSales,
                campaignDays: testCase.campaignDays
            ) == testCase.expected
        )
    }
}
