import Testing
@testable import CodingInterview

struct Problem27_5Tests {
    struct TestCase {
        let s: String
        let expected: Bool
    }

    @Test(
        "Problem 27.5 - matches when reversed uppercase letters equal the lowercase letters",
        arguments: [
            TestCase(s: "haDrRAHd", expected: true),
            TestCase(s: "BbbB", expected: true),
            TestCase(s: "cTaAtC", expected: true),
            TestCase(s: "", expected: true),
            TestCase(s: "aA", expected: true),
            TestCase(s: "Aa", expected: true),
            TestCase(s: "abBA", expected: true),
        ]
    )
    func testMatches(testCase: TestCase) {
        #expect(isReversedCaseMatch(testCase.s) == testCase.expected)
    }

    @Test(
        "Problem 27.5 - rejects when reversed uppercase letters do not equal the lowercase letters",
        arguments: [
            TestCase(s: "haHrARDd", expected: false),
            TestCase(s: "cTaCtA", expected: false),
            TestCase(s: "abAB", expected: false),
            TestCase(s: "helloworldHELLOWORLD", expected: false),
        ]
    )
    func testMismatches(testCase: TestCase) {
        #expect(isReversedCaseMatch(testCase.s) == testCase.expected)
    }
}
