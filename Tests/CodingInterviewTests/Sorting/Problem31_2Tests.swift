//
//  Problem31_2.swift
//  CodingInterview
//
//  Created by Tri Pham on 1/30/26.
//

@testable import CodingInterview
import Testing

struct Problem31_2Tests {
    struct TestInput {
        let circles: [Circle]
        let expected: Bool
    }

    @Test(
        "Problem 31.2",
        arguments: [
            TestInput(
                circles: [
                    Circle(center: (4, 4), radius: 5),
                    Circle(center: (8, 4), radius: 2),
                ],
                expected: false
            ),
            TestInput(
                circles: [
                    Circle(center: (5, 3), radius: 3),
                    Circle(center: (5, 3), radius: 2),
                    Circle(center: (4, 4), radius: 5),
                ],
                expected: true
            ),
            TestInput(
                circles: [Circle(center: (5, 3), radius: 3)],
                expected: true
            ),
            TestInput(
                circles: [],
                expected: false
            ),
            // Touching boundary is not nested (strictly inside required).
            TestInput(
                circles: [
                    Circle(center: (0, 0), radius: 3),
                    Circle(center: (0, 0), radius: 3),
                ],
                expected: false
            ),
            // Order should not matter.
            TestInput(
                circles: [
                    Circle(center: (0, 0), radius: 10),
                    Circle(center: (1, 1), radius: 2),
                    Circle(center: (2, 2), radius: 1),
                ].shuffled(),
                expected: false
            ),
        ]
    )
    func testAreCirclesNested(testCase: TestInput) {
        #expect(CodingInterview.areCirclesNested(testCase.circles) == testCase.expected)
    }
}
