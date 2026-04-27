import Testing
@testable import CodingInterview

struct Problem36_3Tests {
    struct TestInput {
        let list: [[Int]]
    }

    @Test(
        "Problem 36.3 - returns true for connected acyclic graphs",
        arguments: [
            TestInput(list: [[]]),
            TestInput(
                list: [
                    [1],
                    [0]
                ]
            ),
            TestInput(
                list: [
                    [2],
                    [2, 5],
                    [0, 1, 3, 4],
                    [2],
                    [2],
                    [1]
                ]
            ),
            TestInput(
                list: [
                    [1],
                    [0, 2],
                    [1, 3],
                    [2]
                ]
            )
        ]
    )
    func testIsTreeTrueCases(_ testCase: TestInput) {
        let graph = AdjGraph(list: testCase.list)
        guard graph.validate() else {
            Issue.record("Invalid undirected graph fixture: \(testCase.list)")
            return
        }

        #expect(graph.isTree())
    }

    @Test(
        "Problem 36.3 - returns false for disconnected or cyclic graphs",
        arguments: [
            TestInput(
                list: [
                    [2],
                    [5],
                    [0, 3],
                    [2],
                    [],
                    [1]
                ]
            ),
            TestInput(
                list: [
                    [1],
                    [0, 2, 5],
                    [1, 3, 4],
                    [2],
                    [2, 5],
                    [1, 4]
                ]
            ),
            TestInput(
                list: [
                    [1],
                    [0],
                    []
                ]
            ),
            TestInput(
                list: [
                    [1, 2],
                    [0, 2],
                    [0, 1]
                ]
            )
        ]
    )
    func testIsTreeFalseCases(_ testCase: TestInput) {
        let graph = AdjGraph(list: testCase.list)
        guard graph.validate() else {
            Issue.record("Invalid undirected graph fixture: \(testCase.list)")
            return
        }

        #expect(!graph.isTree())
    }
}
