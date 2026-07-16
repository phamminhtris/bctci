import Testing
@testable import CodingInterview

struct Problem27_1Tests {
    struct TestCase {
        let s: String
        let expected: Bool
    }

    @Test(
        "Problem 27.1 - identifies palindromes",
        arguments: [
            TestCase(s: "level", expected: true),
            TestCase(s: "naan", expected: true),
            TestCase(s: "a", expected: true),
            TestCase(s: "", expected: true),
            TestCase(s: "abccba", expected: true),
        ]
    )
    func testPalindromes(testCase: TestCase) {
        #expect(isPalindrome(testCase.s) == testCase.expected)
    }

    @Test(
        "Problem 27.1 - rejects non-palindromes",
        arguments: [
            TestCase(s: "hello", expected: false),
            TestCase(s: "ab", expected: false),
            TestCase(s: "abcaba", expected: false),
        ]
    )
    func testNonPalindromes(testCase: TestCase) {
        #expect(isPalindrome(testCase.s) == testCase.expected)
    }
}
