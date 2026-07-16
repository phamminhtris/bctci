import Testing
@testable import CodingInterview

struct Problem27_16Tests {
    // In-place sort of 'R'/'W'/'B' characters into red, white, blue order.
    struct TestInput {
        let arr: [Character]
        let expected: [Character]
    }

    static let cases: [TestInput] = [
        // Prompt example 1.
        TestInput(arr: ["R", "W", "B", "B", "W", "R", "W"], expected: ["R", "R", "W", "W", "W", "B", "B"]),
        // Prompt example 2.
        TestInput(arr: ["B", "R"], expected: ["R", "B"]),
        // Empty array.
        TestInput(arr: [], expected: []),
        // Single element of each color.
        TestInput(arr: ["R"], expected: ["R"]),
        TestInput(arr: ["W"], expected: ["W"]),
        TestInput(arr: ["B"], expected: ["B"]),
        // Already sorted.
        TestInput(arr: ["R", "R", "W", "W", "B", "B"], expected: ["R", "R", "W", "W", "B", "B"]),
        // Reverse sorted.
        TestInput(arr: ["B", "B", "W", "W", "R", "R"], expected: ["R", "R", "W", "W", "B", "B"]),
        // All the same color.
        TestInput(arr: ["W", "W", "W"], expected: ["W", "W", "W"]),
        // Only two of the three colors present.
        TestInput(arr: ["B", "R", "B", "R"], expected: ["R", "R", "B", "B"]),
    ]

    @Test("Problem 27.16 - sortColors", arguments: cases)
    func testSortColors(testCase: TestInput) {
        var arr = testCase.arr
        sortColors(&arr)
        #expect(arr == testCase.expected)
    }

    @Test("Problem 27.16 - sortColorsThreePointer", arguments: cases)
    func testSortColorsThreePointer(testCase: TestInput) {
        var arr = testCase.arr
        sortColorsThreePointer(&arr)
        #expect(arr == testCase.expected)
    }
}
