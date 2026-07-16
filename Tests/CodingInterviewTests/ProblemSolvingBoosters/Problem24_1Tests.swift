import Testing
@testable import CodingInterview

struct Problem24_1Tests {
    struct TestCase {
        let arr: [Int]
        let target: Int
        let expected: Bool
    }

    @Test(
        "Problem 24.1 - returns whether any three distinct indices sum to target",
        arguments: [
            TestCase(
                arr: [4, 4, 5, -6, -4, 0],
                target: 4,
                expected: true
            ),
            TestCase(
                arr: [5, 0, 1],
                target: 5,
                expected: false
            ),
            TestCase(
                arr: [1, 1, 1],
                target: 3,
                expected: true
            ),
            TestCase(
                arr: [-7, 2, 9, -4, 1],
                target: -10,
                expected: true
            ),
            TestCase(
                arr: [1, 2, 4, 8],
                target: 100,
                expected: false
            ),
            TestCase(
                arr: [],
                target: 0,
                expected: false
            ),
            TestCase(
                arr: [0, 0],
                target: 0,
                expected: false
            ),
            TestCase(
                arr: [10_000_000, -10_000_000, 0],
                target: 0,
                expected: true
            ),
        ]
    )
    func testHasTripletSum(testCase: TestCase) {
        #expect(hasTripletSum(testCase.arr, target: testCase.target) == testCase.expected)
    }
}
