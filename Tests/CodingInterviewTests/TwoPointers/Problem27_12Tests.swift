import Testing
@testable import CodingInterview

struct Problem27_12Tests {
    struct TestCase {
        let arr: [Character]
        let expected: [Character]
    }

    @Test(
        "Problem 27.12 - reverses an array of letters in place",
        arguments: [
            TestCase(arr: ["h", "e", "l", "l", "o"], expected: ["o", "l", "l", "e", "h"]),
            TestCase(arr: ["a"], expected: ["a"]),
            TestCase(arr: [], expected: []),
        ]
    )
    func testReversesLettersInPlace(testCase: TestCase) {
        var arr = testCase.arr
        reverseLettersInPlace(&arr)
        #expect(arr == testCase.expected)
    }

    @Test("Problem 27.12 - reverses an even-length array")
    func testReversesEvenLengthArray() {
        var arr: [Character] = ["a", "b", "c", "d"]
        reverseLettersInPlace(&arr)
        #expect(arr == ["d", "c", "b", "a"])
    }
}
