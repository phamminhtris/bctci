//
//  Problem30_1.swift
//  CodingInterview
//
//  Created by Tri Pham on 1/5/26.
//

import CodingInterview
import Testing

struct Problem30_1Tests {
    struct TestInput {
        let inputs: [(String, String)]
        let expected: String
    }
    @Test(
        "Problem 30.1",
        arguments: [
            TestInput(
                inputs: [
                    ("203.0.113.10", "mike"), ("298.51.100.25", "bob"),
                    ("292.0.2.5", "mike"), ("203.0.113.15", "bob2"),
                ],
                expected: "292.0.2.5"
            ),
            TestInput(
                inputs: [
                    ("111.0.0.0", "mike"), ("111.0.0.1", "mike"),
                    ("111.0.0.2", "bob"), ("111.0.0.3", "bob"),
                ],
                expected: "111.0.0.1"
            ),
            TestInput(
                inputs: [
                    ("111.0.0.0", "mike"), ("111.0.0.1", "mike2"),
                    ("111.0.0.2", "mike3"), ("111.0.0.3", "mike4"),
                ],
                expected: ""
            ),

            TestInput(inputs: [], expected: ""),
            TestInput(inputs: [("1.1.1.1", "alice")], expected: ""),
        ]
    )
    func testSharedUsername(testCase: TestInput) {
        #expect(
            CodingInterview.sharedUsername(connections: testCase.inputs)
                == testCase.expected
        )
    }
}
