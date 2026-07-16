import Testing

@testable import CodingInterview

struct Problem32_6Tests {
    // Balanced-partitioning of a valid parentheses string.
    struct TestInput {
        let s: String
        let expected: Int
    }

    @Test("Problem 32.6 - maxBalancePartition", arguments: [
        // Prompt example.
        TestInput(s: "((()))(()())()(()(()))", expected: 4),
        // Already balanced and fully nested only.
        TestInput(s: "((()))", expected: 1),
        // Sequential pairs maximize one substring each.
        TestInput(s: "()()()", expected: 3),
        // Mixed nested and adjacent groups.
        TestInput(s: "(()())(())", expected: 2),
        // Empty input has zero balanced partitions.
        TestInput(s: "", expected: 0),
        // Multiple nested and adjacent transitions.
        TestInput(s: "((()))()((()))()()", expected: 5),
    ])
    func testMaxBalancePartition(testCase: TestInput) {
        #expect(maxBalancePartition(testCase.s) == testCase.expected)
    }
}
