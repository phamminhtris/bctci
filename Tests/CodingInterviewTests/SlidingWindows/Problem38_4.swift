import Testing
@testable import CodingInterview

struct Problem38_4Tests {
    struct TestCase {
        let bestSellers: [String]
        let days: Int
        let expected: Bool
    }

    @Test(
        "Problem 38.4 - returns true when any k-day period has the same best seller",
        arguments: [
            TestCase(
                bestSellers: ["book3", "book1", "book3", "book3", "book2"],
                days: 2,
                expected: true
            ),
            TestCase(
                bestSellers: ["book1", "book1", "book1"],
                days: 3,
                expected: true
            ),
            TestCase(
                bestSellers: ["book1"],
                days: 1,
                expected: true
            ),
            TestCase(
                bestSellers: ["book1", "book2"],
                days: 1,
                expected: true
            ),
            TestCase(
                bestSellers: ["book1", "book2", "book2", "book2"],
                days: 3,
                expected: true
            ),
            TestCase(
                bestSellers: ["book1", "book1", "book2", "book3"],
                days: 2,
                expected: true
            ),
        ]
    )
    func testHasSameBestSellerPeriod(testCase: TestCase) {
        #expect(
            hasSameBestSellerPeriod(
                in: testCase.bestSellers,
                days: testCase.days
            ) == testCase.expected
        )
    }

    @Test(
        "Problem 38.4 - returns false when no k-day period has the same best seller",
        arguments: [
            TestCase(
                bestSellers: ["book3", "book1", "book3", "book3", "book2"],
                days: 3,
                expected: false
            ),
            TestCase(
                bestSellers: ["book1", "book2", "book1"],
                days: 2,
                expected: false
            ),
            TestCase(
                bestSellers: ["book1", "book2", "book3"],
                days: 3,
                expected: false
            ),
            TestCase(
                bestSellers: ["book1", "book1", "book2", "book2"],
                days: 3,
                expected: false
            ),
        ]
    )
    func testNoSameBestSellerPeriod(testCase: TestCase) {
        #expect(
            hasSameBestSellerPeriod(
                in: testCase.bestSellers,
                days: testCase.days
            ) == testCase.expected
        )
    }
}
