//
//  Problem31_1.swift
//  CodingInterview
//
//  Created by Tri Pham on 1/30/26.
//

@testable import CodingInterview
import Testing

struct Problem31_1Tests {
    struct TestInput {
        let input: String
        let expected: [Character]
    }

    @Test(
        "Problem 31.1",
        arguments: [
            TestInput(
                input: "supercalifragilisticexpialidocious",
                expected: Array("iaclseoprudfgtx")
            ),
            TestInput(
                input: "aabbbcccc",
                expected: Array("cba")
            ),
            TestInput(
                input: "abc",
                expected: Array("abc")
            ),
            TestInput(
                input: "",
                expected: []
            ),
            TestInput(
                input: "z",
                expected: ["z"]
            ),
            TestInput(
                input: "bbccaa",
                expected: Array("abc")
            ),
        ]
    )
    func testSortLetter(testCase: TestInput) {
        #expect(CodingInterview.sortLetter(testCase.input) == testCase.expected)
    }
}
