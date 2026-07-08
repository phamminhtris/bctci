import Testing
@testable import CodingInterview

struct Problem27_17Tests {
    // Move the prefix of length n/3 to the end, keeping the suffix order intact.
    struct TestInput {
        let arr: [Character]
        let expected: [Character]
    }

    static let cases: [TestInput] = [
        // Prompt example 1.
        TestInput(arr: ["b", "a", "d", "r", "e", "v", "i", "e", "w"], expected: ["r", "e", "v", "i", "e", "w", "b", "a", "d"]),
        // Prompt example 2.
        TestInput(arr: ["a", "b", "c"], expected: ["b", "c", "a"]),
        // Empty array.
        TestInput(arr: [], expected: []),
        // Longer length divisible by 3, all distinct letters.
        TestInput(arr: ["a", "b", "c", "d", "e", "f"], expected: ["c", "d", "e", "f", "a", "b"]),
        // Repeated letters within the prefix/suffix.
        TestInput(arr: ["a", "a", "b"], expected: ["a", "b", "a"]),
        // Every letter identical.
        TestInput(arr: ["x", "x", "x"], expected: ["x", "x", "x"]),
    ]

    @Test("Problem 27.17 - rotateLeftByThird", arguments: cases)
    func testRotateLeftByThird(testCase: TestInput) {
        var arr = testCase.arr
        rotateLeftByThird(&arr)
        #expect(arr == testCase.expected)
    }
}
