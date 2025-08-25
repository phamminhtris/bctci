//
//  BinarySearchTests.swift
//  BCTCITests
//
//  Created by Tri Pham on 8/23/25.
//

import BCTCI
import Testing

struct BinarySearchTests {
    struct ValleyBottomTestCase {
        let valley: [Int]
        let smallestValue: Int
    }

    @Test("Test Valley Bottom", arguments: [
        ValleyBottomTestCase(valley: [6, 5, 4, 7, 9], smallestValue: 4),
        ValleyBottomTestCase(valley: [666, 555, 0, 44, 10000], smallestValue: 0),
        ValleyBottomTestCase(valley: [1, 2, 3, 4, 5, 6, 7, 8, 9], smallestValue: 1),
        ValleyBottomTestCase(valley: [9, 1, 0], smallestValue: 0)
    ])
    func valleyBottom_givenValidInput_returnSmallestValues(input: ValleyBottomTestCase) async throws {
        #expect(BCTCI.valleyBottom(valley: input.valley) == input.smallestValue)
    }

    struct TwoArrayTwoSumTestCase {
        let sorted: [Int]
        let unsorted: [Int]
        let res: [Int]
    }

    @Test("2-Array 2-Sum test", arguments: [
        TwoArrayTwoSumTestCase(
            sorted: [-5, -4, -1, 4, 6, 6, 7],
            unsorted: [-3, 7, 18, 4, 6],
            res: [1, 3]
        ),
        TwoArrayTwoSumTestCase(
            sorted: [-1, 0, 1],
            unsorted: [4, 5],
            res: [-1, -1]
        ),
        TwoArrayTwoSumTestCase(
            sorted: [-1],
            unsorted: [1, 0],
            res: [0, 0]
        )
    ])
    func twoArrayTwoSum(input: TwoArrayTwoSumTestCase) {
        #expect(
            BCTCI.twoArrayTwoSum(
                sorted: input.sorted,
                unsorted: input.unsorted
            ) == input
                .res)
    }
}
