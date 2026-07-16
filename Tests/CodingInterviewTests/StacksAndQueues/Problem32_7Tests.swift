import Testing

@testable import CodingInterview

struct Problem32_7Tests {
    struct TestInput {
        let s: String
        let brackets: [String]
        let expected: Bool
    }

    @Test("Problem 32.7 - balanceCustomBrackets", arguments: [
        // Prompt examples.
        TestInput(
            s: "((a+b)*[c-d]-{e/f})",
            brackets: ["()", "[]", "{}"],
            expected: true
        ),
        TestInput(
            s: "()[}",
            brackets: ["()", "[]", "{}"],
            expected: false
        ),
        TestInput(
            s: "([)]",
            brackets: ["()", "[]", "{}"],
            expected: false
        ),
        TestInput(
            s: "<div> hello :) </div>",
            brackets: ["<>", "()"],
            expected: false
        ),
        TestInput(
            s: ")))(()((",
            brackets: [")("],
            expected: true
        ),
        // Non-bracket characters are ignored.
        TestInput(
            s: "abc123",
            brackets: ["()", "[]", "{}"],
            expected: true
        ),
        // Empty input has no unmatched brackets.
        TestInput(
            s: "",
            brackets: ["<>", "[]"],
            expected: true
        ),
        // Additional requested cases.
        TestInput(
            s: "",
            brackets: ["()"],
            expected: true
        ),
        TestInput(
            s: "(",
            brackets: ["()"],
            expected: false
        ),
        TestInput(
            s: "<<>>()[]{}",
            brackets: ["<>", "()", "[]", "{}"],
            expected: true
        ),
        TestInput(
            s: "[{()}]",
            brackets: ["()", "[]", "{}"],
            expected: true
        ),
        TestInput(
            s: "(()",
            brackets: ["()"],
            expected: false
        ),
        TestInput(
            s: "())",
            brackets: ["()"],
            expected: false
        ),
        TestInput(
            s: "({)}",
            brackets: ["()", "{}"],
            expected: false
        ),
        TestInput(
            s: "a(b)c[d]e",
            brackets: ["()", "[]"],
            expected: true
        ),
        TestInput(
            s: "<<>>",
            brackets: ["<>"],
            expected: true
        ),
    ])
    func testBalanceCustomBrackets(testCase: TestInput) {
        #expect(balanceCustomBrackets(s: testCase.s, brackets: testCase.brackets) == testCase.expected)
    }
}
