import Testing
@testable import CodingInterview

struct Problem40_1Tests {
    struct TestCase {
        let times: [Int]
        let expected: Int
    }

    @Test(
        "Problem 40.1 - returns minimum detour time",
        arguments: [
            TestCase(
                times: [8, 1, 2, 3, 9, 6, 2, 4],
                expected: 6
            ),
            TestCase(
                times: [8, 1, 2, 3, 9, 3, 2, 4],
                expected: 5
            ),
            TestCase(
                times: [10, 10],
                expected: 0
            ),
            TestCase(
                times: [10],
                expected: 0
            ),
            TestCase(
                times: [],
                expected: 0
            ),
            TestCase(
                times: [7, 2, 5],
                expected: 2
            ),
            TestCase(
                times: [5, 4, 3, 2],
                expected: 3
            ),
        ]
    )
    func testMinimumDetourTime(testCase: TestCase) {
        let actual = minimumDetourTime(testCase.times)

        #expect(actual == testCase.expected)
    }
}
