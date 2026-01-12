//
//  Test.swift
//  CodingInterview
//
//  Created by Tri Pham on 1/12/26.
//

import Testing

@testable import CodingInterview

struct Problem30_4Tests {

    struct TestCase {
        let users: [(String, [String])]
        let expected: Bool
    }

    @Test(
        "testMultiAccountCheating",
        arguments: [
            TestCase(
                users: [
                    ("mike", ["203.0.3.10", "208.51.0.5", "52.0.2.5"]),
                    ("bob", ["111.0.0.10", "222.0.0.5", "222.0.0.8"]),
                    ("bob2", ["222.0.0.5", "222.0.0.8", "111.0.0.10"]),
                ],
                expected: true
            ),
            TestCase(
                users: [
                    ("alice", ["1.1.1.1"]),
                    ("bob", ["2.2.2.2"]),
                ],
                expected: false
            ),
            TestCase(users: [], expected: false),
            TestCase(users: [("alice", ["1.1.1.1"])], expected: false),
            TestCase(
                users: [
                    ("bob", ["2.2.2.2", "1.1.1.1"]), ("alice", ["1.1.1.1"]),
                    ("bob", ["2.2.2.2"]),
                ],
                expected: false
            ),
        ]
    )
    func testMultiAccountCheating(testCase: TestCase) async throws {
        #expect(
            CodingInterview.multiAccountCheating(testCase.users)
                == testCase.expected
        )
    }

}
