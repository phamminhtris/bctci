import Testing
@testable import CodingInterview

struct Problem29_3Tests {
    struct TestInput {
        let name: String
        let arr: [Int]
        let expected: Int
    }

    @Test(
        "Problem 29.3 - smallestInValley finds the valley bottom",
        arguments: [
            TestInput(name: "prompt example 1", arr: [6, 5, 4, 7, 9], expected: 4),
            TestInput(name: "prompt example 2, empty decreasing prefix beyond the first element", arr: [5, 6, 7], expected: 5),
            TestInput(name: "prompt example 3, empty increasing suffix beyond the last element", arr: [7, 6, 5], expected: 5),
            TestInput(name: "shortest valley, decreasing", arr: [2, 1], expected: 1),
            TestInput(name: "shortest valley, increasing", arr: [1, 2], expected: 1),
            TestInput(name: "bottom just before the end", arr: [9, 7, 3, 1, 4], expected: 1),
            TestInput(name: "bottom just after the start", arr: [8, 2, 3, 5, 11], expected: 2),
            TestInput(name: "even length, bottom left of center", arr: [10, 4, 6, 7, 8, 9], expected: 4),
            TestInput(name: "even length, bottom right of center", arr: [10, 9, 8, 7, 1, 5], expected: 1),
            TestInput(name: "negative values only", arr: [-3, -7, -6, -5], expected: -7),
            TestInput(name: "spans zero", arr: [4, 1, 0, -2, 3, 6], expected: -2),
            TestInput(name: "constraint bounds", arr: [1_000_000_000, 0, -1_000_000_000, 999_999_999], expected: -1_000_000_000)
        ]
    )
    func testFindsSmallestValue(_ testCase: TestInput) {
        #expect(smallestInValley(testCase.arr) == testCase.expected, "\(testCase.name)")
    }

    @Test("Problem 29.3 - smallestInValley handles every bottom position in a fixed-length valley")
    func testEveryBottomPosition() {
        let length = 200

        let wrongCount = (0..<length).count { bottomIndex in
            // Decreasing prefix ending at `bottomIndex`, then an increasing suffix.
            let prefix = (0...bottomIndex).map { -$0 }
            let suffix = (1..<(length - bottomIndex)).map { 1_000 + $0 }
            return smallestInValley(prefix + suffix) != -bottomIndex
        }

        #expect(wrongCount == 0, "\(wrongCount) of \(length) bottom positions resolved incorrectly")
    }

    @Test("Problem 29.3 - smallestInValley handles the maximum input size")
    func testMaximumInputSize() {
        let half = 500_000
        let prefix = Array((1...half).reversed())
        let suffix = (1...half).map { 1_000_000 + $0 }

        #expect(smallestInValley(prefix + suffix) == 1)
    }
}
