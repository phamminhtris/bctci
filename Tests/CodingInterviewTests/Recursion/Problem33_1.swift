//
//  Problem33_1.swift
//  CodingInterview
//
//  Created by Tri Pham on 3/7/26.
//

import Testing

@testable import CodingInterview

struct Problem33_1Tests {
    struct TestInput {
        let seq: String
        let expected: String
    }

    static let testCases: [TestInput] = [
        TestInput(seq: "", expected: ""),
        TestInput(seq: "L", expected: "L"),
        TestInput(seq: "R", expected: "R"),
        TestInput(seq: "LR", expected: "LR"),
        TestInput(seq: "2LR", expected: "LRR"),
        TestInput(seq: "2L", expected: "L"),
        TestInput(seq: "22LR", expected: "LRRLR"),
        TestInput(seq: "LL2R2L", expected: "LLRLL"),
        TestInput(seq: "2R2L", expected: "RLL"),
        TestInput(seq: "2RLRL", expected: "RLRLLRL")
    ]

    @Test(
        "Problem 33.1 - move",
        arguments: testCases
    )
    func testMove(testCase: TestInput) {
        #expect(move(seq: testCase.seq) == testCase.expected)
    }

    @Test(
        "Problem 33.1 - moveIterative",
        arguments: testCases
    )
    func testMoveIterative(testCase: TestInput) {
        #expect(moveIterative(seq: testCase.seq) == testCase.expected)
    }
}
