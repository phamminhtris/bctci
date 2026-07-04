import Testing
@testable import CodingInterview

struct Problem27_4Tests {
    struct TestCase {
        let s: String
        let expected: Bool
    }

    @Test(
        "Problem 27.4 - identifies letter palindromes ignoring punctuation spaces and case",
        arguments: [
            TestCase(s: "Bob wondered, 'Now, Bob?'", expected: true),
            TestCase(s: "A man, a plan, a canal: Panama!", expected: true),
            TestCase(s: "No 'x' in Nixon", expected: true),
            TestCase(s: "", expected: true),
            TestCase(s: "1234 !?", expected: true),
            TestCase(s: "Z", expected: true),
        ]
    )
    func testLetterPalindromes(testCase: TestCase) {
        #expect(isLetterPalindrome(testCase.s) == testCase.expected)
    }

    @Test(
        "Problem 27.4 - rejects non-palindromes after filtering letters",
        arguments: [
            TestCase(s: "race a car", expected: false),
            TestCase(s: "hello", expected: false),
            TestCase(s: "Palindrome? No.", expected: false),
        ]
    )
    func testNonPalindromes(testCase: TestCase) {
        #expect(isLetterPalindrome(testCase.s) == testCase.expected)
    }
}
