import Testing
@testable import CodingInterview

struct Problem36_5Tests {
    struct TestInput {
        let graph: [[Int]]
        let queries: [[Int]]
        let expected: [Bool]
    }

    @Test(
        "Problem 36.5 - answers connected component reachability queries",
        arguments: [
            TestInput(
                graph: [
                    [1],
                    [0, 2, 5, 4],
                    [1, 4, 5],
                    [],
                    [5, 2, 1],
                    [1, 2, 4]
                ],
                queries: [[0, 4], [0, 3]],
                expected: [true, false]
            ),
            TestInput(
                graph: [
                    [1],
                    [0, 2],
                    [1]
                ],
                queries: [[0, 2], [0, 1]],
                expected: [true, true]
            ),
            TestInput(
                graph: [
                    [1],
                    [0],
                    [3],
                    [2]
                ],
                queries: [[0, 1], [0, 2], [2, 3]],
                expected: [true, false, true]
            ),
            TestInput(
                graph: [
                    [],
                    [],
                    [3],
                    [2]
                ],
                queries: [[0, 0], [0, 1], [2, 3], [1, 3]],
                expected: [true, false, true, false]
            )
        ]
    )
    func testReachabilityQuery(_ testCase: TestInput) {
        let graph = AdjGraph(list: testCase.graph)
        guard graph.validate() else {
            Issue.record("Invalid undirected graph fixture: \(testCase.graph)")
            return
        }

        #expect(reachabilityQuery(adjGraph: testCase.graph, queries: testCase.queries) == testCase.expected)
    }
}
