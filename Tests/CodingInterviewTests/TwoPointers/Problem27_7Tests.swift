import Testing
@testable import CodingInterview

struct Problem27_7Tests {
    struct TestCase {
        let arr: [Int]
        let expected: Bool
    }

    @Test(
        "Problem 27.7 - finds a pair of distinct indices summing to zero",
        arguments: [
            TestCase(arr: [-5, -2, -1, 1, 1, 10], expected: true),
            TestCase(arr: [-3, 0, 0, 1, 2], expected: true),
            TestCase(arr: [-2, 2], expected: true),
            TestCase(arr: [-1000000000, 5, 1000000000], expected: true),
        ]
    )
    func testFindsPair(testCase: TestCase) {
        #expect(hasZeroSumPair(testCase.arr) == testCase.expected)
    }

    @Test(
        "Problem 27.7 - reports false when no pair sums to zero",
        arguments: [
            TestCase(arr: [-5, -3, -1, 0, 2, 4, 6], expected: false),
            TestCase(arr: [], expected: false),
            TestCase(arr: [0], expected: false),
            TestCase(arr: [1, 2, 3], expected: false),
        ]
    )
    func testNoPair(testCase: TestCase) {
        #expect(hasZeroSumPair(testCase.arr) == testCase.expected)
    }
}
