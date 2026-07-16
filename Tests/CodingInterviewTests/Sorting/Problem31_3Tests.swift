//
//  Problem31_3.swift
//  CodingInterview
//
//  Created by Tri Pham on 1/30/26.
//

import Testing

@testable import CodingInterview

struct Problem31_3Tests {
    struct TestInput {
        let nums: [Int]
        let operations: [Int]
        let expected: [Int]
    }

    @Test(
        "Problem 31.3",
        arguments: [
            TestInput(nums: [], operations: [], expected: []),
            TestInput(nums: [50, 30, 70, 20, 80], operations: [2, -1, 4, -1], expected: [50]),
            TestInput(nums: [1, 2, 3], operations: [], expected: [1, 2, 3]),
            TestInput(nums: [1, 2, 3], operations: [-1, -1, -1], expected: []),
            TestInput(nums: [1, 2, 3], operations: [0, 0, 0], expected: [2, 3]),
            TestInput(nums: [1, 2, 3], operations: [0, 0, 1], expected: [3]),
            TestInput(nums: [1, 1, 1], operations: [0, -1, -1], expected: []),
            // -1 must be applied in sequence, not after all index deletes.
            TestInput(nums: [5, 1, 4], operations: [-1, 1], expected: [5, 4]),
            // Output should preserve original order, not sorted order.
            TestInput(nums: [2, 1, 3], operations: [], expected: [2, 1, 3]),
            // Tie-breaking for -1 should use the smaller original index.
            TestInput(nums: [1, 9, 1], operations: [-1], expected: [9, 1]),
        ]
    )
    func testDeleteNums(testCase: TestInput) {
        #expect(deleteNums(testCase.nums, operations: testCase.operations) == testCase.expected)
    }
}
