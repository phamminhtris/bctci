import Testing
@testable import CodingInterview

struct Problem27_18Tests {
    // Move the earliest subsequence spelling word to the end, preserving relative order of both groups.
    struct TestInput {
        let arr: [Character]
        let word: String
        let expected: [Character]
    }

    static let cases: [TestInput] = [
        // Prompt example 1.
        TestInput(
            arr: ["s", "e", "e", "k", "e", "r", "a", "n", "d", "w", "r", "i", "t", "e", "r"],
            word: "edit",
            expected: ["s", "e", "k", "e", "r", "a", "n", "w", "r", "e", "r", "e", "d", "i", "t"]
        ),
        // Prompt example 2: earliest 'a' comes after the first 'b', so only that 'b' stays behind.
        TestInput(arr: ["b", "a", "c", "b"], word: "ab", expected: ["b", "c", "a", "b"]),
        // Prompt example 3: single-letter word still targets the earliest match, not any match.
        TestInput(arr: ["b", "a", "b", "c"], word: "b", expected: ["a", "b", "c", "b"]),
        // Empty array and empty word.
        TestInput(arr: [], word: "", expected: []),
        // Empty word leaves a non-empty array untouched.
        TestInput(arr: ["x", "y", "z"], word: "", expected: ["x", "y", "z"]),
        // word spans the entire array, so moving it to the end is a no-op.
        TestInput(arr: ["a", "b", "c"], word: "abc", expected: ["a", "b", "c"]),
        // Single-character array and word.
        TestInput(arr: ["a"], word: "a", expected: ["a"]),
        // Repeated letters throughout, earliest match must be picked greedily left to right.
        TestInput(arr: ["a", "b", "a", "b", "c"], word: "ac", expected: ["b", "a", "b", "a", "c"]),
    ]

    @Test("Problem 27.18 - moveEarliestSubsequenceToEnd", arguments: cases)
    func testMoveEarliestSubsequenceToEnd(testCase: TestInput) {
        var arr = testCase.arr
        moveEarliestSubsequenceToEnd(&arr, word: testCase.word)
        #expect(arr == testCase.expected)
    }
}
