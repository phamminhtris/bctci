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

    @Test("Sort Valley-Shape Array", arguments: [
        ([8, 4, 2, 6], [2, 4, 6, 8]),
        ([1, 2], [1, 2]),
        ([1, 1, 2, 2], [1, 1, 2, 2])
    ])
    func sortValleyShapeArray(inputs: ([Int], [Int])) {
        let (arr, result) = inputs
        #expect(BCTCI.sortValleyShapeArray(arr) == result)
    }

    struct MissinNumbersInRangeInput {
        let arr: [Int]
        let range: ClosedRange<Int>
        let result: [Int]
    }

    @Test("Missing Numbers in Range", arguments: [
        MissinNumbersInRangeInput(arr: [6, 9, 12, 15, 18], range: 9...13, result: [10, 11, 13]),
        MissinNumbersInRangeInput(arr: [], range: 9...9, result: [9]),
        MissinNumbersInRangeInput(arr: [6, 7, 8, 9], range: 7...8, result: [])
    ])
    func missingNumbersInRange(_ input: MissinNumbersInRangeInput) {
        let res = BCTCI.missingNumbersInRange(
                input.arr,
                low: input.range.lowerBound,
                high: input.range.upperBound
        )
        #expect(res == input.result)
    }
}
