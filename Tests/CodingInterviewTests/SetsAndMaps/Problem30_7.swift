import Testing
@testable import CodingInterview
/**
Implement a class, Checker, that receives a strings upon initialization. The class must support a method, expands_into(s2), which takes another string and checks if s2 can be formed by adding exactly one letter to s1 and reordering the letters. All letters in both strings are lowercase alphabetical characters.
*/
struct Problem30_7Tests {
    struct TestCase {
        let s: String
        let s2: String 
        let expected: Bool
    }

    @Test("ExpandInto", arguments: [
        TestCase(s: "tea", s2: "tea", expected: false),
        // s2 is a permutation with one extra letter
        TestCase(s: "abc", s2: "abdc", expected: true),
        // s2 has two extra letters (should be false)
        TestCase(s: "abc", s2: "abccd", expected: false),
        // s2 has same length but different letters (should be false)
        TestCase(s: "abc", s2: "abd", expected: false),
        // s1 empty, s2 more than one letter (should be false)
        TestCase(s: "", s2: "ab", expected: false),
        // repeated letters with one extra matching letter (should be true)
        TestCase(s: "aab", s2: "abaa", expected: true),
        TestCase(s: "tea", s2: "team", expected: true),
        TestCase(s: "tea", s2: "seam", expected: false),
        TestCase(s: "", s2: "t", expected: true),
        TestCase(s: "abc", s2: "ab", expected: false),
        TestCase(s: "aa", s2: "abb", expected: false),
    ])
    func expandsInto(testCase: TestCase) async throws {
        let checker = Checker(testCase.s)
        #expect(
            checker.expandsInto(testCase.s2)
                == testCase.expected
        )
    }

}