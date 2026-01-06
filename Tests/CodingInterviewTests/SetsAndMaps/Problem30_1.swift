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
            
            // Multiple occurrences (3+) - should return first duplicate
            TestInput(
                inputs: [
                    ("1.1.1.1", "alice"), ("2.2.2.2", "bob"),
                    ("3.3.3.3", "alice"), ("4.4.4.4", "alice"),
                ],
                expected: "3.3.3.3"
            ),
            
            // Case sensitivity - "Alice" and "alice" should be different
            TestInput(
                inputs: [("1.1.1.1", "Alice"), ("2.2.2.2", "alice")],
                expected: ""
            ),
            
            // Special characters in username
            TestInput(
                inputs: [("1.1.1.1", "user@123"), ("2.2.2.2", "user@123")],
                expected: "2.2.2.2"
            ),
            
            // Minimum username length (1 character)
            TestInput(
                inputs: [("1.1.1.1", "a"), ("2.2.2.2", "a")],
                expected: "2.2.2.2"
            ),
            
            // Maximum username length (30 characters)
            TestInput(
                inputs: [
                    ("1.1.1.1", "abcdefghijklmnopqrstuvwxyz1234"),
                    ("2.2.2.2", "abcdefghijklmnopqrstuvwxyz1234"),
                ],
                expected: "2.2.2.2"
            ),
        ]
    )
    func testSharedUsername(testCase: TestInput) {
        #expect(
            CodingInterview.sharedUsername(connections: testCase.inputs)
                == testCase.expected
        )
    }
}
