import Testing
@testable import CodingInterview

struct Problem38_3Tests {
    struct TestCase {
        let bestSellers: [String]
        let days: Int
        let expected: Bool
    }

    @Test(
        "Problem 38.3 - returns true when any k-day period has unique best sellers",
        arguments: [
            TestCase(
                bestSellers: ["book3", "book1", "book3", "book3", "book2", "book3", "book4", "book3"],
                days: 3,
                expected: true
            ),
            TestCase(
                bestSellers: ["book1", "book2", "book3"],
                days: 3,
                expected: true
            ),
            TestCase(
                bestSellers: ["book1"],
                days: 1,
                expected: true
            ),
            TestCase(
                bestSellers: ["book1", "book1", "book2", "book3"],
                days: 3,
                expected: true
            ),
        ]
    )
    func testHasUniqueBestSellerPeriod(testCase: TestCase) {
        #expect(
            hasUniqueBestSellerPeriod(
                in: testCase.bestSellers,
                days: testCase.days
            ) == testCase.expected
        )
    }

    @Test(
        "Problem 38.3 - returns false when no k-day period has unique best sellers",
        arguments: [
            TestCase(
                bestSellers: ["book3", "book1", "book3", "book3", "book2", "book3", "book4", "book3"],
                days: 4,
                expected: false
            ),
            TestCase(
                bestSellers: ["book1", "book1"],
                days: 2,
                expected: false
            ),
            TestCase(
                bestSellers: ["book1", "book2", "book1"],
                days: 3,
                expected: false
            ),
        ]
    )
    func testNoUniqueBestSellerPeriod(testCase: TestCase) {
        #expect(
            hasUniqueBestSellerPeriod(
                in: testCase.bestSellers,
                days: testCase.days
            ) == testCase.expected
        )
    }

    @Test(
        "Problem 38.3 - matches Python example cases",
        arguments: [
            TestCase(
                bestSellers: ["book3", "book1", "book3", "book3", "book2", "book3", "book4", "book3"],
                days: 3,
                expected: true
            ),
            TestCase(
                bestSellers: ["book3", "book1", "book3", "book3", "book2", "book3", "book4", "book3"],
                days: 4,
                expected: false
            ),
            TestCase(
                bestSellers: ["book1", "book2"],
                days: 1,
                expected: true
            ),
            TestCase(
                bestSellers: ["book1", "book2", "book3"],
                days: 3,
                expected: true
            ),
            TestCase(
                bestSellers: ["book1", "book1", "book1"],
                days: 2,
                expected: false
            ),
        ]
    )
    func testPythonExampleCases(testCase: TestCase) {
        #expect(
            hasUniqueBestSellerPeriod(
                in: testCase.bestSellers,
                days: testCase.days
            ) == testCase.expected
        )
    }
}
