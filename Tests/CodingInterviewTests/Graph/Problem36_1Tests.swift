import Testing
@testable import CodingInterview

struct Problem36_1Tests {
    struct TestInput {
        let list: [[Int]]
        let expected: Bool
    }

    @Test(
        "Problem 36.1 - validate undirected adjacency list",
        arguments: [
            // Valid graphs.
            TestInput(list: [], expected: true),
            TestInput(list: [[1], [0]], expected: true),
            TestInput(
                list: [
                    [1, 2],
                    [0, 2],
                    [0, 1]
                ],
                expected: true
            ),
            // Invalid: node out of range.
            TestInput(list: [[2], [0]], expected: false),
            TestInput(list: [[-1]], expected: false),
            // Invalid: self-loop.
            TestInput(list: [[0], []], expected: false),
            // Invalid: parallel edges.
            TestInput(list: [[1, 1], [0, 0]], expected: false),
            // Invalid: missing reciprocal edge.
            TestInput(list: [[1], []], expected: false)
        ]
    )
    func testValidate(_ testCase: TestInput) {
        let graph = AdjGraph(list: testCase.list)
        #expect(graph.validate() == testCase.expected)
    }
}
