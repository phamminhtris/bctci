import Testing
@testable import CodingInterview

struct Problem27_2Tests {
    struct TestCase {
        let arr: [Int]
        let expected: Bool
    }

    @Test(
        "Problem 27.2 - validates prefix sum condition",
        arguments: [
            TestCase(arr: [1, 2, 2, -1], expected: true),
            TestCase(arr: [1, 2, -2, 1, 3, 5], expected: false),
            TestCase(arr: [1, 1], expected: true),
            TestCase(arr: [1, 0], expected: false),
            TestCase(arr: [-3, 1, 3, 10], expected: true),
            TestCase(arr: [4, -1, -10, 20], expected: false),
        ]
    )
    func testHasSmallerPrefixSums(testCase: TestCase) {
        #expect(hasSmallerPrefixSums(testCase.arr) == testCase.expected)
    }
}
