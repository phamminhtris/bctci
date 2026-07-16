//
//  Problem33_2.swift
//  CodingInterview
//
//  Created by Codex on 3/10/26.
//

import Testing

@testable import CodingInterview

struct Problem33_2Tests {
    struct TestInput {
        let arr: [NestArray]
        let expected: Int
    }

    static func toNestArray(_ values: [Int]) -> [NestArray] {
        values.map { .int($0) }
    }

    static let range0To9 = toNestArray(Array(0..<10))
    static let range10To19 = toNestArray(Array(10..<20))
    static let range20To29 = toNestArray(Array(20..<30))
    static let range30To39 = toNestArray(Array(30..<40))
    static let range40To49 = toNestArray(Array(40..<50))
    static let range50To59 = toNestArray(Array(50..<60))

    static let testCases: [TestInput] = [
        TestInput(
            arr: [
                .int(1),
                .array([.int(2), .int(3)]),
                .array([.int(4), .array([.int(5)])]),
                .int(6)
            ],
            expected: 21
        ),
        TestInput(
            arr: [
                .array([
                    .array([
                        .array([
                            .array([.int(1)])
                        ])
                    ]),
                    .int(2)
                ])
            ],
            expected: 3
        ),
        TestInput(
            arr: [],
            expected: 0
        ),
        TestInput(
            arr: [
                .array([.array([.array([.array([.array([.int(1)])])])])])
            ],
            expected: 1
        ),
        TestInput(
            arr: [
                .array([]),
                .array([]),
                .array([])
            ],
            expected: 0
        ),
        TestInput(
            arr: [
                .array([]),
                .array([.int(1), .int(2)]),
                .array([]),
                .array([.int(3)])
            ],
            expected: 6
        ),
        TestInput(
            arr: [
                .int(1),
                .array([
                    .int(2),
                    .array([]),
                    .array([.int(3), .array([])]),
                    .array([])
                ]),
                .array([.int(4), .array([.int(5), .array([])])])
            ],
            expected: 15
        ),
        TestInput(
            arr: [
                .int(0),
                .array([.int(0), .int(0)]),
                .array([.int(0), .array([.int(0)])]),
                .int(0)
            ],
            expected: 0
        ),
        TestInput(
            arr: [
                .int(-1),
                .array([.int(-2), .int(3)]),
                .array([.int(4), .array([.int(-5)])]),
                .int(6)
            ],
            expected: 5
        ),
        TestInput(
            arr: [
                .array(range0To9),
                .array([
                    .array(range10To19),
                    .array(range20To29)
                ]),
                .array([
                    .array(range30To39),
                    .array([.array(range40To49)])
                ]),
                .array(range50To59)
            ],
            expected: 1770
        )
    ]

    @Test(
        "Problem 33.2 - nestedArraySum",
        arguments: testCases
    )
    func testNestedArraySum(testCase: TestInput) {
        #expect(nestedArraySum(arr: testCase.arr) == testCase.expected)
    }
}
