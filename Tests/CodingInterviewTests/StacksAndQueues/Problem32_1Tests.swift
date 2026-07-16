//
//  Problem32_1.swift
//  CodingInterview
//
//  Created by Tri Pham on 2/8/26.
//

import Testing

@testable import CodingInterview

struct Problem32_1Tests {
    struct TestInput {
        let arr: [Int]
        let expected: [Int]
    }

    @Test(
        "Problem 32.1 - compressArray",
        arguments: [
            // Prompt example 1
            TestInput(arr: [8, 4, 2, 2, 2, 4], expected: [16, 2, 4]),
            // No compressions should preserve original order.
            TestInput(arr: [1, 2, 3, 4], expected: [1, 2, 3, 4]),
            // Multiple cascading merges across the array.
            TestInput(arr: [2, 2, 4, 4, 8, 8], expected: [8, 4, 16]),
            // Merge in the middle triggers another merge with the left neighbor.
            TestInput(arr: [2, 1, 1, 2], expected: [4, 2]),
        ]
    )
    func testCompressArray(testCase: TestInput) {
        #expect(compressArray(testCase.arr) == testCase.expected)
    }
}
