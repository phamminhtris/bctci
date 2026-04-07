import Testing
@testable import CodingInterview

struct AdjacencyListProblemSetTests {
    struct TestInput {
        let list: [[Int]]
        let expectedNodeCount: Int
        let expectedEdgeCount: Int
    }

    @Test(
        "AdjGraph - undirected graph counts",
        arguments: [
            TestInput(
                list: [],
                expectedNodeCount: 0,
                expectedEdgeCount: 0
            ),
            TestInput(
                list: [[], [], []],
                expectedNodeCount: 3,
                expectedEdgeCount: 0
            ),
            TestInput(
                list: [
                    [1],
                    [0]
                ],
                expectedNodeCount: 2,
                expectedEdgeCount: 1
            ),
            TestInput(
                list: [
                    [1],
                    [0, 2],
                    [1]
                ],
                expectedNodeCount: 3,
                expectedEdgeCount: 2
            ),
            TestInput(
                list: [
                    [1, 2],
                    [0, 2],
                    [0, 1]
                ],
                expectedNodeCount: 3,
                expectedEdgeCount: 3
            )
        ]
    )
    func testUndirectedCounts(_ testCase: TestInput) {
        let graph = AdjGraph(list: testCase.list)

        #expect(graph.numNodes == testCase.expectedNodeCount)
        #expect(graph.numEdges == testCase.expectedEdgeCount)
    }

    @Test("AdjGraph - degree")
    func testDegree() {
        let graph = AdjGraph(
            list: [
                [1],
                [0, 2],
                [1, 3],
                [2]
            ]
        )

        #expect(graph.degree(of: 0) == 1)
        #expect(graph.degree(of: 1) == 2)
        #expect(graph.degree(of: 2) == 2)
        #expect(graph.degree(of: 3) == 1)
    }

    struct EdgeListInput {
        let numVertex: Int
        let edges: [[Int]]
        let expectedList: [[Int]]
        let expectedEdgeCount: Int
    }

    @Test(
        "AdjGraph - init from edge list (undirected)",
        arguments: [
            EdgeListInput(
                numVertex: 0,
                edges: [],
                expectedList: [],
                expectedEdgeCount: 0
            ),
            EdgeListInput(
                numVertex: 4,
                edges: [],
                expectedList: [[], [], [], []],
                expectedEdgeCount: 0
            ),
            EdgeListInput(
                numVertex: 3,
                edges: [[0, 1], [1, 2]],
                expectedList: [
                    [1],
                    [0, 2],
                    [1]
                ],
                expectedEdgeCount: 2
            ),
            EdgeListInput(
                numVertex: 4,
                edges: [[0, 2], [1, 2], [2, 3]],
                expectedList: [
                    [2],
                    [2],
                    [0, 1, 3],
                    [2]
                ],
                expectedEdgeCount: 3
            )
        ]
    )
    func testInitFromUndirectedEdgeList(_ testCase: EdgeListInput) {
        let graph = AdjGraph(numVertex: testCase.numVertex, edges: testCase.edges)

        #expect(graph.outerList == testCase.expectedList)
        #expect(graph.numNodes == testCase.numVertex)
        #expect(graph.numEdges == testCase.expectedEdgeCount)
    }
}
