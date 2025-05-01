//
//  TwoPointersTests.swift
//  BCTCITests
//
//  Created by Tri Pham on 4/30/25.
//

@testable import BCTCI
import Testing

struct TwoPointersTests {
    @Test("Three Way Merge Without Duplicates", arguments: [
        ([2, 3, 3, 4, 5, 7], [3, 3, 9], [3, 3, 9], [2, 3, 4, 5, 7, 9]),
        ([0, 0], [], [1], [0, 1]),
        ([], [], [], []),
        ([-1, 2, 5], [6, 9], [1, 100], [-1, 1, 2, 5, 6, 9, 100])
    ])
    func threeWayMergeWithoutDuplicates(inputs: ([Int], [Int], [Int], [Int])) {
        let (arr1, arr2, arr3, result) = inputs
        #expect(
            BCTCI.threeWayMergeWithoutDuplicates(
                arr1: arr1,
                arr2: arr2,
                arr3: arr3
            ) == result
        )
    }
}
