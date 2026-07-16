import Testing
@testable import CodingInterview

struct Problem36_4Tests {
    struct TestInput {
        let list: [[Int]]
    }

    @Test(
        "Problem 36.4 - returns a valid spanning tree",
        arguments: [
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
                    [0]
                ]
            ),
            TestInput(
                list: [
                    [1, 2],
                    [0, 2],
                    [0, 1]
                ]
            ),
            TestInput(
                list: [
                    [1],
                    [0, 2],
                    [1, 3],
                    [2]
                ]
            ),
            TestInput(list: [[]])
        ]
    )
    func testSpanningTree(_ testCase: TestInput) {
        let graph = AdjGraph(list: testCase.list)
        guard graph.validate() else {
            Issue.record("Invalid undirected graph fixture: \(testCase.list)")
            return
        }

        guard isConnected(testCase.list) else {
            Issue.record("Disconnected graph fixture: \(testCase.list)")
            return
        }

        let treeEdges = spanningTree(adjGraph: testCase.list)
        let errors = spanningTreeValidationErrors(treeEdges, for: testCase.list)

        if !errors.isEmpty {
            Issue.record(
                """
                Expected valid spanning tree for \(testCase.list), got \(treeEdges).
                Problems: \(errors.joined(separator: " | "))
                """
            )
        }
    }

    private struct UndirectedEdge: Hashable {
        let first: Int
        let second: Int

        init(_ first: Int, _ second: Int) {
            self.first = min(first, second)
            self.second = max(first, second)
        }
    }

    private func spanningTreeValidationErrors(_ treeEdges: [[Int]], for graph: [[Int]]) -> [String] {
        var errors = [String]()
        let nodeCount = graph.count
        let expectedEdgeCount = max(0, nodeCount - 1)

        if treeEdges.count != expectedEdgeCount {
            errors.append("expected \(expectedEdgeCount) edges, got \(treeEdges.count)")
        }

        var originalEdges = Set<UndirectedEdge>()
        for (vertex, neighbors) in graph.enumerated() {
            for neighbor in neighbors where vertex < neighbor {
                originalEdges.insert(UndirectedEdge(vertex, neighbor))
            }
        }

        var parent = Array(0..<nodeCount)
        var treeAdjacency = Array(repeating: [Int](), count: nodeCount)
        var seenEdges = Set<UndirectedEdge>()

        func find(_ node: Int) -> Int {
            var current = node
            while parent[current] != current {
                parent[current] = parent[parent[current]]
                current = parent[current]
            }
            return current
        }

        func union(_ first: Int, _ second: Int) -> Bool {
            let firstRoot = find(first)
            let secondRoot = find(second)
            guard firstRoot != secondRoot else { return false }

            parent[secondRoot] = firstRoot
            return true
        }

        for (index, edge) in treeEdges.enumerated() {
            guard edge.count == 2 else {
                errors.append("edge at index \(index) must contain exactly two vertices")
                continue
            }

            let first = edge[0]
            let second = edge[1]
            guard (0..<nodeCount).contains(first), (0..<nodeCount).contains(second) else {
                errors.append("edge \(edge) contains a vertex out of bounds for graph size \(nodeCount)")
                continue
            }

            guard first != second else {
                errors.append("edge \(edge) is a self-loop")
                continue
            }

            let normalizedEdge = UndirectedEdge(first, second)
            guard originalEdges.contains(normalizedEdge) else {
                errors.append("edge \(edge) is not in the original graph")
                continue
            }

            guard seenEdges.insert(normalizedEdge).inserted else {
                errors.append("edge \(edge) is duplicated")
                continue
            }

            if !union(first, second) {
                errors.append("edge \(edge) creates a cycle")
            }

            treeAdjacency[first].append(second)
            treeAdjacency[second].append(first)
        }

        if !isConnected(treeAdjacency) {
            errors.append("tree edges do not connect all vertices")
        }

        return errors
    }

    private func isConnected(_ graph: [[Int]]) -> Bool {
        guard !graph.isEmpty else {
            return true
        }

        var visited: Set<Int> = [0]
        var queue = [0]
        var head = 0

        while head < queue.count {
            let current = queue[head]
            head += 1

            for neighbor in graph[current] where !visited.contains(neighbor) {
                visited.insert(neighbor)
                queue.append(neighbor)
            }
        }

        return visited.count == graph.count
    }
}
