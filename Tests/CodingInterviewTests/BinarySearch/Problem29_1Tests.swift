import Testing
@testable import CodingInterview

struct Problem29_1Tests {
    struct TestInput {
        let name: String
        let arr: [Int]
        let target: Int
        let expected: Int
    }

    @Test(
        "Problem 29.1 - binarySearch finds an existing target",
        arguments: [
            TestInput(name: "prompt example 1", arr: [-2, 0, 3, 4, 7, 9, 11], target: 3, expected: 2),
            TestInput(name: "prompt example 3", arr: [1, 2, 3], target: 1, expected: 0),
            TestInput(name: "first element", arr: [-2, 0, 3, 4, 7, 9, 11], target: -2, expected: 0),
            TestInput(name: "last element", arr: [-2, 0, 3, 4, 7, 9, 11], target: 11, expected: 6),
            TestInput(name: "exact midpoint", arr: [-2, 0, 3, 4, 7, 9, 11], target: 4, expected: 3),
            TestInput(name: "single element", arr: [5], target: 5, expected: 0),
            TestInput(name: "two elements, left", arr: [5, 8], target: 5, expected: 0),
            TestInput(name: "two elements, right", arr: [5, 8], target: 8, expected: 1),
            TestInput(name: "even length, left of midpoint", arr: [1, 3, 5, 7], target: 3, expected: 1),
            TestInput(name: "even length, right of midpoint", arr: [1, 3, 5, 7], target: 5, expected: 2),
            TestInput(name: "all negatives", arr: [-9, -7, -5, -3], target: -7, expected: 1),
            TestInput(name: "constraint upper bound", arr: [-1_000_000_000, 0, 1_000_000_000], target: 1_000_000_000, expected: 2)
        ]
    )
    func testTargetFound(_ testCase: TestInput) {
        #expect(binarySearch(testCase.arr, testCase.target) == testCase.expected, "\(testCase.name)")
    }

    @Test(
        "Problem 29.1 - binarySearch returns -1 when the target is absent",
        arguments: [
            TestInput(name: "prompt example 2", arr: [-2, 0, 3, 4, 7, 9, 11], target: 2, expected: -1),
            TestInput(name: "empty array", arr: [], target: 1, expected: -1),
            TestInput(name: "below the smallest", arr: [-2, 0, 3, 4, 7, 9, 11], target: -100, expected: -1),
            TestInput(name: "above the largest", arr: [-2, 0, 3, 4, 7, 9, 11], target: 100, expected: -1),
            TestInput(name: "gap between neighbours", arr: [1, 3, 5, 7], target: 6, expected: -1),
            TestInput(name: "single element, no match", arr: [5], target: 4, expected: -1),
            TestInput(name: "two elements, no match", arr: [5, 8], target: 7, expected: -1),
            TestInput(name: "constraint lower bound", arr: [-1_000_000_000, 0, 1_000_000_000], target: -999_999_999, expected: -1)
        ]
    )
    func testTargetAbsent(_ testCase: TestInput) {
        #expect(binarySearch(testCase.arr, testCase.target) == testCase.expected, "\(testCase.name)")
    }

    @Test("Problem 29.1 - binarySearch resolves every index of a large array")
    func testEveryIndexOfLargeArray() {
        let arr = (0..<10_000).map { $0 * 2 }

        let misresolvedCount = arr.enumerated().count { index, value in
            binarySearch(arr, value) != index || binarySearch(arr, value + 1) != -1
        }

        #expect(misresolvedCount == 0, "\(misresolvedCount) of \(arr.count) values resolved incorrectly")
    }
}
