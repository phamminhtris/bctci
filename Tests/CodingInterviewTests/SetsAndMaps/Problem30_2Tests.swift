import CodingInterview
import Testing

struct Problem30_2Tests {
    struct TestInput {
        let inputs: [(String, String)]
        let expected: String
    }

    @Test(
        "Problem 30.2",
        arguments: [
            TestInput(
                inputs: [
                    ("203.0.113.10", "mike"), ("208.51.100.25", "bob"),
                    ("202.0.2.5", "mike"), ("203.0.113.15", "bob2"),
                ],
                expected: "mike"
            ),
            TestInput(
                inputs: [
                    ("1.1.1.1", "alice"), ("1.1.1.2", "bob"),
                    ("1.1.1.3", "alice"), ("1.1.1.4", "bob"),
                ],
                expected: "alice"  // or "bob"
            ),
        ]
    )
    func testMostSharedAccount(testCase: TestInput) {
        #expect(
            CodingInterview.mostSharedAccount(connections: testCase.inputs)
                == testCase.expected
        )
    }
}
